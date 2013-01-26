package aztec.client;

import aztec.data.AztecClientObject;
import com.threerings.presents.client.InvocationService;

public interface MatchmakerService extends InvocationService<AztecClientObject> {
    void findMatch();
}
