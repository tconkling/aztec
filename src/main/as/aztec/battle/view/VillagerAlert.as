//
// aztec

package aztec.battle.view {

import aspire.geom.Vector2;
import aspire.util.StringUtil;

import aztec.Aztec;
import aztec.battle.BattleCtx;
import aztec.battle.VillagerAction;
import aztec.battle.controller.Player;
import aztec.battle.controller.Villager;
import aztec.battle.desc.GameDesc;
import aztec.text.CustomTextField;

import flashbang.tasks.AlphaTask;
import flashbang.tasks.LocationTask;
import flashbang.tasks.ParallelTask;
import flashbang.tasks.SelfDestructTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;
import flashbang.util.Easing;

import starling.display.DisplayObject;
import starling.text.TextFieldAutoSize;

public class VillagerAlert extends LocalSpriteObject
{
    public static const KILLED_BY_SUMMON :int = 0;
    public static const SACRIFICED :int = 1;
    public static const FESTIVALED :int = 2;
    public static const WORSHIPPED :int = 3;
    
    public static function typeForAction (action :VillagerAction) :int {
        switch (action) {
        case VillagerAction.FESTIVAL: return FESTIVALED;
        case VillagerAction.SACRIFICE: return SACRIFICED;
        case VillagerAction.WORSHIP: return WORSHIPPED;
        default: return KILLED_BY_SUMMON;
        }
    }
    
    public static function show (ctx :BattleCtx, type :int, player :Player, villagers :Array) :void {
        var alert :VillagerAlert = new VillagerAlert(type, player, villagers,
            GameDesc.VILLAGER_ALERT_LOC);
        ctx.viewObjects.addObject(alert, ctx.effectLayer);
    }
    
    public function VillagerAlert (type :int, player :Player, villagers :Array, loc :Vector2) {
        _loc = loc;
        
        var names :String = joinNames(villagers);
        var text :String;
        switch (type) {
        case KILLED_BY_SUMMON:
            text = names + (villagers.length > 1 ? " were " : " was ") + "roasted!";
            break;
        
        case SACRIFICED:
            text = player.name + " sacrificed " + names + "!";
            break;
        
        case FESTIVALED:
            text = player.name + " commanded " + names + " to dance!";
            break;
        
        case WORSHIPPED:
            text = player.name + " commanded " + names + " to worship!";
            break;
        }
        
        var tf :CustomTextField = new CustomTextField(1, 1, text, Aztec.UI_FONT, 24, 0xCD4843);
        tf.autoSize = TextFieldAutoSize.MULTI_LINE;
        tf.autoSizeMaxWidth = 300;
        
        const HPADDING :Number = 15;
        const VPADDING :Number = 15;
        
        var bg :DisplayObject = DisplayUtil.outlineFillRect(
            tf.width + (HPADDING * 2),
            tf.height + (VPADDING * 2),
            0xCCC99C, 2, 0x4B5C32);
        
        _sprite.addChild(bg);
        
        tf.x = HPADDING;
        tf.y = VPADDING;
        _sprite.addChild(tf);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        const Y_MOVE :Number = 60;
        
        var x :Number = _loc.x - (_sprite.width * 0.5);
        var y :Number = _loc.y - (_sprite.height * 0.5);
        
        _sprite.x = x;
        _sprite.y = y + Y_MOVE;
        _sprite.alpha = 0;
        
        addTask(new SerialTask(
            new ParallelTask(
                new LocationTask(x, y, 0.5, Easing.easeOut),
                new AlphaTask(1, 0.75)),
            new TimedTask(3),
            new ParallelTask(
                new LocationTask(x, y - Y_MOVE, 0.5, Easing.easeOut),
                new AlphaTask(0, 0.75)),
            new SelfDestructTask()));
    }
    
    protected static function joinNames (villagers :Array) :String {
        var text :String = "";
        
        var separator :String = (villagers.length > 2 ? ", " : " ");
        
        var needsSeparator :Boolean = false;
        for (var ii :int = 0; ii < villagers.length; ++ii) {
            if (needsSeparator) {
                text += separator;
                if (ii == villagers.length - 1) {
                    text += "and ";
                }
            }
            text += StringUtil.capitalize(Villager(villagers[ii]).name);
            needsSeparator = true;
        }
        
        return text;
    }
    
    protected var _loc :Vector2;
}
}
