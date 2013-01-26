//
// aztec

package aztec.battle {

import starling.display.DisplayObjectContainer;

import flashbang.core.AppMode;
import flashbang.core.GameObject;
import flashbang.core.GameObjectRef;

import aztec.battle.controller.BattleBoard;
import aztec.battle.ctx.AutoCtx;
import aztec.battle.ctx.BattleCtx;

public class BattleMode extends AppMode
{
    override protected function setup () :void {
        _ctx = new BattleCtx();
        addObject(_ctx);
        
        // layers
        _modeSprite.addChild(_ctx.boardLayer);
        _modeSprite.addChild(_ctx.uiLayer);
        
        // controllers
        var board :BattleBoard = new BattleBoard();
        addObject(board);
    }
    
    override protected function beginUpdate (dt :Number) :void {
        super.beginUpdate(dt);
        _ctx.board.view.depthSort();
    }
    
    override public function addObject (obj :GameObject,
        displayParent :DisplayObjectContainer = null,
        displayIdx :int = -1) :GameObjectRef {
        
        if (obj is AutoCtx) {
            AutoCtx(obj).setCtx(_ctx);
        }
        return super.addObject(obj, displayParent, displayIdx);
    }
    
    protected var _ctx :BattleCtx;
}
}
