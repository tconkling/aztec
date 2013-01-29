//
// aztec

package aztec.battle.view {

import aspire.geom.Vector2;
import aspire.util.Randoms;
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
import flashbang.tasks.SelfDestructTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;

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
        case VillagerAction.WORSHIP:
            walk();
            break;
        
        case VillagerAction.FESTIVAL:
            loc = randomFestivalLoc(forPlayer);
            _sprite.x = loc.x;
            _sprite.y = loc.y;
            break;
        }
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        _viewVariation = _ctx.randomsFor(this).getInRange(1, 4);
        
        // fade in
        _sprite.alpha = 0;
        addTask(new AlphaTask(1, 0.5));
        
        var loc :Vector2 = randomWalkLoc();
        _sprite.x = loc.x;
        _sprite.y = loc.y;
        showActionAnim(VillagerAction.DEFAULT, null);
        
        _textView = new SelectableTextSprite(StringUtil.capitalize(_villager.name));
        var bounds :Rectangle = _sprite.getBounds(_sprite);
        _textView.x = ((bounds.width - _textView.width) * 0.5) + bounds.x;
        _textView.y = -_textView.height + bounds.y - 4;
        _sprite.addChild(_textView);
    }
    
    override protected function update (dt :Number) :void {
        super.update(dt);
        _movie.advanceTime(dt);
    }
    
    protected function walk () :void {
        var curLoc :Vector2 = new Vector2(_sprite.x, _sprite.y);
        var nextLoc :Vector2 = randomWalkLoc();
        while (nextLoc.epsilonEquals(curLoc)) {
            nextLoc = randomWalkLoc();
        }
        
        var rands :Randoms = _ctx.randomsFor(this);
        
        var speed :Number = rands.getNumberInRange(10, 30);
        var dist :Number = nextLoc.subtract(curLoc).length;
        var time :Number = dist / speed;
        var pause :Number = rands.getNumberInRange(0.5, 5);
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
        var rands :Randoms = _ctx.randomsFor(this);
        var r :Rectangle = GameDesc.villagerWalkBounds;
        return new Vector2(
            r.x + rands.getNumberInRange(0, r.width),
            r.y + rands.getNumberInRange(0, r.height));
    }
    
    protected function randomFestivalLoc (forPlayer :Player) :Vector2 {
        var loc :Vector2 = forPlayer.desc.festivalLoc.clone(new Vector2());
        loc.y += 36;
        
        var rands :Randoms = _ctx.randomsFor(this);
        var angle :Number = rands.getNumber(Math.PI * 2);
        var dist :Number = rands.getNumberInRange(5, 36);
        
        loc.addLocal(Vector2.fromAngle(angle, dist));
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
