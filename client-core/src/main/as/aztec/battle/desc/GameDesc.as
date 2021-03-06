//
// aztec

package aztec.battle.desc {

import aspire.geom.Vector2;

import aztec.battle.God;

import flash.geom.Rectangle;

public class GameDesc
{
    public static const VILLAGER_ALERT_LOC :Vector2 = new Vector2(512, 100);

    public static const BOARD_SIZE :Vector2 = new Vector2(1024, 768);

    public static const numVillagers :int = 6;
    public static const villagerWalkBounds :Rectangle = new Rectangle(336, 190, 353, 319);

    /** Attack absorbed by defense as a percentage of attack absorbed by health. */
    public static const DEFENSE_STRENGTH :Number = .5;

    public static const initialAffinity :Number = 1.0;
    public static const initialDefense :Number = 0.15;

    public static const sacrificeAffinityOffset :Number = -0.2;

    public static const festivalTime :Number = 45;
    public static const worshipTime :Number = 45;
    public static const festivalAffinityPerSecond :Number = 0.2 / festivalTime;
    public static const worshipDefensePerSecond :Number = 0.4 / worshipTime;

    public static const summonDestroysOpponentVillagers :Boolean = true;

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
        case God.QUETZ: return 0.1;
        case God.HUITZ: return 0.4;
        case God.TLAH: return 0.8;
        }
        throw new Error("Unrecognized god " + god);
    }

    public static const player1 :PlayerDesc = get_player1();
    public static const player2 :PlayerDesc = get_player2();

    protected static function get_player1 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.color = 0xE15656;

        desc.sacrificeLoc.x = 194;
        desc.sacrificeLoc.y = 257;
        desc.templeLoc.x = 188;
        desc.templeLoc.y = 448;
        desc.festivalLoc.x = 256;
        desc.festivalLoc.y = 627;

        desc.heartLoc.x = 35;
        desc.heartLoc.y = 170;

        desc.sacrificeCommandLoc.x = 318;
        desc.sacrificeCommandLoc.y = 152;
        desc.worshipCommandLoc.x = 368;
        desc.worshipCommandLoc.y = 332;
        desc.festivalCommandLoc.x = 328;
        desc.festivalCommandLoc.y = 498;

        return desc;
    }

    protected static function get_player2 () :PlayerDesc {
        var desc :PlayerDesc = new PlayerDesc();
        desc.color = 0x6191C5;

        desc.sacrificeLoc.x = 835;
        desc.sacrificeLoc.y = 257;
        desc.templeLoc.x = 832;
        desc.templeLoc.y = 448;
        desc.festivalLoc.x = 768;
        desc.festivalLoc.y = 627;
        desc.heartLoc.x = 990;
        desc.heartLoc.y = 170;
        desc.displayedOnRight = true;

        desc.sacrificeCommandLoc.x = 588;
        desc.sacrificeCommandLoc.y = 152;
        desc.worshipCommandLoc.x = 528;
        desc.worshipCommandLoc.y = 332;
        desc.festivalCommandLoc.x = 578;
        desc.festivalCommandLoc.y = 498;

        return desc;
    }
}
}
