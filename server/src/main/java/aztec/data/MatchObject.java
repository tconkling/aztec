package aztec.data;

import javax.annotation.Generated;
import com.threerings.presents.dobj.DObject;

public class MatchObject extends DObject {

    // AUTO-GENERATED: FIELDS START
    /** The field name of the <code>marshaller</code> field. */
    @Generated(value={"com.threerings.presents.tools.GenDObjectTask"})
    public static final String MARSHALLER = "marshaller";

    /** The field name of the <code>messages</code> field. */
    @Generated(value={"com.threerings.presents.tools.GenDObjectTask"})
    public static final String MESSAGES = "messages";
    // AUTO-GENERATED: FIELDS END

    public MatchMarshaller marshaller;

    public AztecMessage[] messages;

    // AUTO-GENERATED: METHODS START
    /**
     * Requests that the <code>marshaller</code> field be set to the
     * specified value. The local value will be updated immediately and an
     * event will be propagated through the system to notify all listeners
     * that the attribute did change. Proxied copies of this object (on
     * clients) will apply the value change when they received the
     * attribute changed notification.
     */
    @Generated(value={"com.threerings.presents.tools.GenDObjectTask"})
    public void setMarshaller (MatchMarshaller value)
    {
        MatchMarshaller ovalue = this.marshaller;
        requestAttributeChange(
            MARSHALLER, value, ovalue);
        this.marshaller = value;
    }

    /**
     * Requests that the <code>messages</code> field be set to the
     * specified value. The local value will be updated immediately and an
     * event will be propagated through the system to notify all listeners
     * that the attribute did change. Proxied copies of this object (on
     * clients) will apply the value change when they received the
     * attribute changed notification.
     */
    @Generated(value={"com.threerings.presents.tools.GenDObjectTask"})
    public void setMessages (AztecMessage[] value)
    {
        AztecMessage[] ovalue = this.messages;
        requestAttributeChange(
            MESSAGES, value, ovalue);
        this.messages = (value == null) ? null : value.clone();
    }

    /**
     * Requests that the <code>index</code>th element of
     * <code>messages</code> field be set to the specified value.
     * The local value will be updated immediately and an event will be
     * propagated through the system to notify all listeners that the
     * attribute did change. Proxied copies of this object (on clients)
     * will apply the value change when they received the attribute
     * changed notification.
     */
    @Generated(value={"com.threerings.presents.tools.GenDObjectTask"})
    public void setMessagesAt (AztecMessage value, int index)
    {
        AztecMessage ovalue = this.messages[index];
        requestElementUpdate(
            MESSAGES, index, value, ovalue);
        this.messages[index] = value;
    }
    // AUTO-GENERATED: METHODS END
}
