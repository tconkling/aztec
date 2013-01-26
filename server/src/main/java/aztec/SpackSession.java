
package aztec;

import aztec.data.SpackBootstrapData;
import com.threerings.presents.dobj.RootDObjectManager;
import com.google.inject.Inject;
import com.threerings.presents.net.BootstrapData;
import com.threerings.presents.server.PresentsSession;

public class SpackSession extends PresentsSession {
    @Override public BootstrapData createBootstrapData () {
        return new SpackBootstrapData();
    }

    @Override public void populateBootstrapData (BootstrapData data) {
        super.populateBootstrapData(data);


        ((SpackBootstrapData)data).boardOid = 7;
    }

    @Inject private RootDObjectManager _rootDObj;

}
