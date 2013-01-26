
package aztec;

import aztec.data.AztecBootstrapData;
import com.threerings.presents.dobj.RootDObjectManager;
import com.google.inject.Inject;
import com.threerings.presents.net.BootstrapData;
import com.threerings.presents.server.PresentsSession;

public class AztecSession extends PresentsSession {
    @Override public BootstrapData createBootstrapData () {
        return new AztecBootstrapData();
    }

    @Override public void populateBootstrapData (BootstrapData data) {
        super.populateBootstrapData(data);


        ((AztecBootstrapData)data).boardOid = 7;
    }

    @Inject private RootDObjectManager _rootDObj;

}
