//
// SPACK
package aztec.server;

import javax.annotation.Generated;

import aztec.client.MatchService;
import aztec.data.AztecMessage;

import com.threerings.presents.data.ClientObject;
import com.threerings.presents.server.InvocationProvider;

/**
 * Defines the server-side of the {@link MatchService}.
 */
@Generated(value={"com.threerings.presents.tools.GenServiceTask"},
           comments="Derived from MatchService.java.")
public interface MatchProvider extends InvocationProvider
{
    /**
     * Handles a {@link MatchService#sendMessage} request.
     */
    void sendMessage (ClientObject caller, AztecMessage arg1);
}
