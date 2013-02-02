
package aztec;

import com.threerings.presents.server.PresentsSession;

public class AztecSession extends PresentsSession {
    @Override
    protected void sessionConnectionClosed ()
    {
        super.sessionConnectionClosed();
        // Since there's no place state in aztec, we don't keep disconnected sessions
        endSession();
    }
}
