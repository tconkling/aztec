//
// aztec

package aztec.battle.view {

import aztec.Aztec;
import aztec.battle.God;
import aztec.text.CustomTextField;

import flash.geom.Point;

import flashbang.objects.MovieObject;
import flashbang.resource.MovieResource;
import flashbang.tasks.PlayMovieTask;
import flashbang.tasks.ScaleTask;
import flashbang.tasks.SelfDestructTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;
import flashbang.util.RectMeter;

import flump.display.Movie;

import starling.text.TextFieldAutoSize;

public class TempleView extends LocalSpriteObject
{
    public static const NORMAL :int = 0;
    public static const BLOODY :int = 1;
    public static const BROKEN :int = 2;

    public function TempleView (name :String, healthColor :uint, onRight :Boolean) {
        _onRight = onRight;
        _movie = MovieResource.createMovie("aztec/temple");
        _sprite.addChild(_movie);
        addDependentObject(_healthMeter, _sprite);
        _healthMeter.sprite.x = -60;
        _healthMeter.sprite.y = -200;
        _healthMeter.maxValue = 1.0;
        _healthMeter.value = 1.0;
        _healthMeter.foregroundColor = healthColor;
        _healthMeter.backgroundColor = 0xffffff;
        _healthMeter.outlineSize = 2;
        _healthMeter.outlineColor = 0;

        addDependentObject(_defenseMeter, _sprite);
        _defenseMeter.sprite.x = -60;
        _defenseMeter.sprite.y = -230;
        _defenseMeter.maxValue = 1.0;
        _defenseMeter.value = 0.0;
        _defenseMeter.foregroundColor = 0x7D8A57;
        _defenseMeter.backgroundColor = 0xffffff;
        _defenseMeter.outlineSize = 2;
        _defenseMeter.outlineColor = 0;

        var nameField :CustomTextField = new CustomTextField(1, 1, name, Aztec.UI_FONT, 24);
        nameField.autoSize = TextFieldAutoSize.SINGLE_LINE;
        nameField.color = healthColor;
        nameField.x = -nameField.width * 0.5;
        nameField.y = -78;
        sprite.addChild(nameField);

        _viewState = NORMAL;
    }

    public function updateHealth (templeHealth :Number) :void {
        _healthMeter.value = templeHealth;
    }

    public function updateDefense (templeDefense :Number):void {
        _defenseMeter.value = templeDefense;
    }

    public function summonGod (god :God) :void {
        var godMovie :MovieObject = MovieObject.create("aztec/" + god.name());
        var loc :Point = DisplayUtil.transformPoint(GOD_LOC, _sprite, _ctx.effectLayer);
        godMovie.display.x = loc.x;
        godMovie.display.y = loc.y;
        addDependentObject(godMovie, _ctx.effectLayer);
        godMovie.display.scaleY = 0;
        godMovie.display.scaleX = 0;
        var movie :Movie = Movie(godMovie.display);
        movie.stop();
        godMovie.addTask(new SerialTask(
            new ScaleTask(_onRight ? 1 : -1, 1, 1),
            new PlayMovieTask(),
            new TimedTask(1),
            new SelfDestructTask()
        ));
    }

    public function get viewState () :int {
        return _viewState;
    }

    public function set viewState (val :int) :void {
        _viewState = val;
        _movie.goTo(val);
    }

    protected var _defenseMeter :RectMeter = new RectMeter(120, 10);
    protected var _healthMeter :RectMeter = new RectMeter(120, 20);
    protected var _movie :Movie;
    protected var _onRight :Boolean;

    protected var _viewState :int;

    protected static const GOD_LOC :Point = new Point(0, -150);
}
}
