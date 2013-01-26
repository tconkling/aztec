//
// SPACK
// GENERATED PREAMBLE START
package aztec.data {

import aztec.data.AztecMessage;

import com.threerings.io.ObjectInputStream;
import com.threerings.io.ObjectOutputStream;

// GENERATED PREAMBLE END

// GENERATED CLASSDECL START
public class MoveMessage extends AztecMessage
{
// GENERATED CLASSDECL END

    public function MoveMessage (x :int = 0, y :int = 0) {
        this.x = x;
        this.y = y;
    }

// GENERATED STREAMING START
    public var x :int;

    public var y :int;

    override public function readObject (ins :ObjectInputStream) :void
    {
        super.readObject(ins);
        x = ins.readInt();
        y = ins.readInt();
    }

    override public function writeObject (out :ObjectOutputStream) :void
    {
        super.writeObject(out);
        out.writeInt(x);
        out.writeInt(y);
    }

// GENERATED STREAMING END

// GENERATED CLASSFINISH START
}
}
// GENERATED CLASSFINISH END

