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
    
    public static function getAll (ctx :BattleCtx) :Array {
        return ctx.netObjects.getObjectsInGroup(GROUP);
    }
    
    public function Villager (name :String) {
        _name = name;
    }
    
    public function select (playerOid :int) :void {
        _selectedByPlayerOid = playerOid;
        _view.textView.select(_name.length);
    }
    
    public function deselect () :void {
        _selectedByPlayerOid = 0;
        _view.textView.deselect();
    }
    
    public function get name () :String {
        return _name;
    }
    
    public function get firstLetter () :String {
        return _name.substr(0, 1);
    }
    
    public function get view () :VillagerView {
        return _view;
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
    protected var _selectedByPlayerOid :int;
    
    protected static const GROUP :String = "Villager";
}
}
