
package aztec.net {

import aspire.util.Log;

import aztec.Aztec;
import aztec.data.AztecBootstrapData;
import aztec.data.MatchObject;

import com.threerings.presents.client.Client;
import com.threerings.presents.data.ClientObject;
import com.threerings.presents.dobj.DObject;
import com.threerings.presents.dobj.ObjectAccessError;
import com.threerings.presents.dobj.SubscriberAdapter;
import com.threerings.presents.net.UsernamePasswordCreds;
import com.threerings.util.Name;

import org.osflash.signals.Signal;

public class AztecClient extends Client {
    public const onMatchObject :Signal = new Signal(MatchObject);

    public function AztecClient() {
        super(new UsernamePasswordCreds(new Name("test" + Aztec.rands.getInt(100000)), "test"));
        setServer(Aztec.SERVER, [47624]);
    }

    override public function gotClientObject (clobj :ClientObject) :void {
        super.gotClientObject(clobj);

        const matchOid :int = AztecBootstrapData(_bstrap).matchOid;
        log.warning("Clobj", "client", clobj, "matchOid", matchOid);
        _omgr.subscribeToObject(matchOid, new SubscriberAdapter(onBoardSubscribe, onBoardSubscribeFail));
    }

    private function onBoardSubscribe (dobj :DObject) :void {
        log.info("Subscribed", "boardObj", MatchObject(dobj));
        onMatchObject.dispatch(dobj);
    }

    private function onBoardSubscribeFail (oid :int, cause :ObjectAccessError) :void {
        log.warning("Failed to subscribe", "oid", oid, "cause", cause);
    }

    private static const log :Log = Log.getLog(AztecClient);
}
}
