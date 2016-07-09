//
// SPACK
// GENERATED PREAMBLE START
package aztec.data {

import com.threerings.io.ObjectInputStream;
import com.threerings.io.ObjectOutputStream;
import com.threerings.io.SimpleStreamableObject;

// GENERATED PREAMBLE END

// GENERATED CLASSDECL START
public class AztecMessage extends SimpleStreamableObject
{
// GENERATED CLASSDECL END

// GENERATED STREAMING START
    public var senderId :int;

    override public function readObject (ins :ObjectInputStream) :void
    {
        super.readObject(ins);
        senderId = ins.readInt();
    }

    override public function writeObject (out :ObjectOutputStream) :void
    {
        super.writeObject(out);
        out.writeInt(senderId);
    }

// GENERATED STREAMING END

// GENERATED CLASSFINISH START
}
}
// GENERATED CLASSFINISH END

