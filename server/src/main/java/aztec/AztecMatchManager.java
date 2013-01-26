package aztec;

import aztec.data.AztecMessage;
import aztec.data.MatchMarshaller;
import aztec.data.MatchObject;
import aztec.server.MatchProvider;
import com.google.inject.Inject;
import com.threerings.presents.data.ClientObject;
import com.threerings.presents.dobj.RootDObjectManager;
import com.threerings.presents.server.InvocationManager;

public class AztecMatchManager implements MatchProvider {
    @Inject
    AztecMatchManager(InvocationManager invMgr, RootDObjectManager domgr) {
        _mobj.marshaller = invMgr.registerProvider(this, MatchMarshaller.class);
        domgr.registerObject(_mobj);
    }

    public int getMatchOid() {
        return _mobj.getOid();
    }

    private final MatchObject _mobj = new MatchObject();

    @Override
    public void sendMessage(ClientObject caller, AztecMessage message) {
        System.out.println("Got " + message);
    }
}
