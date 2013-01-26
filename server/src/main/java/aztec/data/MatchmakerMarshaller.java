//
// SPACK
package aztec.data;

import javax.annotation.Generated;

import aztec.client.MatchmakerService;

import com.threerings.presents.data.InvocationMarshaller;

/**
 * Provides the implementation of the {@link MatchmakerService} interface
 * that marshalls the arguments and delivers the request to the provider
 * on the server. Also provides an implementation of the response listener
 * interfaces that marshall the response arguments and deliver them back
 * to the requesting client.
 */
@Generated(value={"com.threerings.presents.tools.GenServiceTask"},
           comments="Derived from MatchmakerService.java.")
public class MatchmakerMarshaller extends InvocationMarshaller<AztecClientObject>
    implements MatchmakerService
{
    /** The method id used to dispatch {@link #findMatch} requests. */
    public static final int FIND_MATCH = 1;

    // from interface MatchmakerService
    public void findMatch ()
    {
        sendRequest(FIND_MATCH, new Object[] {
        });
    }
}
