//
// aztec

package aztec.battle.controller {

import aspire.util.Preconditions;

import aztec.battle.BattleCtx;

import flashbang.core.GameObjectBase;
import flashbang.core.GameObjectRef;
import flashbang.core.ObjectDB;

import starling.display.DisplayObjectContainer;

public class NetObjectDB extends ObjectDB {
    public function NetObjectDB (ctx :BattleCtx) {
        _ctx = ctx;
    }

    override public function addObject (obj :GameObjectBase, displayParent :DisplayObjectContainer = null, displayIdx :int = -1) :GameObjectRef {
        Preconditions.checkArgument(obj is NetObject, "You may only add NetObjects");

        NetObject(obj).setCtx(_ctx);
        return super.addObject(obj, displayParent, displayIdx);
    }

    protected var _ctx :BattleCtx;
}
}
