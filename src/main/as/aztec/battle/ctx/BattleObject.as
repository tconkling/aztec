//
// aztec

package aztec.battle.ctx {

import flashbang.core.GameObject;

public class BattleObject extends GameObject
    implements AutoCtx
{
    public function setCtx (ctx :BattleCtx) :void {
        _ctx = ctx;
    }
    
    protected var _ctx :BattleCtx;
}
}
