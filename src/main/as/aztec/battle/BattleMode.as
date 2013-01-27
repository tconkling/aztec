//
// aztec

package aztec.battle {

import aspire.util.Preconditions;

import aztec.battle.controller.Affinity;

import aztec.battle.controller.BattleBoard;
import aztec.battle.controller.BattleDebug;
import aztec.battle.controller.NetObject;
import aztec.battle.controller.NetObjectDB;
import aztec.battle.controller.Player;
import aztec.battle.controller.VillagerGenerator;
import aztec.battle.desc.GameDesc;
import aztec.net.MessageMgr;

import flashbang.core.AppMode;
import flashbang.core.GameObject;
import flashbang.core.GameObjectRef;

import starling.display.DisplayObjectContainer;
import starling.events.KeyboardEvent;

public class BattleMode extends AppMode
{
    public function BattleMode (messageMgr: MessageMgr) {
        _msgMgr = messageMgr;
    }
    
    override public function onKeyDown (keyEvent :KeyboardEvent) :void {
        if (!_ctx.keyboardInput.handleKeyboardEvent(keyEvent)) {
            super.onKeyDown(keyEvent);
        }
    }
    
    override public function onKeyUp (keyEvent :KeyboardEvent) :void {
        if (!_ctx.keyboardInput.handleKeyboardEvent(keyEvent)) {
            super.onKeyUp(keyEvent);
        }
    }
    
    override protected function setup () :void {
        // BattleCtx
        _ctx = new BattleCtx();
        _ctx.viewObjects = this;
        addObject(_ctx);
        
        // layers
        _modeSprite.addChild(_ctx.boardLayer);
        _modeSprite.addChild(_ctx.uiLayer);
        
        // all the network-synced objects live in here
        _ctx.netObjects = new NetObjectDB(_ctx);
        
        _ctx.messages = new BattleMessages(_ctx, _msgMgr);
        
        // board
        var board :BattleBoard = new BattleBoard();
        _ctx.netObjects.addObject(board);
        
        // villagers
        _ctx.netObjects.addObject(new VillagerGenerator());
        
        // players
        var player1 :Player = new Player(1, "Tim", GameDesc.player1);
        var player2 :Player = new Player(2, "Charlie", GameDesc.player2);
        _ctx.netObjects.addObject(player1);
        _ctx.netObjects.addObject(player2);
        _ctx.localPlayer = player1;
        _ctx.players[0] = player1;
        _ctx.players[1] = player2;

        // ActorSelector
        addObject(new ActorSelector());

        // Affinity
        _ctx.netObjects.addObject(new Affinity());

        // debug
        addObject(new BattleDebug());
    }
    
    override protected function beginUpdate (dt :Number) :void {
        super.beginUpdate(dt);
        
        // update the network
        _ctx.messages.processTicks(dt);
        
        _ctx.board.view.depthSort();
    }
    
    override public function addObject (obj :GameObject,
        displayParent :DisplayObjectContainer = null,
        displayIdx :int = -1) :GameObjectRef {
        
        Preconditions.checkArgument(!(obj is NetObject),
            "NetObjects must be added to the NetObjectDB");
        
        if (obj is AutoCtx) {
            AutoCtx(obj).setCtx(_ctx);
        }
        
        return super.addObject(obj, displayParent, displayIdx);
    }

    protected var _ctx :BattleCtx;
    protected var _msgMgr: MessageMgr;
}
}
