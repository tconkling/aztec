//
// SPACK
package aztec.data;

import javax.annotation.Generated;

import aztec.client.MatchService;

import com.threerings.presents.data.ClientObject;
import com.threerings.presents.data.InvocationMarshaller;

/**
 * Provides the implementation of the {@link MatchService} interface
 * that marshalls the arguments and delivers the request to the provider
 * on the server. Also provides an implementation of the response listener
 * interfaces that marshall the response arguments and deliver them back
 * to the requesting client.
 */
@Generated(value={"com.threerings.presents.tools.GenServiceTask"},
           comments="Derived from MatchService.java.")
public class MatchMarshaller extends InvocationMarshaller<ClientObject>
    implements MatchService
{
    /** The method id used to dispatch {@link #sendMessage} requests. */
    public static final int SEND_MESSAGE = 1;

    // from interface MatchService
    public void sendMessage (AztecMessage arg1)
    {
        sendRequest(SEND_MESSAGE, new Object[] {
            arg1
        });
    }
}
