//
// aztec

package aztec.battle.view {

import flump.display.Movie;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

public class TempleView extends SpriteObject
{
    public function TempleView () {
        _movie = MovieResource.createMovie("aztec/temple");
        _sprite.addChild(_movie);
    }
    
    protected var _movie :Movie;
}
}
