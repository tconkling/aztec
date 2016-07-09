//
// SPACK
package aztec.data {

import aztec.client.MatchmakerService;

import com.threerings.presents.data.InvocationMarshaller;

/**
 * Provides the implementation of the <code>MatchmakerService</code> interface
 * that marshalls the arguments and delivers the request to the provider
 * on the server. Also provides an implementation of the response listener
 * interfaces that marshall the response arguments and deliver them back
 * to the requesting client.
 */
public class MatchmakerMarshaller extends InvocationMarshaller
    implements MatchmakerService
{
    /** The method id used to dispatch <code>findMatch</code> requests. */
    public static const FIND_MATCH :int = 1;

    // from interface MatchmakerService
    public function findMatch () :void
    {
        sendRequest(FIND_MATCH, [
        ]);
    }
}
}
