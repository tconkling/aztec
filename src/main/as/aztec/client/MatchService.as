//
// SPACK
package aztec.client {

import aztec.data.AztecMessage;

import com.threerings.presents.client.InvocationService;

/**
 * An ActionScript version of the Java MatchService interface.
 */
public interface MatchService extends InvocationService
{
    // from Java interface MatchService
    function sendMessage (arg1 :AztecMessage) :void;
}
}
