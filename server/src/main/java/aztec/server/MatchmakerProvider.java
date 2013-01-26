//
// SPACK
package aztec.server;

import javax.annotation.Generated;

import aztec.client.MatchmakerService;
import aztec.data.AztecClientObject;

import com.threerings.presents.server.InvocationProvider;

/**
 * Defines the server-side of the {@link MatchmakerService}.
 */
@Generated(value={"com.threerings.presents.tools.GenServiceTask"},
           comments="Derived from MatchmakerService.java.")
public interface MatchmakerProvider extends InvocationProvider
{
    /**
     * Handles a {@link MatchmakerService#findMatch} request.
     */
    void findMatch (AztecClientObject caller);
}
