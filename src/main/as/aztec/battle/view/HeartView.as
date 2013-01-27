package aztec.battle.view {
import aztec.battle.desc.GameDesc;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import flump.display.Movie;

public class HeartView extends SpriteObject {

    public function HeartView () {
        for (var ii :int = 0; ii < GameDesc.MAX_HEARTS; ii++) {
            var heart :Movie = MovieResource.createMovie("aztec/heart");
            heart.y = _hearts.length * -35;
            heart.alpha = .3;
            _hearts.push(heart);
            _sprite.addChildAt(heart,  0);
        }
    }

    public function addHeart () :void {
        _hearts[_active++].alpha = 1;
    }

    public function removeHeart () :void {
        _hearts[_active--].alpha = .3;
    }

    protected var _active :int;
    protected var _hearts :Vector.<Movie> = new <Movie>[];
}
}
