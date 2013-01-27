//
// aztec

package aztec.battle.controller {

import aspire.geom.Vector2;
import aspire.util.Log;
import aspire.util.MathUtil;
import aspire.util.Preconditions;

import aztec.battle.BattleCtx;
import aztec.battle.God;
import aztec.battle.VillagerAction;
import aztec.battle.desc.GameDesc;
import aztec.battle.desc.PlayerDesc;
import aztec.battle.view.ActorVerbMenu;
import aztec.battle.view.FestivalView;
import aztec.battle.view.HeartView;
import aztec.battle.view.TempleView;
import aztec.data.SummonMessage;

import flashbang.core.GameObjectRef;

public class Player extends NetObject
{
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
    
    public function Player(oid:int, name:String, desc:PlayerDesc, localPlayer:Boolean) {
        _oid = oid;
        _name = name;
        _desc = desc;
        _localPlayer = localPlayer;
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
        return _localPlayer;
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
                    var action :VillagerAction = VillagerAction.valueOf(verbName);
                    _ctx.messages.doVillagerAction(villager, action);
                    // hide the selected text
                    villager.textSprite.deselect();
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

    public function handleSummon (god :God, summoner :Player) :void {
        if (this == summoner) {
            var heartsUsed :int = GameDesc.godHearts(god);
            _hearts -= heartsUsed;
            for (; heartsUsed > 0; heartsUsed--) {
                _heartView.removeHeart();
            }
            
        } else {
            var damage :Number = GameDesc.godDamage(god);
            var defensePossible :Number = _templeDefense * GameDesc.DEFENSE_STRENGTH;
            var defenseUsed :Number = Math.min(defensePossible, damage);
            offsetDefense(defenseUsed);
            damage -= defenseUsed;
            offsetHealth(-damage);
        }
    }
    
    public function canSummon (god :God) :Boolean {
        return (_hearts >= GameDesc.godHearts(god));
    }
    
    public function sacrifice (villager :Villager) :void {
        _hearts++;
        _heartView.addHeart();
    }
    
    public function worship (villager :Villager) :void {
        offsetDefense(GameDesc.worshipDefenseOffset);
    }
    
    protected function offsetDefense (offset :Number) :void {
        _templeDefense = MathUtil.clamp(_templeDefense + offset, 0, 1);
        _templeView.updateDefense(_templeDefense);
    }
    
    protected function offsetHealth (offset :Number) :void {
        _templeHealth = MathUtil.clamp(_templeHealth + offset, 0, 1);
        _templeView.updateHealth(_templeHealth);
    }
    
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
    protected var _localPlayer :Boolean;
    
    protected var _templeHealth :Number = 1;
    protected var _templeDefense :Number = 0;
    protected var _hearts :int = 0;

    protected var _selectedVillager :GameObjectRef = GameObjectRef.Null();
    
    protected var _templeView :TempleView;
    protected var _festivalView :FestivalView;
    protected var _heartView :HeartView;

    private static const log :Log = Log.getLog(Player);
}
}
