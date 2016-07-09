//
// aztec

package aztec.battle.controller {

import aspire.util.Randoms;

import flashbang.core.GameObject;

import aztec.battle.AutoCtx;
import aztec.battle.BattleCtx;

public class NetObject extends GameObject
    implements AutoCtx
{
    public function setCtx (ctx :BattleCtx) :void {
        _ctx = ctx;
    }

    protected function rands () :Randoms {
        return _ctx.randomsFor(this);
    }

    protected var _ctx :BattleCtx;
}
}
