//
// aztec

package aztec.battle.view {

import aspire.geom.Vector2;
import aspire.util.F;
import aspire.util.StringUtil;

import aztec.battle.VillagerAction;
import aztec.battle.controller.Player;
import aztec.battle.controller.Villager;
import aztec.battle.desc.GameDesc;

import flash.geom.Rectangle;

import flashbang.objects.MovieObject;
import flashbang.resource.MovieResource;
import flashbang.tasks.AlphaTask;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.LocationTask;
import flashbang.tasks.PlayMovieTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.SelfDestructTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;

import flump.display.Movie;

public class VillagerView extends LocalSpriteObject
{
    public function VillagerView (villager :Villager) {
        _villager = villager;
        _regs.addSignalListener(villager.destroyed, destroySelf);
    }

    public function get textView () :SelectableTextSprite {
        return _textView;
    }

    public function showActionAnim (action :VillagerAction, forPlayer :Player) :void {
        // sacrifice animation is not part of the VillagerView
        if (action == VillagerAction.SACRIFICE) {
            var movie :MovieObject = MovieObject.create("aztec/sacrifice");
            movie.display.x = forPlayer.desc.sacrificeLoc.x;
            movie.display.y = forPlayer.desc.sacrificeLoc.y;
            _ctx.viewObjects.addObject(movie, _ctx.effectLayer);
            movie.addTask(new SerialTask(
                new PlayMovieTask(),
                new SelfDestructTask()));

            return;
        }

        if (_movie != null) {
            _movie.removeFromParent(true);
        }

        removeNamedTasks(ACTION_ANIM);

        _movie = MovieResource.createMovie(action.getViewMovieName(_viewVariation));
        _movie.loop();
        _sprite.addChildAt(_movie, 0);

        var loc :Vector2;
        switch (action) {
        case VillagerAction.DEFAULT:
            walk();
            break;

        case VillagerAction.FESTIVAL:
            loc = randomFestivalLoc(forPlayer);
            _sprite.x = loc.x;
            _sprite.y = loc.y;
            if (forPlayer == _ctx.localPlayer) {
                addNamedTask(ACTION_ANIM, new RepeatingTask(
                    new FunctionTask(F.callback(showResourceIcon, ResourceIcon.HAPPY)),
                    new TimedTask(2)));
            }
            break;

        case VillagerAction.WORSHIP:
            loc = randomWorshipLoc(forPlayer);
            _sprite.x = loc.x;
            _sprite.y = loc.y;
            if (forPlayer == _ctx.localPlayer) {
                addNamedTask(ACTION_ANIM, new RepeatingTask(
                    new FunctionTask(F.callback(showResourceIcon, ResourceIcon.DEFENSE)),
                    new TimedTask(2)));
            }
            break;
        }
    }

    public function showResourceIcon (type :int) :void {
        var bounds :Rectangle = _movie.getBounds(_sprite);
        var loc :Vector2 = new Vector2(
            bounds.x + (bounds.width * 0.5) + rands().getNumberInRange(-10, 10),
            bounds.y + rands().getNumberInRange(-5, 5));
        loc = DisplayUtil.transformVector(loc, _sprite, _ctx.effectLayer, loc);

        var icon :ResourceIcon = new ResourceIcon(type);
        icon.display.x = loc.x;
        icon.display.y = loc.y;
        _ctx.viewObjects.addObject(icon, _ctx.effectLayer);
    }

    override protected function addedToMode () :void {
        super.addedToMode();

        _viewVariation = rands().getInRange(1, 4);

        // fade in
        _sprite.alpha = 0;
        addTask(new AlphaTask(1, 0.5));

        var loc :Vector2 = randomWalkLoc();
        _sprite.x = loc.x;
        _sprite.y = loc.y;
        showActionAnim(VillagerAction.DEFAULT, null);

        _textView = new SelectableTextSprite(StringUtil.capitalize(_villager.name));
        _textView.centered = true;
        var bounds :Rectangle = _sprite.getBounds(_sprite);
        _textView.x = (bounds.width * 0.5) + bounds.x;
        _textView.y = -_textView.height + bounds.y - 4;
        _sprite.addChild(_textView);

        _regs.addSignalListener(_ctx.villagerSelectionMgr.emphasizedVillagerChanged,
            F.callback(updateTextEmphasis));
        updateTextEmphasis();
    }

    protected function updateTextEmphasis () :void {
        // When the local player starts typing the name of villager, we shrink
        // the other villager names
        var emphasizedVillager :Villager = _ctx.villagerSelectionMgr.emphasizedVillager;
        var scale :Number = 1;
        if (emphasizedVillager != null) {
            scale = (emphasizedVillager != _villager ? 0.7 : 1.5);
        }
        _textView.scaleX = _textView.scaleY = scale;
    }

    override protected function update (dt :Number) :void {
        super.update(dt);
        _movie.advanceTime(dt);
    }

    protected function walk () :void {
        const r :Rectangle = GameDesc.villagerWalkBounds;

        var curLoc :Vector2 = new Vector2(_sprite.x, _sprite.y);
        var nextLoc :Vector2 = randomWalkLoc();
        while (nextLoc.epsilonEquals(curLoc)) {
            nextLoc = randomWalkLoc();
        }

        var speed :Number = 0;
        if (r.contains(curLoc.x, curLoc.y)) {
            speed = rands().getNumberInRange(10, 30);
        } else {
            // if we were out dancing/worshipping, move back to the walk bounds quickly
            speed = 100;
        }

        var dist :Number = nextLoc.subtract(curLoc).length;
        var time :Number = dist / speed;
        var pause :Number = rands().getNumberInRange(0.5, 5);
        if (nextLoc.x < curLoc.x) {
            _movie.scaleX = -1;
        } else if (nextLoc.x > curLoc.x) {
            _movie.scaleX = 1;
        }
        addNamedTask(ACTION_ANIM, new SerialTask(
            new LocationTask(nextLoc.x, nextLoc.y, time),
            new TimedTask(pause),
            new FunctionTask(walk)));
    }

    protected function randomWalkLoc () :Vector2 {
        var r :Rectangle = GameDesc.villagerWalkBounds;
        return new Vector2(
            r.x + rands().getNumberInRange(0, r.width),
            r.y + rands().getNumberInRange(0, r.height));
    }

    protected function randomFestivalLoc (forPlayer :Player) :Vector2 {
        var loc :Vector2 = forPlayer.desc.festivalLoc.clone(new Vector2());
        loc.y += 56;

        var angle :Number = rands().getNumber(Math.PI * 2);
        var dist :Number = rands().getNumberInRange(5, 36);

        loc.addLocal(Vector2.fromAngle(angle, dist));
        return loc;
    }

    protected function randomWorshipLoc (forPlayer :Player) :Vector2 {
        var loc :Vector2 = forPlayer.desc.templeLoc.clone(new Vector2());
        loc.x += rands().getNumberInRange(-96, 96);
        loc.y += rands().getNumberInRange(20, 68);
        return loc;
    }

    protected var _villager :Villager;
    protected var _movie :Movie;
    protected var _viewVariation :int;

    protected var _textView :SelectableTextSprite;

    protected static const SCRATCH :Vector2 = new Vector2();

    protected static const ACTION_ANIM :String = "ActionAnim";
}
}
