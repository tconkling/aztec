//
// aztec

package aztec {

public class Aztec {
    public static var newGameCondition :NewGameCondition;

    public static const WIDTH :Number = 1024;
    public static const HEIGHT :Number = 768;

    public static const NETWORK_UPDATE_RATE :Number = 1.0 / 10.0; // 10 messages/sec

    /** Constants */
    public static const UI_FONT :String = "futura";
    public static const COMMAND_FONT :String = "herculanum";

    public static const TITLE_FONT :String = "herculanumLarge";
    public static const TITLE_FONT2 :String = "arial";

    public static const TITLE_COLOR :uint = 0x192E20;

    public static const MULTIPLAYER :Boolean = true;
    //public static const SERVER :String = "localhost";
    public static const SERVER :String = "aztec.bungleton.com";
    public static const DEBUG :Boolean = false;
}
}
