//
// SPACK
// GENERATED PREAMBLE START
package aztec.data {

import aztec.data.AztecMessage;

import com.threerings.io.ObjectInputStream;
import com.threerings.io.ObjectOutputStream;

// GENERATED PREAMBLE END

// GENERATED CLASSDECL START
public class DeselectVillagerMessage extends AztecMessage
{
// GENERATED CLASSDECL END

// GENERATED STREAMING START
    public var villagerName :String;

    override public function readObject (ins :ObjectInputStream) :void
    {
        super.readObject(ins);
        villagerName = ins.readField(String);
    }

    override public function writeObject (out :ObjectOutputStream) :void
    {
        super.writeObject(out);
        out.writeField(villagerName);
    }

// GENERATED STREAMING END

// GENERATED CLASSFINISH START
}
}
// GENERATED CLASSFINISH END

