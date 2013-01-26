//
// SPACK
// GENERATED PREAMBLE START
package aztec.data {

import com.threerings.io.ObjectInputStream;
import com.threerings.io.ObjectOutputStream;

import com.threerings.presents.net.BootstrapData;

// GENERATED PREAMBLE END

// GENERATED CLASSDECL START
public class AztecBootstrapData extends BootstrapData
{
// GENERATED CLASSDECL END

// GENERATED STREAMING START
    public var matchOid :int;

    override public function readObject (ins :ObjectInputStream) :void
    {
        super.readObject(ins);
        matchOid = ins.readInt();
    }

    override public function writeObject (out :ObjectOutputStream) :void
    {
        super.writeObject(out);
        out.writeInt(matchOid);
    }

// GENERATED STREAMING END

// GENERATED CLASSFINISH START
}
}
// GENERATED CLASSFINISH END

