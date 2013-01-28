//
// Aztec

package aztec {

import aspire.util.Enum;

public final class NewGameCondition extends Enum
{
    public static const INITIAL :NewGameCondition = new NewGameCondition("INITIAL");
    public static const WON :NewGameCondition = new NewGameCondition("WON");
    public static const LOST :NewGameCondition = new NewGameCondition("LOST");
    finishedEnumerating(NewGameCondition);
    
    /**
     * Get the values of the NewGameCondition enum
     */
    public static function values () :Array {
        return Enum.values(NewGameCondition);
    }
    
    /**
     * Get the value of the NewGameCondition enum that corresponds to the specified string.
     * If the value requested does not exist, an ArgumentError will be thrown.
     */
    public static function valueOf (name :String) :NewGameCondition {
        return Enum.valueOf(NewGameCondition, name) as NewGameCondition;
    }
    
    /** @private */
    public function NewGameCondition (name :String) {
        super(name);
    }
}
}

