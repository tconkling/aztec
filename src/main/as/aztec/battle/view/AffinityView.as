//
// aztec

package aztec.battle.view {

import flashbang.core.Flashbang;
import flashbang.core.Updatable;
import flashbang.resource.MovieResource;

import flump.display.Movie;

import starling.display.DisplayObject;

public class AffinityView extends LocalSpriteObject implements Updatable {
    public function AffinityView () {
        var movie :Movie = MovieResource.createMovie("aztec/affinity");
        _sprite.addChild(movie);

        _head = movie.getChildByName("head");

        _sprite.x = (Flashbang.stageWidth - _sprite.width) * 0.5;
        _sprite.y = 720;
    }

    public function update (dt :Number) :void {
        _head.x = MIN_X + (_ctx.localPlayer.affinity * (MAX_X - MIN_X));
    }

    protected var _head :DisplayObject;

    protected static const MIN_X :Number = 100;
    protected static const MAX_X :Number = 618;
}
}
