//
// Aztec

package aztec.battle {

import aspire.util.Enum;

public final class God extends Enum
{
    public static const QUETZ :God  = new God("QUETZ", "Quetzalcoatl", 1);
    public static const HUITZ :God  = new God("HUITZ", "Huitzilopochtli", 2);
    public static const TLAH :God  = new God("TLAH", "Tlahuizcalpantecuhtli", 3);
    finishedEnumerating(God);
    
    /**
     * Get the values of the God enum
     */
    public static function values () :Array {
        return Enum.values(God);
    }
    
    /**
     * Get the value of the God enum that corresponds to the specified string.
     * If the value requested does not exist, an ArgumentError will be thrown.
     */
    public static function valueOf (name :String) :God {
        return Enum.valueOf(God, name) as God;
    }
    
    public function get displayName () :String {
        return _displayName;
    }
    
    public function get level () :int {
        return _level;
    }
    
    /** @private */
    public function God (name :String, displayName :String, level :int) {
        super(name);
        _displayName = displayName;
        _level = level;
    }
    
    protected var _displayName :String;
    protected var _level :int;
}
}

