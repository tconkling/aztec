package aztec;

import aztec.data.AztecClientObject;
import com.threerings.presents.data.ClientObject;
import com.threerings.presents.server.ClientResolver;

public class AztecClientResolver extends ClientResolver {
    @Override
    public ClientObject createClientObject() {
        return new AztecClientObject();
    }
}
