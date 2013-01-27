//
// aztec

package aztec.battle.view {

import aztec.Aztec;

import flashbang.util.RectMeter;

import flump.display.Movie;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

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
        nameField.x = -110;
        sprite.addChild(nameField);
    }

    public function updateHealth(templeHealth:Number):void {
        _healthMeter.value = templeHealth;
    }

    public function updateDefense(templeDefense:Number):void {
        _defenseMeter.value = templeDefense;
    }

    protected var _defenseMeter :RectMeter = new RectMeter(120, 10);
    protected var _healthMeter :RectMeter = new RectMeter(120, 20);
    protected var _movie :Movie;

}
}
