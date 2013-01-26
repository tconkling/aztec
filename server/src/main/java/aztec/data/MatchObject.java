package aztec.data;

import javax.annotation.Generated;
import com.threerings.presents.dobj.DObject;

public class MatchObject extends DObject {

    // AUTO-GENERATED: FIELDS START
    /** The field name of the <code>marshaller</code> field. */
    @Generated(value={"com.threerings.presents.tools.GenDObjectTask"})
    public static final String MARSHALLER = "marshaller";
    // AUTO-GENERATED: FIELDS END

    public MatchMarshaller marshaller;

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
    // AUTO-GENERATED: METHODS END
}
