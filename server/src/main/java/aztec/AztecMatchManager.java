package aztec;

import aztec.data.AztecBootstrapData;
import aztec.data.AztecMessage;
import aztec.data.MatchMarshaller;
import aztec.data.MatchObject;
import aztec.server.MatchProvider;
import com.google.common.collect.Lists;
import com.google.inject.Inject;
import com.samskivert.util.Interval;
import com.threerings.presents.data.ClientObject;
import com.threerings.presents.dobj.RootDObjectManager;
import com.threerings.presents.server.InvocationManager;
import static aztec.AztecLog.log;

import java.util.List;

public class AztecMatchManager implements MatchProvider, AztecSession.SessionEndListener {
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

    public void addPlayer(AztecSession session, AztecBootstrapData data) {
        _sessions.add(session);
        if (_sessions.size() == 1) {
            log.info("Set player 1");
            _mobj.setPlayer1(session.getAuthName());
        } else {
            log.info("Set player 2");
            _mobj.setPlayer2(session.getAuthName());
            _messageSender.schedule(MESSAGE_RATE, true);
        }
        data.matchOid = _mobj.getOid();
        session.addSessionEndListener(this);
    }

    @Override
    public void sessionEnded(AztecSession session) {
        log.info("Session ended");
        for (AztecSession listenedSession : _sessions) {
            listenedSession.removeSessionEndListener(this);
        }
        _messageSender.cancel();
        _mobj.destroy();
    }

    @Override
    public void sendMessage(ClientObject caller, AztecMessage message) {
        log.debug("Received", "msg", message);
        _queuedMessages.add(message);
    }

    private final List<AztecMessage> _queuedMessages = Lists.newArrayList();

    private final MatchObject _mobj = new MatchObject();
    private final List<AztecSession> _sessions = Lists.newArrayList();
    private final Interval _messageSender;
}
