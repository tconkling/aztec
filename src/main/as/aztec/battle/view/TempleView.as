//
// aztec

package aztec.battle.view {

import aztec.Aztec;
import aztec.battle.God;

import flash.geom.Point;

import flashbang.objects.MovieObject;
import flashbang.resource.MovieResource;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.PlayMovieTask;
import flashbang.tasks.ScaleTask;
import flashbang.tasks.SelfDestructTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;
import flashbang.util.RectMeter;

import flump.display.Movie;

import starling.text.TextField;
import starling.utils.HAlign;

public class TempleView extends LocalSpriteObject
{
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

        addDependentObject(_defenseMeter, _sprite);
        _defenseMeter.sprite.x = -60;
        _defenseMeter.sprite.y = -230;
        _defenseMeter.maxValue = 1.0;
        _defenseMeter.value = 0.0;
        _defenseMeter.foregroundColor = 0x00FF00;

        var nameField :TextField = new TextField(200, 50, name, Aztec.UI_FONT, 24);
        nameField.hAlign = HAlign.CENTER;
        nameField.y = 20;
        nameField.x = -100;
        sprite.addChild(nameField);
    }

    public function updateHealth (templeHealth :Number) :void {
        addTask(new SerialTask(
            new TimedTask(2.5),
            new FunctionTask(function () :void {
                _healthMeter.value = templeHealth;
            })));
    }

    public function updateDefense (templeDefense :Number):void {
        addTask(new SerialTask(
            new TimedTask(2.5),
            new FunctionTask(function () :void {
                _defenseMeter.value = templeDefense;
            })));
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

    protected var _defenseMeter :RectMeter = new RectMeter(120, 10);
    protected var _healthMeter :RectMeter = new RectMeter(120, 20);
    protected var _movie :Movie;
    protected var _onRight :Boolean;
    
    protected static const GOD_LOC :Point = new Point(0, -150);

}
}
