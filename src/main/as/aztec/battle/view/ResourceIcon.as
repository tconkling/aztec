//
// aztec

package aztec.battle.view {

import flashbang.resource.MovieResource;
import flashbang.tasks.AlphaTask;
import flashbang.tasks.LocationTask;
import flashbang.tasks.ParallelTask;
import flashbang.tasks.SelfDestructTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.Easing;

import flump.display.Movie;

public class ResourceIcon extends LocalSpriteObject
{
    public static const HAPPY :int = 0;
    public static const ANGRY :int = 1;
    public static const DEFENSE :int = 2;

    public function ResourceIcon (type :int) {
        var movieName :String;
        switch (type) {
        case HAPPY: movieName = "aztec/icon_smiley"; break;
        case ANGRY: movieName = "aztec/icon_angry"; break;
        case DEFENSE:
        default:    movieName = "aztec/icon_defense"; break;
        }

        var movie :Movie = MovieResource.createMovie(movieName);
        movie.alpha = 0;
        _sprite.addChild(movie);

        addTask(new SerialTask(
            new ParallelTask(
                new LocationTask(0, -30, 0.5, Easing.easeOut, movie),
                new AlphaTask(1, 0.5, Easing.linear, movie)),
            new TimedTask(0.75),
            new AlphaTask(0, 0.25, Easing.linear, movie),
            new SelfDestructTask()));
    }

}
}
