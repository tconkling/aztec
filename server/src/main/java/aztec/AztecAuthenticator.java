package aztec;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.threerings.presents.net.AuthResponse;
import com.threerings.presents.net.AuthResponseData;
import com.threerings.presents.net.UsernamePasswordCreds;
import com.threerings.presents.server.Authenticator;
import com.threerings.presents.server.ClientManager;
import com.threerings.presents.server.net.AuthingConnection;
import com.threerings.util.Name;

@Singleton
public class AztecAuthenticator extends Authenticator {
    @Override
    protected void processAuthentication(AuthingConnection conn, AuthResponse rsp) throws Exception {
        Name username = ((UsernamePasswordCreds)conn.getAuthRequest().getCredentials()).getUsername();
        if (_clmgr.getClient(username) != null) {
            AztecLog.log.info("Failing auth for username in use", "username", username);
            rsp.getData().code = "inuse";
        } else {
            conn.setAuthName(username);
            rsp.getData().code = AuthResponseData.SUCCESS;
        }
    }

    @Inject private ClientManager _clmgr;
}
