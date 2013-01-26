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
    
    override public function get objectGroups () :Array {
        return [ GROUP ].concat(super.objectGroups);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        _view = new VillagerView(this);
        _ctx.viewObjects.addObject(_view, _ctx.board.view.objectLayer);
    }
    
    protected var _view :VillagerView;
    
    protected static const GROUP :String = "Villager";
}
}
