//
// aztec

package aztec.battle.controller {

import aspire.geom.Vector2;

import flashbang.components.LocationComponent;

import aztec.battle.view.ActorView;

public class Actor extends BattleObject
    implements LocationComponent
{
    override protected function addedToMode () :void {
        super.addedToMode();
        
        _view = new ActorView(this);
        _ctx.viewObjects.addObject(_view, _ctx.board.view.objectLayer);
    }
    
    public function get x () :Number {
        return _loc.x;
    }
    
    public function set x (val :Number) :void {
        _loc.x = val;
    }
    
    public function get y () :Number {
        return _loc.y;
    }
    
    public function set y (val :Number) :void {
        _loc.y = val;
    }
    
    public function getLoc (out :Vector2 = null) :Vector2 {
        return _loc.clone(out);
    }
    
    public function getViewLoc (out :Vector2 = null) :Vector2 {
        return _ctx.board.view.boardToLocal(_loc, out);
    }
    
    protected var _loc :Vector2 = new Vector2();
    protected var _view :ActorView;
}
}
