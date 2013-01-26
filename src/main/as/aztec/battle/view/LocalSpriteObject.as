//
// aztec

package aztec.battle.view {

import aspire.geom.Vector2;
import aspire.util.Randoms;

import flashbang.objects.SpriteObject;

import aztec.battle.AutoCtx;
import aztec.battle.BattleCtx;

public class LocalSpriteObject extends SpriteObject
    implements AutoCtx
{
    public function setCtx (ctx :BattleCtx) :void {
        _ctx = ctx;
    }
    
    protected function rands () :Randoms {
        return _ctx.randomsFor(this);
    }
    
    protected function getViewLoc (loc :Vector2, out :Vector2 = null) :Vector2 {
        return _ctx.board.view.boardToLocal(loc, out);
    }
    
    protected var _ctx :BattleCtx
}
}
