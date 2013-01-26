//
// SPACK
package aztec.data {

import aztec.client.MatchService;

import com.threerings.presents.data.InvocationMarshaller;

/**
 * Provides the implementation of the <code>MatchService</code> interface
 * that marshalls the arguments and delivers the request to the provider
 * on the server. Also provides an implementation of the response listener
 * interfaces that marshall the response arguments and deliver them back
 * to the requesting client.
 */
public class MatchMarshaller extends InvocationMarshaller
    implements MatchService
{
    /** The method id used to dispatch <code>sendMessage</code> requests. */
    public static const SEND_MESSAGE :int = 1;

    // from interface MatchService
    public function sendMessage (arg1 :AztecMessage) :void
    {
        sendRequest(SEND_MESSAGE, [
            arg1
        ]);
    }
}
}
