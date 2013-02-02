
package aztec;

import com.google.common.collect.Lists;
import com.google.inject.Inject;
import com.threerings.presents.server.PresentsSession;

import java.util.Collections;
import java.util.List;

public class AztecSession extends PresentsSession {

    @Override
    protected void sessionConnectionClosed ()
    {
        super.sessionConnectionClosed();
        // Since there's no place state in aztec, we don't keep disconnected sessions
        endSession();
    }
}
