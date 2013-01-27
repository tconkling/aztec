//
// aztec

package aztec.battle.view {

import flashbang.util.RectMeter;

import flump.display.Movie;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

public class TempleView extends SpriteObject
{
    public function TempleView () {
        _movie = MovieResource.createMovie("aztec/temple");
        _sprite.addChild(_movie);
        addDependentObject(_healthMeter, _sprite);
        _healthMeter.sprite.x = -73;
        _healthMeter.sprite.y = -200;
        _healthMeter.maxValue = 1.0;
        _healthMeter.value = 1.0;
        _healthMeter.foregroundColor = 0xFF0000;
    }

    protected var _healthMeter :RectMeter = new RectMeter(120, 20);
    protected var _movie :Movie;
}
}
