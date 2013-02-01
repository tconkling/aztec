//
// aztec

package aztec.battle.controller {

import starling.display.DisplayObjectContainer;

import aspire.util.Preconditions;

import flashbang.core.AppMode;
import flashbang.core.GameObject;
import flashbang.core.GameObjectRef;
import aztec.battle.BattleCtx;

public class NetObjectDB extends AppMode
{
    public function NetObjectDB (ctx :BattleCtx) {
        _ctx = ctx;
    }

    override public function addObject (obj :GameObject,
        displayParent :DisplayObjectContainer = null,
        displayIdx :int = -1) :GameObjectRef {

        Preconditions.checkArgument(obj is NetObject, "You may only add NetObjects");

        NetObject(obj).setCtx(_ctx);
        return super.addObject(obj, displayParent, displayIdx);
    }

    protected var _ctx :BattleCtx;
}
}
