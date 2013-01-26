package aztec;

import aztec.data.MatchObject;
import com.google.inject.Inject;
import com.threerings.presents.dobj.RootDObjectManager;

public class AztecMatchManager {
    @Inject
    AztecMatchManager(RootDObjectManager domgr) {
        domgr.registerObject(_mobj);
    }

    public int getMatchOid() {
        return _mobj.getOid();
    }

    private final MatchObject _mobj = new MatchObject();
}
