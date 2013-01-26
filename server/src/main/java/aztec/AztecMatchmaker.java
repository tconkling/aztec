package aztec;

import aztec.data.AztecBootstrapData;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.threerings.presents.dobj.ObjectDeathListener;
import com.threerings.presents.dobj.ObjectDestroyedEvent;
import com.threerings.presents.dobj.RootDObjectManager;
import com.threerings.presents.server.InvocationManager;
import static aztec.AztecLog.log;

@Singleton
public class AztecMatchmaker {

    public void matchmake(AztecSession session, AztecBootstrapData data) {
        if (_awaitingSecond != null) {
            log.info("Found second!");
            _awaitingSecond.addPlayer(session, data);
            _awaitingSecond.getMatchObject().removeListener(_awaitingDeathListener);
            _awaitingSecond = null;
            return;
        }
        log.info("Starting search for " + session);
        _awaitingSecond = new AztecMatchManager(_invMgr, _rootDObj);
        _awaitingSecond.getMatchObject().addListener(_awaitingDeathListener);
        _awaitingSecond.addPlayer(session, data);
    }

    private final ObjectDeathListener _awaitingDeathListener = new ObjectDeathListener() {
        @Override
        public void objectDestroyed(ObjectDestroyedEvent objectDestroyedEvent) {
            log.info("Match died before finding second");
            _awaitingSecond = null;
        }
    };

    private AztecMatchManager _awaitingSecond;
    @Inject private RootDObjectManager _rootDObj;
    @Inject private InvocationManager _invMgr;
}
