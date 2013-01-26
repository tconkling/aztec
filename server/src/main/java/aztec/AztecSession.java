
package aztec;

import aztec.data.AztecBootstrapData;
import com.threerings.presents.dobj.RootDObjectManager;
import com.google.inject.Inject;
import com.threerings.presents.net.BootstrapData;
import com.threerings.presents.server.InvocationManager;
import com.threerings.presents.server.PresentsSession;

public class AztecSession extends PresentsSession {
    @Override public BootstrapData createBootstrapData () {
        return new AztecBootstrapData();
    }

    @Override public void populateBootstrapData (BootstrapData data) {
        super.populateBootstrapData(data);

        AztecMatchManager matchManager = new AztecMatchManager(_invMgr, _rootDObj);
        ((AztecBootstrapData)data).matchOid = matchManager.getMatchOid();
    }

    @Inject private RootDObjectManager _rootDObj;
    @Inject private InvocationManager _invMgr;

}
