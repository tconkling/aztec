//
// SPACK
// GENERATED PREAMBLE START
package aztec.data {

import aztec.data.AztecMessage;

import com.threerings.io.ObjectInputStream;
import com.threerings.io.ObjectOutputStream;

// GENERATED PREAMBLE END

// GENERATED CLASSDECL START
public class SacrificeMessage extends AztecMessage
{
// GENERATED CLASSDECL END

    public function SacrificeMessage (villagerName :String = null) {
        this.villager = villagerName;
    }

// GENERATED STREAMING START
    public var villager :String;

    override public function readObject (ins :ObjectInputStream) :void
    {
        super.readObject(ins);
        villager = ins.readField(String);
    }

    override public function writeObject (out :ObjectOutputStream) :void
    {
        super.writeObject(out);
        out.writeField(villager);
    }

// GENERATED STREAMING END

// GENERATED CLASSFINISH START
}
}
// GENERATED CLASSFINISH END

