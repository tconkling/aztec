//
// aztec

package aztec.battle.controller {

import starling.display.DisplayObjectContainer;

import aspire.util.Preconditions;

import flashbang.core.AppMode;
import flashbang.core.GameObject;
import flashbang.core.GameObjectRef;

public class BattleObjectDB extends AppMode
{
    public function BattleObjectDB () {
        _ctx = new BattleCtx();
    }
    
    override public function addObject (obj :GameObject,
        displayParent :DisplayObjectContainer = null,
        displayIdx :int = -1) :GameObjectRef {
        
        Preconditions.checkArgument(obj is BattleObject, "You may only add BattleObjects!");
        
        BattleObject(obj)._ctx = _ctx;
        return super.addObject(obj, displayParent, displayIdx);
    }
    
    protected var _ctx :BattleCtx;
}
}
