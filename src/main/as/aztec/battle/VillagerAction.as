//
// Aztec

package aztec.battle {

import aspire.util.Enum;

public final class VillagerAction extends Enum
{
    public static const SACRIFICE :VillagerAction = new VillagerAction("SACRIFICE",
        "Sacrifice: +Heart, --Villager Affinity");
    public static const FESTIVAL :VillagerAction = new VillagerAction("FESTIVAL",
        "Festival: +Villager Affinity");
    public static const WORSHIP :VillagerAction = new VillagerAction("WORSHIP",
        "Worship: +Temple Defense");
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
    
    public function get description () :String {
        return _description;
    }
    
    /** @private */
    public function VillagerAction (name :String, description :String) {
        super(name);
        _description = description;
    }
    
    protected var _description :String;
}
}

