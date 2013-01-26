package aztec;

import aztec.data.AztecClientObject;
import aztec.data.MatchmakerMarshaller;
import aztec.server.MatchmakerProvider;
import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.threerings.presents.dobj.ObjectDeathListener;
import com.threerings.presents.dobj.ObjectDestroyedEvent;
import com.threerings.presents.dobj.RootDObjectManager;
import com.threerings.presents.server.InvocationManager;
import static aztec.AztecLog.log;

@Singleton
public class AztecMatchmaker implements MatchmakerProvider {

    @Inject AztecMatchmaker(InvocationManager man) {
        man.registerProvider(this, MatchmakerMarshaller.class, "aztec");
    }

    @Override
    public void findMatch(AztecClientObject caller) {
        if (_awaitingSecond != null) {
            log.info("Found second!", "name", caller.username);
            _awaitingSecond.addPlayer(caller);
            _awaitingSecond.getMatchObject().removeListener(_awaitingDeathListener);
            _awaitingSecond = null;
            return;
        }
        log.info("Starting search", "name", caller.username);
        _awaitingSecond = new AztecMatchManager(_invMgr, _rootDObj);
        _awaitingSecond.getMatchObject().addListener(_awaitingDeathListener);
        _awaitingSecond.addPlayer(caller);
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
