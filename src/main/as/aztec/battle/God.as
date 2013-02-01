//
// Aztec

package aztec.battle {

import aspire.util.Enum;

public final class God extends Enum
{
    public static const QUETZ :God  = new God("QUETZ", "Quetzalcoatl");
    public static const HUITZ :God  = new God("HUITZ", "Huitzilopochtli");
    public static const TLAH :God  = new God("TLAH", "Tlahuizcalpantecuhtli");
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

    /** @private */
    public function God (name :String, displayName :String) {
        super(name);
        _displayName = displayName;
    }

    protected var _displayName :String;
}
}

