//
// aztec

package aztec.battle.controller {
import aspire.geom.Vector2;
import aspire.util.Log;

import aztec.battle.BattleCtx;
import aztec.battle.desc.GameDesc;
import aztec.battle.VillagerAction;
import aztec.battle.desc.PlayerDesc;
import aztec.battle.view.ActorVerbMenu;
import aztec.battle.view.FestivalView;
import aztec.battle.view.HeartView;
import aztec.battle.view.TempleView;
import aztec.data.SummonMessage;

import flashbang.core.GameObjectRef;

public class Player extends NetObject
{
    public var templeHealth :Number = 1;
    public var templeDefense :Number = 1;
    public var summonPower :int = 0;
    public var affinitySign :int;

    public static function withOid (ctx :BattleCtx, oid :int) :Player {
        return Player(ctx.netObjects.getObjectNamed(nameForOid(oid)));
    }

    public static function withOtherOid(ctx:BattleCtx, senderOid:int) :Player {
        const players :Array = ctx.netObjects.getObjectsInGroup(Player);
        return players[0].oid == senderOid ? players[1] : players[0];
    }

    public static function getAll(ctx:BattleCtx) :Array {

        return ctx.netObjects.getObjectsInGroup(Player);
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
    
    public function get isLocalPlayer () :Boolean {
        return _ctx.localPlayer == this;
    }
    
    public function selectVillager (villager :Villager) :void {
        deselectVillager();
        _selectedVillager = villager.ref;
        villager.selected.dispatch();
        villager.view.textView.select(villager.name.length, _desc.color);
        
        if (this.isLocalPlayer) {
            // throw up a verb menu
            var verbs :Array = VillagerAction.values().map(
                function (o :VillagerAction, ..._) :String {
                    return o.name();
                });
            var verbMenu :ActorVerbMenu = new ActorVerbMenu(verbs);
            verbMenu.display.x = 400;
            verbMenu.display.y = 200
            _ctx.viewObjects.addObject(verbMenu, _ctx.uiLayer);
            
            _regs.addSignalListener(verbMenu.verbSelected, function (verbName :String) :void {
                verbMenu.destroySelf();
                if (_selectedVillager == villager.ref) {
                    _ctx.messages
                }
            });
            
            _regs.addSignalListener(verbMenu.canceled, function () :void {
                verbMenu.destroySelf();
                if (_selectedVillager == villager.ref) {
                    _ctx.messages.deselectVillager(villager);
                }
            });
        }
    }
    
    public function deselectVillager () :void {
        if (this.selectedVillager != null) {
            this.selectedVillager.view.textView.deselect();
            _selectedVillager = GameObjectRef.Null();
        }
    }

    public function summon (msg :SummonMessage) :void {
        if (msg.senderOid == _oid) {
            if (msg.power > summonPower) { log.warning("Asked to summon with more power than present!", "summonPower", summonPower, "requestedPower", msg.power)}
            var powerUsed :int = Math.min(msg.power, summonPower);
            summonPower -= powerUsed;
            for (; powerUsed > 0; powerUsed--) {
                _heartView.removeHeart();
            }
        } else {
            var attack :Number = msg.power * .2;
            var defensePossible :Number = templeDefense * GameDesc.DEFENSE_STRENGTH;
            var defenseUsed :Number = Math.min(defensePossible, attack);
            templeDefense = Math.max(0, templeDefense - defenseUsed / GameDesc.DEFENSE_STRENGTH);
            attack -= defenseUsed;
            templeHealth -= attack;
            _templeView.updateHealth(templeHealth);
            _templeView.updateDefense(templeDefense);
        }
    }

    /*public function sacrifice (msg :SacrificeMessage) :void {
        if (msg.senderOid == _oid) {
            summonPower++;
            _heartView.addHeart();
        }
    }*/
    
    override protected function addedToMode () :void {
        super.addedToMode();

        affinitySign = _ctx.players[0] == this ? -1 : 1;
        
        _templeView = new TempleView(_desc.color);
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
        _heartView.sprite.x = desc.heartLoc.x;
        _heartView.sprite.y = desc.heartLoc.y;
        _ctx.viewObjects.addObject(_heartView, _ctx.uiLayer);
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

    private static const log :Log = Log.getLog(Player);
}
}
