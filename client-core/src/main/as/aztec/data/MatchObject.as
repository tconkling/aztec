//
// SPACK
// GENERATED PREAMBLE START
package aztec.data {

import aztec.data.MatchMarshaller;
import org.osflash.signals.Signal;

import com.threerings.io.ObjectInputStream;
import com.threerings.io.ObjectOutputStream;
import com.threerings.io.TypedArray;

import com.threerings.util.Name;

import com.threerings.presents.dobj.DObject;

// GENERATED PREAMBLE END

// GENERATED CLASSDECL START
public class MatchObject extends DObject
{
// GENERATED CLASSDECL END

// GENERATED STREAMING START
    public var marshaller :MatchMarshaller;

    public var messages :TypedArray;

    public var player1 :Name;

    public var player2 :Name;

    public var seed :int;

    public var marshallerChanged :Signal = new Signal(MatchMarshaller, MatchMarshaller);
    public var messagesChanged :Signal = new Signal(TypedArray, TypedArray);
    public var messagesElementUpdated :Signal = new Signal(int, Object, Object);
    public var player1Changed :Signal = new Signal(Name, Name);
    public var player2Changed :Signal = new Signal(Name, Name);
    public var seedChanged :Signal = new Signal(int, int);

    public static const MARSHALLER :String = "marshaller";
    public static const MESSAGES :String = "messages";
    public static const PLAYER1 :String = "player1";
    public static const PLAYER2 :String = "player2";
    public static const SEED :String = "seed";

    override public function readObject (ins :ObjectInputStream) :void
    {
        super.readObject(ins);
        marshaller = ins.readObject(MatchMarshaller);
        messages = ins.readObject(TypedArray);
        player1 = ins.readObject(Name);
        player2 = ins.readObject(Name);
        seed = ins.readInt();
    }

    public function MatchObject ()
    {
        new Signaller(this);
    }
// GENERATED STREAMING END

// GENERATED CLASSFINISH START
}
}
// GENERATED CLASSFINISH END

// GENERATED SIGNALLER START
import org.osflash.signals.Signal;

import com.threerings.presents.dobj.AttributeChangeListener;
import com.threerings.presents.dobj.AttributeChangedEvent;
import com.threerings.presents.dobj.ElementUpdateListener;
import com.threerings.presents.dobj.ElementUpdatedEvent;
import com.threerings.presents.dobj.EntryAddedEvent;
import com.threerings.presents.dobj.EntryRemovedEvent;
import com.threerings.presents.dobj.EntryUpdatedEvent;
import com.threerings.presents.dobj.MessageEvent;
import com.threerings.presents.dobj.MessageListener;
import com.threerings.presents.dobj.ObjectAddedEvent;
import com.threerings.presents.dobj.ObjectDeathListener;
import com.threerings.presents.dobj.ObjectDestroyedEvent;
import com.threerings.presents.dobj.ObjectRemovedEvent;
import com.threerings.presents.dobj.OidListListener;
import com.threerings.presents.dobj.SetListener;

import aztec.data.MatchObject;

class Signaller
    implements AttributeChangeListener, SetListener, ElementUpdateListener, OidListListener
{
    public function Signaller (obj :MatchObject)
    {
        _obj = obj;
        _obj.addListener(this);
    }

    public function attributeChanged (event :AttributeChangedEvent) :void
    {
        var signal :Signal;
        switch (event.getName()) {
            case "marshaller":
                signal = _obj.marshallerChanged;
                break;
            case "messages":
                signal = _obj.messagesChanged;
                break;
            case "player1":
                signal = _obj.player1Changed;
                break;
            case "player2":
                signal = _obj.player2Changed;
                break;
            case "seed":
                signal = _obj.seedChanged;
                break;
            default:
                return;
        }
        signal.dispatch(event.getValue(), event.getOldValue());
    }

    public function entryAdded (event :EntryAddedEvent) :void
    {
        var signal :Signal;
        switch (event.getName()) {
            default:
                return;
        }
        signal.dispatch(event.getEntry());
    }

    public function entryRemoved (event :EntryRemovedEvent) :void
    {
        var signal :Signal;
        switch (event.getName()) {
            default:
                return;
        }
        signal.dispatch(event.getOldEntry());
    }

    public function entryUpdated (event :EntryUpdatedEvent) :void
    {
        var signal :Signal;
        switch (event.getName()) {
            default:
                return;
        }
        signal.dispatch(event.getEntry(), event.getOldEntry());
    }

    public function elementUpdated (event :ElementUpdatedEvent) :void
    {
        var signal :Signal;
        switch (event.getName()) {
            case "messages":
                signal = _obj.messagesElementUpdated;
                break;
            default:
                return;
        }
        signal.dispatch(event.getIndex(), event.getValue(), event.getOldValue());
    }

    public function objectAdded (event :ObjectAddedEvent) :void
    {
        var signal :Signal;
        switch (event.getName()) {
            default:
                return;
        }
        signal.dispatch(event.getOid());
    }

    public function objectRemoved (event :ObjectRemovedEvent) :void
    {
        var signal :Signal;
        switch (event.getName()) {
            default:
                return;
        }
        signal.dispatch(event.getOid());
    }

    protected var _obj :MatchObject;
}
// GENERATED SIGNALLER END
