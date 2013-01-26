//
// aztec

package aztec.battle.controller {

import aztec.battle.BattleCtx;
import aztec.battle.view.VillagerView;

public class Villager extends NetObject
{
    public static function getCount (ctx :BattleCtx) :int {
        return ctx.netObjects.getObjectRefsInGroup(GROUP).length;
    }
    
    public static function withName (ctx :BattleCtx, name :String) :Villager {
        return Villager(ctx.netObjects.getObjectNamed(villagerName(name)));
    }
    
    public function Villager (name :String) {
        _name = name;
    }
    
    public function get name () :String {
        return _name;
    }
    
    override public function get objectNames () :Array {
        return [ villagerName(_name) ].concat(super.objectNames);
    }
    
    override public function get objectGroups () :Array {
        return [ GROUP ].concat(super.objectGroups);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        _view = new VillagerView(this);
        _ctx.viewObjects.addObject(_view, _ctx.board.view.objectLayer);
    }
    
    protected static function villagerName (name :String) :String {
        return "Villager_" + name;
    }
    
    protected var _name :String;
    protected var _view :VillagerView;
    
    protected static const GROUP :String = "Villager";
}
}
