//
// aztec

package aztec.battle.desc {

import aspire.geom.Vector2;

import aztec.battle.God;

public class GameDesc
{
    public static const numVillagers :int = 6;
    public static const villagerLoc :Vector2 = new Vector2(8, 5);
    public static const villagerSpread :Number = 4;

    /** Attack absorbed by defense as a percentage of attack absorbed by health. */
    public static const DEFENSE_STRENGTH :Number = .5;
    
    public static const sacrificeAffinityOffset :Number = -0.2;
    public static const festivalAffinityOffset :Number = 0.1;
    public static const worshipDefenseOffset :Number = 0.1;

    public static const MAX_HEARTS :int = 5;
    
    public static function godHearts (god :God) :int {
        switch (god) {
        case God.QUETZ: return 1;
        case God.HUITZ: return 3;
        case God.TLAH: return 5;
        }
        throw new Error("Unrecognized god " + god);
    }
    
    public static function godDamage (god :God) :Number {
        switch (god) {
        case God.QUETZ: return 0.05;
        case God.HUITZ: return 0.2;
        case God.TLAH: return 0.5;
        }
        throw new Error("Unrecognized god " + god);
    }
    
    public static const player1 :PlayerDesc = get_player1();
    public static const player2 :PlayerDesc = get_player2();
    
    protected static function get_player1 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.color = 0xFF2109;
        desc.templeLoc.x = 2;
        desc.templeLoc.y = 7;
        desc.festivalLoc.x = 4;
        desc.festivalLoc.y = 10;
        desc.heartLoc.x = 35;
        desc.heartLoc.y = 170;
        return desc;
    }
    
    protected static function get_player2 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.color = 0x1B23DE;
        desc.templeLoc.x = 13;
        desc.templeLoc.y = 7;
        desc.festivalLoc.x = 12;
        desc.festivalLoc.y = 10;
        desc.heartLoc.x = 990;
        desc.heartLoc.y = 170;
        return desc;
    }
}
}
