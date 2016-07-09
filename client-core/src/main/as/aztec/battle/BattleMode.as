//
// aztec

package aztec.battle {

import aspire.util.Log;
import aspire.util.Preconditions;

import aztec.Aztec;
import aztec.battle.controller.BattleBoard;
import aztec.battle.controller.BattleDebug;
import aztec.battle.controller.NetObject;
import aztec.battle.controller.NetObjectDB;
import aztec.battle.controller.Player;
import aztec.battle.controller.VillagerGenerator;
import aztec.battle.view.AffinityView;
import aztec.net.MessageMgr;

import flashbang.core.AppMode;
import flashbang.core.GameObjectBase;
import flashbang.core.GameObjectRef;

import starling.display.DisplayObjectContainer;

public class BattleMode extends AppMode {
    public function BattleMode (player1: Player, player2: Player, randomSeed :int, messageMgr: MessageMgr) {
        _player1 = player1;
        _player2 = player2;
        _msgMgr = messageMgr;
        _randomSeed = randomSeed;
    }

    override protected function setup () :void {
        log.info("Starting match", "randomSeed", _randomSeed);

        // BattleCtx
        _ctx = new BattleCtx(_randomSeed, this.keyboardInput);
        _ctx.viewObjects = this;
        addObject(_ctx);

        // layers
        _modeSprite.addChild(_ctx.boardLayer);
        _modeSprite.addChild(_ctx.uiLayer);
        _modeSprite.addChild(_ctx.effectLayer);
        _modeSprite.addChild(_ctx.debugLayer);

        // all the network-synced objects live in here
        _ctx.netObjects = new NetObjectDB(_ctx);

        _ctx.messages = new BattleMessages(_ctx, _msgMgr);

        // Text Selection
        _ctx.selector = new TextSelector();
        addObject(_ctx.selector);

        // board
        var board :BattleBoard = new BattleBoard();
        _ctx.netObjects.addObject(board);

        // villagers
        _ctx.viewObjects.addObject(new VillagerCommandGenerator());
        _ctx.netObjects.addObject(new VillagerGenerator());

        // players
        _ctx.netObjects.addObject(_player1);
        _ctx.netObjects.addObject(_player2);
        _ctx.localPlayer = _player1.isLocalPlayer ? _player1 : _player2;
        _ctx.selector.selectionColor = _ctx.localPlayer.desc.darkColor;
        _ctx.players[0] = _player1;
        _ctx.players[1] = _player2;

        addObject(new AffinityView(), _ctx.uiLayer);
        addObject(new VillagerSelectionMgr());

        if (Aztec.DEBUG) {
            addObject(new BattleDebug());
        }
    }

    override protected function dispose () :void {
        _ctx.netObjects.shutdown();
        super.dispose();
    }

    override protected function update (dt :Number) :void {
        super.update(dt);

        // update the network
        _ctx.messages.processTicks(dt);

        _ctx.board.view.depthSort();
    }

    override public function addObject (obj :GameObjectBase, displayParent :DisplayObjectContainer = null, displayIdx :int = -1) :GameObjectRef {
        Preconditions.checkArgument(!(obj is NetObject),
            "NetObjects must be added to the NetObjectDB");

        if (obj is AutoCtx) {
            AutoCtx(obj).setCtx(_ctx);
        }

        return super.addObject(obj, displayParent, displayIdx);
    }

    private var _player1: Player;
    private var _player2: Player;
    private var _randomSeed:int;
    protected var _ctx :BattleCtx;
    protected var _msgMgr: MessageMgr;

    protected static const log :Log = Log.getLog(BattleMode);
}
}
