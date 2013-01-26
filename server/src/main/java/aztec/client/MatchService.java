package aztec.client;

import aztec.data.AztecMessage;
import com.threerings.presents.client.InvocationService;
import com.threerings.presents.data.ClientObject;

public interface MatchService extends InvocationService<ClientObject> {
    void sendMessage(AztecMessage message);
}
