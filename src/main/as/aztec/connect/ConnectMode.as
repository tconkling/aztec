package aztec.connect {
import aztec.battle.BattleMode;
import aztec.battle.controller.Player;
import aztec.battle.desc.GameDesc;
import aztec.data.MatchObject;
import aztec.net.AztecClient;
import aztec.net.NetworkedMessageMgr;

import flashbang.core.AppMode;
import flashbang.core.Flashbang;

public class ConnectMode extends AppMode
{
    override protected function setup () :void {
        trace("Connecting");
        _client = new AztecClient();
        _client.onMatchObject.add(function (matchObj: MatchObject) :void {
            trace("Switching to battle mode!");
            var player1Local :Boolean = matchObj.player1.equals(_client.getClientObject().username);
            var player1 :Player = new Player(1, matchObj.player1.toString(), GameDesc.player1, player1Local);
            var player2 :Player = new Player(2, matchObj.player2.toString(), GameDesc.player2, !player1Local);
            Flashbang.app.defaultViewport.changeMode(new BattleMode(player1, player2, matchObj.seed, new NetworkedMessageMgr(matchObj)));
        });
        _client.logon();
    }

    protected var _client :AztecClient;
}
}
