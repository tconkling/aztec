//
// aztec

package aztec.battle.desc {
import aspire.geom.Vector2;

public class GameDesc
{
    public static const numVillagers :int = 6;
    public static const villagerLoc :Vector2 = new Vector2(8, 5);
    public static const villagerSpread :Number = 4;

    /** Attack absorbed by defense as a percentage of attack absorbed by health. */
    public static const DEFENSE_STRENGTH :Number = .5;
    
    public static const player1 :PlayerDesc = get_player1();
    public static const player2 :PlayerDesc = get_player2();
    
    protected static function get_player1 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.color = 0xFF2109;
        desc.templeLoc.x = 2;
        desc.templeLoc.y = 6;
        desc.festivalLoc.x = 4;
        desc.festivalLoc.y = 10;
        desc.heartLoc.x = 35;
        desc.heartLoc.y = 700;
        return desc;
    }
    
    protected static function get_player2 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.color = 0x1B23DE;
        desc.templeLoc.x = 14;
        desc.templeLoc.y = 6;
        desc.festivalLoc.x = 12;
        desc.festivalLoc.y = 10;
        desc.heartLoc.x = 990;
        desc.heartLoc.y = 700;
        return desc;
    }
}
}
