//
// aztec

package aztec.battle.desc {
import aspire.geom.Vector2;

public class GameDesc
{
    public static const numVillagers :int = 6;
    public static const villagerLoc :Vector2 = new Vector2(8, 5);
    public static const villagerSpread :Number = 4;
    
    public static const player1 :PlayerDesc = get_player1();
    public static const player2 :PlayerDesc = get_player2();
    
    protected static function get_player1 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.color = 0xFF2109;
        desc.templeLoc.x = 2;
        desc.templeLoc.y = 6;
        return desc;
    }
    
    protected static function get_player2 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.color = 0x1BDE23;
        desc.templeLoc.x = 14;
        desc.templeLoc.y = 6;
        return desc;
    }
}
}
