//
// aztec

package aztec.client {

import com.threerings.presents.client.InvocationService;

/**
 * An ActionScript version of the Java MatchmakerService interface.
 */
public interface MatchmakerService extends InvocationService
{
    // from Java interface MatchmakerService
    function findMatch () :void;
}
}
