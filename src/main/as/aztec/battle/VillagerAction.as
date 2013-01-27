//
// Aztec

package aztec.battle {

import aspire.util.Enum;

public final class VillagerAction extends Enum
{
    public static const SACRIFICE :VillagerAction = new VillagerAction("SACRIFICE");
    public static const FESTIVAL :VillagerAction = new VillagerAction("FESTIVAL");
    public static const WORSHIP :VillagerAction = new VillagerAction("WORSHIP");
    finishedEnumerating(VillagerAction);
    
    /**
     * Get the values of the VillagerVerb enum
     */
    public static function values () :Array
    {
        return Enum.values(VillagerAction);
    }
    
    /**
     * Get the value of the VillagerAction enum that corresponds to the specified string.
     * If the value requested does not exist, an ArgumentError will be thrown.
     */
    public static function valueOf (name :String) :VillagerAction
    {
        return Enum.valueOf(VillagerAction, name) as VillagerAction;
    }
    
    /** @private */
    public function VillagerAction (name :String)
    {
        super(name);
    }
}
}

