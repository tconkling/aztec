package aztec.connect {
import aztec.battle.BattleMode;
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
            Flashbang.app.defaultViewport.changeMode(new BattleMode(matchObj.seed, new NetworkedMessageMgr(matchObj)));
        });
        _client.logon();
    }

    protected var _client :AztecClient;
}
}
