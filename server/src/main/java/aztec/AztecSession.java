
package aztec;

import com.google.common.collect.Lists;
import com.google.inject.Inject;
import com.threerings.presents.server.PresentsSession;

import java.util.Collections;
import java.util.List;

public class AztecSession extends PresentsSession {
    public interface SessionEndListener
    {
        void sessionEnded(AztecSession session);
    }

    @Override
    protected void sessionConnectionClosed ()
    {
        super.sessionConnectionClosed();
        // Since there's no place state in aztec, we don't keep disconnected sessions
        endSession();
    }

    @Override
    protected void sessionDidEnd ()
    {
        super.sessionDidEnd();
        for (SessionEndListener listener : _endListeners.toArray(new SessionEndListener[0])) {
            listener.sessionEnded(this);
        }
    }

    public void addSessionEndListener (SessionEndListener listener)
    {
        _endListeners.add(listener);
    }

    public void removeSessionEndListener (SessionEndListener sessionEndListener)
    {
        _endListeners.remove(sessionEndListener);
    }

    @Inject AztecMatchmaker _matchmaker;

    protected final List<SessionEndListener> _endListeners = Collections.<SessionEndListener>synchronizedList(Lists.<SessionEndListener>newArrayList());
}
