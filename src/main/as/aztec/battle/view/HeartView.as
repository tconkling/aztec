package aztec.battle.view {
import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import flump.display.Movie;

public class HeartView extends SpriteObject {

    public function addHeart () :void {
        var heart :Movie = MovieResource.createMovie("aztec/heart");
        heart.y = _hearts.length * -35;
        _hearts.push(heart);
        _sprite.addChild(heart);
    }

    public function removeHeart () :void {
        _sprite.removeChild(_hearts.pop());
    }

    protected var _hearts :Vector.<Movie> = new <Movie>[];
}
}
