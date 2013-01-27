//
// aztec

package aztec {

import aspire.geom.Vector2;
import aspire.util.Randoms;

public class Aztec
{
    public static const NETWORK_UPDATE_RATE :Number = 1.0 / 10.0; // 10 messages/sec
        
    /** Constants */
    public static const UI_FONT :String = "futura";
    
    public static const rands :Randoms = new Randoms();

    public static const MULTIPLAYER :Boolean = false;
    public static const SERVER :String = "localhost";
//    public static const SERVER :String = "aztec.bungleton.com";
}
}
