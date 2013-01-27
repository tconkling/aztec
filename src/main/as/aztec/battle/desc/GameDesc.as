//
// aztec

package aztec.battle.desc {

import aspire.geom.Vector2;

import aztec.battle.God;

import flash.geom.Rectangle;

public class GameDesc
{
    public static const BOARD_SIZE :Vector2 = new Vector2(1024, 768);
    
    public static const numVillagers :int = 8;
    public static const villagerWalkBounds :Rectangle = new Rectangle(250, 129, 433, 345);
    public static const villagerSpread :Number = 4 * 64;

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
        desc.templeLoc.x = 2 * 64;
        desc.templeLoc.y = 7 * 64;
        desc.festivalLoc.x = 4 * 64;
        desc.festivalLoc.y = 11 * 64;
        desc.heartLoc.x = 35;
        desc.heartLoc.y = 170;
        
        desc.sacrificeCommandLoc.x = 40;
        desc.sacrificeCommandLoc.y = 152;
        desc.festivalCommandLoc.x = 119;
        desc.festivalCommandLoc.y = 498;
        desc.worshipCommandLoc.x = 348;
        desc.worshipCommandLoc.y = 332;
        
        desc.sacrificeLoc.x = 114;
        desc.sacrificeLoc.y = 239;
        return desc;
    }
    
    protected static function get_player2 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.color = 0x1B23DE;
        desc.templeLoc.x = 13 * 64;
        desc.templeLoc.y = 7 * 64;
        desc.festivalLoc.x = 12 * 64;
        desc.festivalLoc.y = 11 * 64;
        desc.heartLoc.x = 990;
        desc.heartLoc.y = 170;
        desc.displayedOnRight = true;
        
        desc.sacrificeCommandLoc.x = 575;
        desc.sacrificeCommandLoc.y = 152;
        desc.festivalCommandLoc.x = 619;
        desc.festivalCommandLoc.y = 498;
        desc.worshipCommandLoc.x = 348;
        desc.worshipCommandLoc.y = 332;
        
        desc.sacrificeLoc.x = 820;
        desc.sacrificeLoc.y = 221;
        return desc;
    }
}
}
