//
// aztec

package aztec.battle {

import aspire.util.Randoms;

import aztec.data.AztecMessage;
import aztec.data.MoveMessage;
import aztec.net.MessageMgr;

import com.threerings.util.MessageManager;

import flashbang.tasks.FunctionTask;

import flashbang.tasks.RepeatingTask;

import flashbang.tasks.TimedTask;

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

public class BattleMode extends AppMode
{
    public function BattleMode (messageMgr: MessageMgr) {
        _msgMgr = messageMgr;

    }
    override protected function setup () :void {
        _ctx = new BattleCtx();
        _ctx.viewObjects = this;
        
        // all the network-synced objects live in here
        _ctx.netObjects = new BattleObjectDB(_ctx);
        _ctx.messages = _msgMgr;
        
        // layers
        _modeSprite.addChild(_ctx.boardLayer);
        _modeSprite.addChild(_ctx.uiLayer);
        
        // board
        var board :BattleBoard = new BattleBoard();
        _ctx.netObjects.addObject(board);
        
        _actor = new Actor();
        _actor.x = 3;
        _actor.y = 4;
        _ctx.netObjects.addObject(_actor);

        const timerHolder :GameObject = new GameObject();
        timerHolder.addTask(new RepeatingTask(
                new FunctionTask(function () :void {
                    _msgMgr.sendMessage(new MoveMessage(Randoms.RAND.getInt(Aztec.BOARD_SIZE.x), Randoms.RAND.getInt(Aztec.BOARD_SIZE.y)));
                }),
                new TimedTask(10))
        );
        addObject(timerHolder);

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
