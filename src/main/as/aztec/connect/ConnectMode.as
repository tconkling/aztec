//
// aztec

package aztec.connect {

import aztec.Aztec;
import aztec.battle.BattleMode;
import aztec.battle.controller.Player;
import aztec.battle.desc.GameDesc;
import aztec.data.MatchObject;
import aztec.net.AztecClient;
import aztec.net.NetworkedMessageMgr;

import com.threerings.presents.client.ClientEvent;

import flashbang.core.AppMode;

public class ConnectMode extends AppMode {
    override protected function setup() :void {
        if (!Aztec.MULTIPLAYER) { return; }
        _nameEntry = new NameEntryView();

        _regs.add(_nameEntry.nameEntered.connect(function (name :String) :void {
            connect(name);
        }).once());

        addObject(_nameEntry, modeSprite);
    }

    override protected function enter () :void {
        if (_client != null || !Aztec.MULTIPLAYER) {
            showStartMatch();
        }
    }

    override protected function exit():void {
        super.exit();
        if (_startMatch != null) {
            _startMatch.destroySelf();
        }
    }

    protected function showStartMatch () :void {
        _startMatch = new StartMatchView(Aztec.newGameCondition);

        _regs.add(_startMatch.startEntered.connect(function () :void {
            _client.findMatch();
        }).once());

        addObject(_startMatch, modeSprite);
    }

    protected function connect (name :String) :void {
        _client = new AztecClient(name);
        _client.onMatchObject.add(function (matchObj: MatchObject) :void {
            trace("Switching to battle mode!");
            var player1Local :Boolean = matchObj.player1.equals(_client.getClientObject().username);
            var player1 :Player = new Player(1, matchObj.player1.toString(), GameDesc.player1, player1Local);
            var player2 :Player = new Player(2, matchObj.player2.toString(), GameDesc.player2, !player1Local);
            _modeStack.pushMode(new BattleMode(player1, player2, matchObj.seed, new NetworkedMessageMgr(matchObj)));
        });
        const logonOverlay :ActivityOverlay = new ActivityOverlay("Connecting");
        _nameEntry.addDependentObject(logonOverlay, _nameEntry.sprite);
        _regs.addEventListener(_client, ClientEvent.CLIENT_DID_LOGON, function (e :ClientEvent) :void {
            _nameEntry.destroySelf();
            showStartMatch();
        });
        _regs.addEventListener(_client, ClientEvent.CLIENT_CONNECTION_FAILED, function (e :ClientEvent) :void {
            viewport.pushMode(new NetworkFailureMode("Connection lost!"));
        });
        _regs.addEventListener(_client, ClientEvent.CLIENT_FAILED_TO_LOGON, function (e :ClientEvent) :void {
            var reason :String = e.getCause().message == "inuse" ? "Username already being used!" : "Unable to connect!";
            viewport.pushMode(new NetworkFailureMode(reason));
        });
        _client.logon();
    }

    protected var _client :AztecClient;

    protected var _nameEntry :NameEntryView;
    protected var _startMatch :StartMatchView;
}
}
