
package aztec.net {

import aspire.util.Log;

import aztec.Aztec;
import aztec.client.MatchmakerService;
import aztec.data.AztecClientObject;
import aztec.data.MatchObject;
import aztec.data.MatchmakerMarshaller;

import com.threerings.presents.client.Client;
import com.threerings.presents.data.ClientObject;
import com.threerings.presents.dobj.DObject;
import com.threerings.presents.dobj.ObjectAccessError;
import com.threerings.presents.dobj.SubscriberAdapter;
import com.threerings.presents.net.UsernamePasswordCreds;
import com.threerings.util.Name;

import org.osflash.signals.Signal;

public class AztecClient extends Client {
    MatchmakerMarshaller;

    public const onMatchObject :Signal = new Signal(MatchObject);

    public function AztecClient(name :String) {
        super(new UsernamePasswordCreds(new Name(name), "test"));
        addServiceGroup("aztec");
        setServer(Aztec.SERVER, [47624]);
    }
    public function findMatch() :void {
        log.info("Looking for match");
        requireService(MatchmakerService).findMatch();
    }

    override public function gotClientObject (clobj :ClientObject) :void {
        super.gotClientObject(clobj);
        AztecClientObject(clobj).matchOidChanged.add(function (newMatchOid :int, oldMatchOid: int) :void {
            if (newMatchOid == -1) {
                log.info("Left match");
            } else {
                log.info("Got match, subscribing", "matchOid", newMatchOid);
                _omgr.subscribeToObject(newMatchOid, new SubscriberAdapter(onMatchSubscribe, onMatchSubscribeFail));
            }
        });
    }


    private function onMatchSubscribe (dobj :DObject) :void {
        log.info("Subscribed", "MatchObj", MatchObject(dobj));
        onMatchObject.dispatch(dobj);
    }

    private function onMatchSubscribeFail (oid :int, cause :ObjectAccessError) :void {
        log.warning("Failed to subscribe", "oid", oid, "cause", cause);
    }

    private static const log :Log = Log.getLog(AztecClient);
}
}
