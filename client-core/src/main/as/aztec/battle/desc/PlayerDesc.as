//
// aztec

package aztec.battle.desc {

import aspire.display.ColorUtil;
import aspire.geom.Vector2;

public class PlayerDesc
{
    public var color :uint;
    public const templeLoc :Vector2 = new Vector2();
    public const festivalLoc :Vector2 = new Vector2();
    public const heartLoc :Vector2 = new Vector2();
    public var displayedOnRight :Boolean;

    public const sacrificeCommandLoc :Vector2 = new Vector2();
    public const festivalCommandLoc :Vector2 = new Vector2();
    public const worshipCommandLoc :Vector2 = new Vector2();
    public const nameLoc :Vector2 = new Vector2();

    public const sacrificeLoc :Vector2 = new Vector2();

    public function get darkColor () :uint {
        return ColorUtil.setBrightness(color, ColorUtil.getBrightness(color) * 0.8);
    }
}
}
