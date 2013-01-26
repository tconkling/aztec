//
// aztec

package aztec.battle {

import aspire.util.Randoms;

import flashbang.core.GameObject;

public class LocalObject extends GameObject
    implements AutoCtx
{
    public function setCtx (ctx :BattleCtx) :void {
        _ctx = ctx;
    }
    
    protected function rands () :Randoms {
        return _ctx.randomsFor(this);
    }
    
    protected var _ctx :BattleCtx
}
}
