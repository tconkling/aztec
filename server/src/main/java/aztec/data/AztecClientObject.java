package aztec.data;

import javax.annotation.Generated;
import com.threerings.presents.data.ClientObject;

public class AztecClientObject extends ClientObject {

    // AUTO-GENERATED: FIELDS START
    /** The field name of the <code>matchOid</code> field. */
    @Generated(value={"com.threerings.presents.tools.GenDObjectTask"})
    public static final String MATCH_OID = "matchOid";
    // AUTO-GENERATED: FIELDS END

    public int matchOid;

    // AUTO-GENERATED: METHODS START
    /**
     * Requests that the <code>matchOid</code> field be set to the
     * specified value. The local value will be updated immediately and an
     * event will be propagated through the system to notify all listeners
     * that the attribute did change. Proxied copies of this object (on
     * clients) will apply the value change when they received the
     * attribute changed notification.
     */
    @Generated(value={"com.threerings.presents.tools.GenDObjectTask"})
    public void setMatchOid (int value)
    {
        int ovalue = this.matchOid;
        requestAttributeChange(
            MATCH_OID, Integer.valueOf(value), Integer.valueOf(ovalue));
        this.matchOid = value;
    }
    // AUTO-GENERATED: METHODS END
}
