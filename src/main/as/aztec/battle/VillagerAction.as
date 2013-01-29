//
// Aztec

package aztec.battle {

import aspire.util.Enum;

import aztec.battle.desc.GameDesc;

public final class VillagerAction extends Enum
{
    public static const DEFAULT :VillagerAction =
        new VillagerAction("DEFAULT", null, "aztec/villager_{var}");
    public static const SACRIFICE :VillagerAction =
        new VillagerAction("SACRIFICE", "aztec/sacrifice_header", "aztec/sacrifice");
    public static const FESTIVAL :VillagerAction =
        new VillagerAction("FESTIVAL", "aztec/festival_header", "aztec/villager_festival_{var}");
    public static const WORSHIP :VillagerAction =
        new VillagerAction("WORSHIP", "aztec/worship_header", "aztec/villager_worship_{var}");
    finishedEnumerating(VillagerAction);
    
    /**
     * Get the values of the VillagerAction enum
     */
    public static function values () :Array {
        return Enum.values(VillagerAction);
    }
    
    /**
     * Get the value of the VillagerAction enum that corresponds to the specified string.
     * If the value requested does not exist, an ArgumentError will be thrown.
     */
    public static function valueOf (name :String) :VillagerAction {
        return Enum.valueOf(VillagerAction, name) as VillagerAction;
    }
    
    public function get promptName () :String {
        return _promptName;
    }
    
    public function getViewMovieName (variation :int) :String {
        return _movieName.replace(RE, "" + variation);
    }
    
    public function get duration () :Number {
        switch (this) {
        case FESTIVAL: return GameDesc.festivalTime;
        case WORSHIP: return GameDesc.worshipTime;
        default: return 0;
        }
    }
    
    /** @private */
    public function VillagerAction (name :String, promptName :String, movieName :String) {
        super(name);
        _promptName = promptName;
        _movieName = movieName;
    }
    
    protected var _promptName :String;
    protected var _movieName :String;
    
    protected static const RE :RegExp = /\{var\}/g;
}
}

