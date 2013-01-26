//
// aztec

package aztec.battle {

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;

import aspire.util.Preconditions;

import flashbang.core.AppMode;
import flashbang.core.GameObject;
import flashbang.core.GameObjectRef;

import aztec.Aztec;
import aztec.battle.controller.BattleBoard;
import aztec.battle.controller.BattleCtx;
import aztec.battle.controller.BattleObject;
import aztec.battle.controller.BattleObjectDB;
import aztec.battle.view.BattleBoardView;
import aztec.net.GameTickMsg;
import aztec.net.LoopbackMessageMgr;
import aztec.net.Message;

public class BattleMode extends AppMode
{
    override protected function setup () :void {
        _ctx = new BattleCtx();
        _ctx.viewObjects = this;
        
        // all the network-synced objects live in here
        _ctx.netObjects = new BattleObjectDB(_ctx);
        _ctx.messages = new LoopbackMessageMgr(Aztec.NETWORK_UPDATE_RATE);
        
        // layers
        _modeSprite.addChild(_ctx.boardLayer);
        _modeSprite.addChild(_ctx.uiLayer);
        
        // board
        var board :BattleBoard = new BattleBoard();
        _ctx.netObjects.addObject(board);
    }
    
    override protected function beginUpdate (dt :Number) :void {
        super.beginUpdate(dt);
        
        // update the network
        while (_ctx.messages.hasTick) {
            var tick :GameTickMsg = _ctx.messages.getNextTick();
            for each (var msg :Message in tick.messages) {
                handleMessage(msg);
            }
            _ctx.netObjects.update(Aztec.NETWORK_UPDATE_RATE);
        }
        
        _ctx.board.view.depthSort();
    }
    
    protected function handleMessage (msg :Message) :void {
        // TODO
    }
    
    override public function addObject (obj :GameObject,
        displayParent :DisplayObjectContainer = null,
        displayIdx :int = -1) :GameObjectRef {
        
        Preconditions.checkArgument(!(obj is BattleObject),
            "BattleObjects must be added to the BattleObjectDB");
        return super.addObject(obj, displayParent, displayIdx);
    }
    
    protected var _ctx :BattleCtx;
}
}
