//
// aztec

package aztec.battle.desc {

public class GameDesc
{
    public static const player1 :PlayerDesc = get_player1();
    
    public static const player2 :PlayerDesc = get_player2();
    
    protected static function get_player1 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.templeLoc.x = 2;
        desc.templeLoc.y = 6;
        return desc;
    }
    
    protected static function get_player2 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.templeLoc.x = 14;
        desc.templeLoc.y = 6;
        return desc;
    }
}
}
