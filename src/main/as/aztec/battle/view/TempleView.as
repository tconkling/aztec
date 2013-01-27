//
// aztec

package aztec.battle.view {

import aztec.Aztec;
import aztec.battle.God;

import flashbang.objects.MovieObject;
import flashbang.resource.ImageResource;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.LocationTask;
import flashbang.tasks.ScaleTask;
import flashbang.tasks.SelfDestructTask;
import flashbang.tasks.SerialTask;

import flashbang.util.RectMeter;

import flump.display.Movie;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import starling.display.Image;

import starling.text.TextField;
import starling.utils.HAlign;

public class TempleView extends SpriteObject
{
    public function TempleView (name :String,  healthColor :uint) {
        _movie = MovieResource.createMovie("aztec/temple");
        _sprite.addChild(_movie);
        addDependentObject(_healthMeter, _sprite);
        _healthMeter.sprite.x = -73;
        _healthMeter.sprite.y = -200;
        _healthMeter.maxValue = 1.0;
        _healthMeter.value = 1.0;
        _healthMeter.foregroundColor = healthColor;

        addDependentObject(_defenseMeter, _sprite);
        _defenseMeter.sprite.x = -73;
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

    public function updateHealth(templeHealth:Number):void {
        _healthMeter.value = templeHealth;
    }

    public function updateDefense(templeDefense:Number):void {
        _defenseMeter.value = templeDefense;
    }

    public function summonGod(god :God) :void {
        var godMovie :MovieObject = MovieObject.create("aztec/villager_01");
        godMovie.display.y = -160;
        addDependentObject(godMovie, sprite);
        godMovie.display.scaleY = 0;
        var attackImage :Image = ImageResource.createImage("aztec/img_alignment_head");
        godMovie.addTask(new SerialTask(
            new ScaleTask(1, 1, 2),
            new FunctionTask(function () :void {Movie(godMovie.display).addChild(attackImage);}),
            new LocationTask(500, 500, 2, null, attackImage),
            new SelfDestructTask()
        ));
    }

    protected var _defenseMeter :RectMeter = new RectMeter(120, 10);
    protected var _healthMeter :RectMeter = new RectMeter(120, 20);
    protected var _movie :Movie;

}
}
