//
// aztec

package aztec.battle.view {

import aspire.util.Randoms;

import aztec.battle.AutoCtx;
import aztec.battle.BattleCtx;

import flashbang.objects.SpriteObject;

public class LocalSpriteObject extends SpriteObject
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
