//
// aztec

package aztec.battle.ctx {

import flashbang.objects.SpriteObject;

public class BattleSpriteObject extends SpriteObject
    implements AutoCtx
{
    public function setCtx (ctx :BattleCtx) :void {
        _ctx = ctx;
    }
    
    protected var _ctx :BattleCtx;
}
}

