package aztec.connect {
import aztec.battle.BattleMode;
import aztec.battle.controller.Player;
import aztec.battle.desc.GameDesc;
import aztec.data.MatchObject;
import aztec.input.KeyboardInput;
import aztec.net.AztecClient;
import aztec.net.NetworkedMessageMgr;

import flashbang.core.AppMode;
import flashbang.core.Flashbang;

import starling.events.KeyboardEvent;

public class ConnectMode extends AppMode
{
    public const keyboardInput :KeyboardInput = new KeyboardInput();

    override protected function setup() :void {
        var nameEntry :NameEntryView = new NameEntryView();
        _regs.addOneShotSignalListener(nameEntry.nameEntered, function (name :String) :void {
            nameEntry.destroySelf();
            connect(name);
        });
        addObject(nameEntry, modeSprite);
    }

    override protected function enter () :void {
        if (_client == null) {
            return;
        }
        var startMatch :StartMatchView = new StartMatchView();
        _regs.addOneShotSignalListener(startMatch.startEntered, function () :void {
            _client.findMatch();
        });
        addObject(startMatch, modeSprite);
    }

    override public function onKeyDown (keyEvent :KeyboardEvent) :void {
        if (!keyboardInput.handleKeyboardEvent(keyEvent)) {
            super.onKeyDown(keyEvent);
        }
    }

    override public function onKeyUp (keyEvent :KeyboardEvent) :void {
        if (!keyboardInput.handleKeyboardEvent(keyEvent)) {
            super.onKeyUp(keyEvent);
        }
    }

    protected function connect (name :String) :void {
        _client = new AztecClient(name);
        _client.onMatchObject.add(function (matchObj: MatchObject) :void {
            trace("Switching to battle mode!");
            var player1Local :Boolean = matchObj.player1.equals(_client.getClientObject().username);
            var player1 :Player = new Player(1, matchObj.player1.toString(), GameDesc.player1, player1Local);
            var player2 :Player = new Player(2, matchObj.player2.toString(), GameDesc.player2, !player1Local);
            Flashbang.app.defaultViewport.pushMode(new BattleMode(player1, player2, matchObj.seed, new NetworkedMessageMgr(matchObj)));
        });
        _client.logon();

    }

    protected var _client :AztecClient;
}
}
