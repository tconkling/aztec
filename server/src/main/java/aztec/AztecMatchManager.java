package aztec;

import aztec.data.*;
import aztec.server.MatchProvider;
import com.google.common.collect.Lists;
import com.google.inject.Inject;
import com.samskivert.util.Interval;
import com.threerings.presents.data.ClientObject;
import com.threerings.presents.dobj.ObjectDeathListener;
import com.threerings.presents.dobj.ObjectDestroyedEvent;
import com.threerings.presents.dobj.RootDObjectManager;
import com.threerings.presents.server.InvocationManager;
import static aztec.AztecLog.log;

import java.util.List;

public class AztecMatchManager implements MatchProvider {
    public static long MESSAGE_RATE = 1000/10; // 10 messages/sec
    @Inject
    AztecMatchManager(InvocationManager invMgr, RootDObjectManager domgr) {
        _mobj.marshaller = invMgr.registerProvider(this, MatchMarshaller.class);
        domgr.registerObject(_mobj);
        _messageSender = domgr.newInterval(new Runnable() {
            @Override
            public void run() {
                _mobj.setMessages(_queuedMessages.toArray(new AztecMessage[_queuedMessages.size()]));
                _queuedMessages.clear();
            }
        });
    }

    public MatchObject getMatchObject() {
        return _mobj;
    }

    public void addPlayer(AztecClientObject client) {
        _clients.add(client);
        if (_clients.size() == 1) {
            _mobj.setPlayer1(client.username);
        } else {
            _mobj.setPlayer2(client.username);
            _messageSender.schedule(MESSAGE_RATE, true);
        }
        client.setMatchOid(_mobj.getOid());
        client.addListener(_clientDeathListener, true);
    }

    @Override
    public void sendMessage(ClientObject caller, AztecMessage message) {
        log.debug("Received", "msg", message);
        _queuedMessages.add(message);
    }

    private final ObjectDeathListener _clientDeathListener = new ObjectDeathListener() {
        @Override
        public void objectDestroyed(ObjectDestroyedEvent objectDestroyedEvent) {
            for (AztecClientObject client : _clients) {
                if (client.getOid() != objectDestroyedEvent.getTargetOid()) {
                    // If the client is still connected, tell it it needs to find a new match id
                    client.setMatchOid(-1);
                }
            }
            _messageSender.cancel();
            _mobj.destroy();
        }
    };

    private final List<AztecMessage> _queuedMessages = Lists.newArrayList();

    private final MatchObject _mobj = new MatchObject();
    private final List<AztecClientObject> _clients = Lists.newArrayList();
    private final Interval _messageSender;
}
