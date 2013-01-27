//
// aztec

package aztec.battle.controller {
import aspire.geom.Vector2;

import aztec.battle.BattleCtx;
import aztec.battle.desc.PlayerDesc;
import aztec.battle.view.FestivalView;
import aztec.battle.view.HeartView;
import aztec.battle.view.TempleView;
import aztec.battle.BattleCtx;
import aztec.data.SacrificeMessage;

import flashbang.core.GameObjectRef;

public class Player extends NetObject
{
    public var templeHealth :Number = 1;
    public var templeDefense :Number = 0;
    public var summonPower :int = 0;
    public var villagerAffinity :Number = .5;

    public static function withOid (ctx :BattleCtx, oid :int) :Player {
        return Player(ctx.netObjects.getObjectNamed(nameForOid(oid)));
    }
    
    public function Player (oid :int, name :String, desc :PlayerDesc) {
        _oid = oid;
        _name = name;
        _desc = desc;
    }
    
    public function get name () :String { return _name; }
    public function get oid () :int { return _oid; }
    public function get desc () :PlayerDesc { return _desc; }
    
    override public function get objectNames () :Array {
        return [ nameForOid(oid) ].concat(super.objectNames);
    }

    override public function get objectGroups () :Array {
        return [ Player ].concat(super.objectGroups);
    }
    
    public function get selectedVillager () :Villager {
        return Villager(_selectedVillager.object);
    }
    
    public function selectVillager (villager :Villager) :void {
        deselectVillager();
        _selectedVillager = villager.ref;
        villager.selected.dispatch();
        villager.view.textView.select(villager.name.length, _desc.color);
    }
    
    public function deselectVillager () :void {
        if (this.selectedVillager != null) {
            this.selectedVillager.view.textView.deselect();
            _selectedVillager = GameObjectRef.Null();
        }
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        _templeView = new TempleView();
        var loc :Vector2 = _ctx.board.view.boardToLocal(_desc.templeLoc);
        _templeView.display.x = loc.x;
        _templeView.display.y = loc.y;
        _ctx.viewObjects.addObject(_templeView, _ctx.board.view.objectLayer);

        _festivalView = new FestivalView();
        loc = _ctx.board.view.boardToLocal(_desc.festivalLoc);
        _festivalView.display.x = loc.x;
        _festivalView.display.y = loc.y;
        _ctx.viewObjects.addObject(_festivalView, _ctx.board.view.objectLayer);

        _heartView = new HeartView();
        _heartView.sprite.x = desc.player1 ? 35 : 990;
        _heartView.sprite.y = 700;
        _ctx.viewObjects.addObject(_heartView, _ctx.uiLayer);


    }
    public function sacrifice(msg:SacrificeMessage):void {
        if (msg.senderOid == _oid) {
            villagerAffinity -= .2;
            summonPower++;
            _heartView.addHeart();
        } else {
            villagerAffinity += .2;
        }
    }
    
    protected static function nameForOid (oid :int) :String {
        return "Player_" + oid;
    }
    
    protected var _oid :int;
    protected var _name :String;
    protected var _desc :PlayerDesc;
    
    protected var _selectedVillager :GameObjectRef = GameObjectRef.Null();
    
    protected var _templeView :TempleView;
    protected var _festivalView :FestivalView;
    protected var _heartView :HeartView;

}
}
