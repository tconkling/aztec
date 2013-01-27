//
// aztec

package aztec.battle.view {

import flashbang.util.RectMeter;

import flump.display.Movie;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

public class TempleView extends SpriteObject
{
    public function TempleView (healthColor :uint) {
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
