//
// aztec

package aztec.battle.controller {

import aztec.battle.BattleCtx;
import aztec.battle.view.VillagerView;

public class Villager extends NetObject
{
    public static function getCount (ctx :BattleCtx) :int {
        return ctx.netObjects.getObjectRefsInGroup(Villager).length;
    }
    
    public static function withName (ctx :BattleCtx, name :String) :Villager {
        return Villager(ctx.netObjects.getObjectNamed(villagerName(name)));
    }
    
    public static function getAll (ctx :BattleCtx) :Array {
        return ctx.netObjects.getObjectsInGroup(Villager);
    }
    
    public function Villager (name :String) {
        _name = name;
    }
    
    public function select (player :Player) :void {
        _selectedBy = player;
        _view.textView.select(_name.length, player.desc.color);
    }
    
    public function deselect () :void {
        _selectedBy = null;
        _view.textView.deselect();
    }
    
    public function get name () :String {
        return _name;
    }
    
    public function get firstLetter () :String {
        return _name.substr(0, 1);
    }

    public function sacrifice () :void {
        destroySelf();
    }
    
    public function get view () :VillagerView {
        return _view;
    }
    
    override public function get objectNames () :Array {
        return [ villagerName(_name) ].concat(super.objectNames);
    }
    
    override public function get objectGroups () :Array {
        return [ Villager ].concat(super.objectGroups);
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
    protected var _selectedBy :Player;
}
}
