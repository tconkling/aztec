
package aztec;

import com.google.inject.Injector;
import com.threerings.presents.server.ClientResolver;
import com.threerings.util.Name;
import com.threerings.presents.server.PresentsSession;
import com.threerings.presents.net.AuthRequest;
import com.threerings.presents.server.SessionFactory;
import com.threerings.presents.server.PresentsServer;

public class SpackServer extends PresentsServer {
    public static void main (String[] args) {
        runServer(new PresentsModule(), new PresentsServerModule(SpackServer.class));
    }

    @Override public void init (Injector injector) throws Exception {
        super.init(injector);

        _clmgr.setDefaultSessionFactory(new SessionFactory () {
            @Override public Class<? extends PresentsSession> getSessionClass (AuthRequest req) {
                return SpackSession.class;
            }

            @Override public Class<? extends ClientResolver> getClientResolverClass (Name username) {
                return ClientResolver.class;
            }
        });
    }
}
