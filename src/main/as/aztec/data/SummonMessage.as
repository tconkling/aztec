//
// SPACK
// GENERATED PREAMBLE START
package aztec.data {

import aztec.data.AztecMessage;

import com.threerings.io.ObjectInputStream;
import com.threerings.io.ObjectOutputStream;

// GENERATED PREAMBLE END

// GENERATED CLASSDECL START
public class SummonMessage extends AztecMessage
{
// GENERATED CLASSDECL END

// GENERATED STREAMING START
    public var attackStrength :Number;

    override public function readObject (ins :ObjectInputStream) :void
    {
        super.readObject(ins);
        attackStrength = ins.readFloat();
    }

    override public function writeObject (out :ObjectOutputStream) :void
    {
        super.writeObject(out);
        out.writeFloat(attackStrength);
    }

// GENERATED STREAMING END

// GENERATED CLASSFINISH START
}
}
// GENERATED CLASSFINISH END

