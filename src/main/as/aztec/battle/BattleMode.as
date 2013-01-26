//
// aztec

package aztec.battle {

import starling.display.DisplayObjectContainer;

import aspire.util.Preconditions;

import flashbang.core.AppMode;
import flashbang.core.GameObject;
import flashbang.core.GameObjectRef;

import aztec.Aztec;
import aztec.battle.controller.Actor;
import aztec.battle.controller.BattleBoard;
import aztec.battle.controller.BattleCtx;
import aztec.battle.controller.BattleObject;
import aztec.battle.controller.BattleObjectDB;
import aztec.battle.controller.Player;
import aztec.battle.desc.GameDesc;
import aztec.data.AztecMessage;
import aztec.data.MoveMessage;
import aztec.net.MessageMgr;

public class BattleMode extends AppMode
{
    public function BattleMode (messageMgr: MessageMgr) {
        _msgMgr = messageMgr;

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
        _ctx.netObjects = new BattleObjectDB(_ctx);
        _ctx.messages = _msgMgr;
        
        // board
        var board :BattleBoard = new BattleBoard();
        _ctx.netObjects.addObject(board);
        
        // players
        var player1 :Player = new Player(1, "Tim", GameDesc.player1);
        var player2 :Player = new Player(2, "Charlie", GameDesc.player2);
        _ctx.netObjects.addObject(player1);
        _ctx.netObjects.addObject(player2);
    }
    
    override protected function beginUpdate (dt :Number) :void {
        super.beginUpdate(dt);

        _ctx.messages.update(dt);
        // update the network
        for each (var ticks :Vector.<AztecMessage> in _ctx.messages.ticks) {
            for each (var msg :AztecMessage in ticks) {
                handleMessage(msg);
            }
            _ctx.netObjects.update(Aztec.NETWORK_UPDATE_RATE);
        }
        
        _ctx.board.view.depthSort();
    }
    
    protected function handleMessage (msg :AztecMessage) :void {
        if (msg is MoveMessage) {
            const move :MoveMessage = MoveMessage(msg);
            _actor.x = move.x;
            _actor.y = move.y;
        } else {
            trace("Unhandled message! " + msg);
        }
    }
    
    override public function addObject (obj :GameObject,
        displayParent :DisplayObjectContainer = null,
        displayIdx :int = -1) :GameObjectRef {
        
        Preconditions.checkArgument(!(obj is BattleObject),
            "BattleObjects must be added to the BattleObjectDB");
        return super.addObject(obj, displayParent, displayIdx);
    }

    protected var _actor :Actor;
    protected var _ctx :BattleCtx;
    protected var _msgMgr: MessageMgr;
}
}
