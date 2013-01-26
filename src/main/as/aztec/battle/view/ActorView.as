//
// aztec

package aztec.battle.view {

import aspire.geom.Vector2;

import flump.display.Movie;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import aztec.battle.controller.Actor;

public class ActorView extends SpriteObject
{
    public function ActorView (actor :Actor) {
        _actor = actor;
        _movie = MovieResource.createMovie("aztec/villager");
        _sprite.addChild(_movie);
        
        _regs.addSignalListener(actor.destroyed, destroySelf);
    }
    
    override protected function update (dt :Number) :void {
        var loc :Vector2 = _actor.getViewLoc(SCRATCH);
        _sprite.x = loc.x;
        _sprite.y = loc.y;
    }
    
    protected var _actor :Actor;
    protected var _movie :Movie;
    
    protected static const SCRATCH :Vector2 = new Vector2();
}
}
