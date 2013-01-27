//
// aztec

package aztec.battle.controller {

import aspire.util.Log;

import aztec.battle.BattleCtx;
import aztec.battle.Selectable;
import aztec.battle.VillagerAction;
import aztec.battle.view.SelectableTextSprite;
import aztec.battle.view.VillagerView;

import org.osflash.signals.Signal;

public class Villager extends NetObject
    implements Selectable
{
    public const selected :Signal = new Signal();
    
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
    
    public function get name () :String {
        return _name;
    }
    
    public function get textSprite () :SelectableTextSprite {
        return _view.textView;
    }
    
    public function select (player :Player) :void {
        _view.textView.select(_name.length, player.desc.color);
    }
    
    public function deselect () :void {
        _view.textView.deselect();
    }
    
    public function get isSelected () :Boolean {
        for each (var player :Player in _ctx.players) {
            if (player.selectedVillager == this) {
                return true;
            }
        }
        return false;
    }
    
    public function performAction (action :VillagerAction, forPlayer :Player) :void {
        log.warning("TODO: villager animation");
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
    
    protected static const log :Log = Log.getLog(Villager);
}
}
