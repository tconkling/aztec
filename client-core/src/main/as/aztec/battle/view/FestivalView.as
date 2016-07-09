//
// aztec

package aztec.battle.view {

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import flump.display.Movie;

public class FestivalView extends SpriteObject
{
    public function FestivalView () {
        _movie = MovieResource.createMovie("aztec/festival");
        _sprite.addChild(_movie);
    }

    protected var _movie :Movie;
}
}
