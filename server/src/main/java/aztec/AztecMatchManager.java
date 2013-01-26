package aztec;

import aztec.data.AztecMessage;
import aztec.data.MatchMarshaller;
import aztec.data.MatchObject;
import aztec.server.MatchProvider;
import com.google.common.collect.Lists;
import com.google.inject.Inject;
import com.threerings.presents.data.ClientObject;
import com.threerings.presents.dobj.RootDObjectManager;
import com.threerings.presents.server.InvocationManager;

import java.util.List;

public class AztecMatchManager implements MatchProvider {
    public static long MESSAGE_RATE = 1000/10; // 10 messages/sec
    @Inject
    AztecMatchManager(InvocationManager invMgr, RootDObjectManager domgr) {
        _mobj.marshaller = invMgr.registerProvider(this, MatchMarshaller.class);
        domgr.registerObject(_mobj);
        domgr.newInterval(new Runnable() {
            @Override
            public void run() {
                if (!_queuedMessages.isEmpty()) {
                    System.out.println("Sending " + _queuedMessages);
                    _mobj.setMessages(_queuedMessages.toArray(new AztecMessage[_queuedMessages.size()]));
                    _queuedMessages.clear();
                }
            }
        }).schedule(MESSAGE_RATE, true);
    }

    public int getMatchOid() {
        return _mobj.getOid();
    }

    @Override
    public void sendMessage(ClientObject caller, AztecMessage message) {
        System.out.println("Got " + message);
        _queuedMessages.add(message);
    }

    private final List<AztecMessage> _queuedMessages = Lists.newArrayList();

    private final MatchObject _mobj = new MatchObject();
}
