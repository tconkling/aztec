//
// Aztec

package aztec.battle {

import aspire.util.Enum;

public final class VillagerAction extends Enum
{
    public static const SACRIFICE :VillagerAction = new VillagerAction("SACRIFICE",
        "aztec/sacrifice_header");
    public static const FESTIVAL :VillagerAction = new VillagerAction("FESTIVAL",
        "aztec/festival_header");
    public static const WORSHIP :VillagerAction = new VillagerAction("WORSHIP",
        "aztec/worship_header");
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
    
    public function get promptName () :String {
        return _promptName;
    }
    
    /** @private */
    public function VillagerAction (name :String, promptName :String) {
        super(name);
        _promptName = promptName;
    }
    
    protected var _promptName :String;
}
}

