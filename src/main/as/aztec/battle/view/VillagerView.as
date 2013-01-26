//
// aztec

package aztec.battle.view {

import aspire.geom.Vector2;

import flump.display.Movie;

import flashbang.resource.MovieResource;

import aztec.battle.controller.Villager;
import aztec.battle.desc.GameDesc;

public class VillagerView extends LocalSpriteObject
{
    public function VillagerView (villager :Villager) {
        _actor = villager;
        _movie = MovieResource.createMovie("aztec/villager");
        _sprite.addChild(_movie);
        
        _regs.addSignalListener(villager.destroyed, destroySelf);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        // generate our loc
        var dist :Number = rands().getNumberInRange(0, GameDesc.villagerSpread);
        var angle :Number = rands().getNumberInRange(0, Math.PI * 2);
        _loc = Vector2.fromAngle(angle, dist);
        _loc.addLocal(GameDesc.villagerLoc);
    }
    
    override protected function update (dt :Number) :void {
        var viewLoc :Vector2 = getViewLoc(_loc, SCRATCH);
        _sprite.x = viewLoc.x;
        _sprite.y = viewLoc.y;
    }
    
    protected var _actor :Villager;
    protected var _movie :Movie;
    
    protected var _loc :Vector2;
    
    protected static const SCRATCH :Vector2 = new Vector2();
}
}
