
package aztec;

import com.google.inject.Binder;
import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Module;
import com.threerings.presents.server.*;
import com.threerings.util.Name;
import com.threerings.presents.net.AuthRequest;

public class AztecServer extends PresentsServer {
    public static void main (String[] args) {
        runServer(new PresentsModule(), new PresentsServerModule(AztecServer.class), new Module() {
            @Override
            public void configure(Binder binder) {
                binder.bind(Authenticator.class).to(AztecAuthenticator.class);
            }
        });
    }

    @Override public void init (Injector injector) throws Exception {
        super.init(injector);

        _clmgr.setDefaultSessionFactory(new SessionFactory () {
            @Override public Class<? extends PresentsSession> getSessionClass (AuthRequest req) {
                return AztecSession.class;
            }

            @Override public Class<? extends ClientResolver> getClientResolverClass (Name username) {
                return AztecClientResolver.class;
            }
        });
    }

    @Inject AztecMatchmaker _matchmaker;
}
