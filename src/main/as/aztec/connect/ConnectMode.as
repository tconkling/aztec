package aztec.connect {
import aztec.battle.BattleMode;
import aztec.data.MatchObject;
import aztec.data.MoveMessage;
import aztec.net.AztecClient;

import com.threerings.io.TypedArray;

import flashbang.core.AppMode;
import flashbang.core.Flashbang;
import flashbang.core.FlashbangApp;

public class ConnectMode extends AppMode
{
    override protected function setup () :void {
        _client = new AztecClient();
        _client.onMatchObject.add(function (matchObj: MatchObject) :void {
            matchObj.messagesChanged.add(function (newMessages: TypedArray, oldMessages: TypedArray) :void {
                trace("Got " + newMessages);
            });
            matchObj.marshaller.sendMessage(new MoveMessage());
            trace("Switching to battle mode!");
            Flashbang.app.defaultViewport.changeMode(new BattleMode());
        });
        _client.logon();
    }

    protected var _client :AztecClient;
}
}
