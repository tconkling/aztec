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
import java.util.Random;

public class AztecMatchManager implements MatchProvider {
    public static long MESSAGE_RATE = 1000/10; // 10 messages/sec
    @Inject
    AztecMatchManager(InvocationManager invMgr, RootDObjectManager domgr) {
        _mobj.marshaller = invMgr.registerProvider(this, MatchMarshaller.class);
        _mobj.seed = new Random().nextInt();
        domgr.registerObject(_mobj);
        _messageSender = domgr.newInterval(new Runnable() {
            @Override
            public void run() {
                _mobj.setMessages(_queuedMessages.toArray(new AztecMessage[_queuedMessages.size()]));
                _queuedMessages.clear();
                if (_gotWinMessage || _playerDisconnected) {
                    shutdown();
                }
            }
        });
    }

    public MatchObject getMatchObject() {
        return _mobj;
    }

    public void addPlayer(AztecClientObject client) {
        client.addListener(_clientDeathListener, true);
        _clients.add(client);
        if (_clients.size() == 1) {
            _mobj.setPlayer1(client.username);
        } else {
            _mobj.setPlayer2(client.username);
            _messageSender.schedule(MESSAGE_RATE, true);
            for (AztecClientObject toSub : _clients) {
                toSub.setMatchOid(_mobj.getOid());
            }
            _matchStarted = true;
        }
    }

    @Override
    public void sendMessage(ClientObject caller, AztecMessage message) {
        if (message instanceof IWonMessage) {
            _gotWinMessage = true;
        }
        _queuedMessages.add(message);
    }

    private void shutdown() {
        log.info("Shutting down match", "oid", _mobj.getOid(), "matchStarted", _matchStarted, "hadWinner", _gotWinMessage, "playerDisconnected", _playerDisconnected);
        for (AztecClientObject client : _clients) {
            if (client.isActive()) client.setMatchOid(-1);
        }
        _messageSender.cancel();
        _mobj.destroy();
    }

    private final ObjectDeathListener _clientDeathListener = new ObjectDeathListener() {
        @Override
        public void objectDestroyed(ObjectDestroyedEvent objectDestroyedEvent) {
            if (!_matchStarted) {
                shutdown();
            } else {
                _playerDisconnected = true;
                PlayerDisconnectedMessage msg = new PlayerDisconnectedMessage();
                msg.senderId = 1;// The id is either 1 or 2, and it doesn't matter which we choose
                sendMessage(null, msg);
            }
        }
    };

    private boolean _matchStarted;
    private boolean _gotWinMessage;
    private boolean _playerDisconnected;

    private final List<AztecMessage> _queuedMessages = Lists.newArrayList();

    private final MatchObject _mobj = new MatchObject();
    private final List<AztecClientObject> _clients = Lists.newArrayList();
    private final Interval _messageSender;
}
