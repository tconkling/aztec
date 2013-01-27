//
// aztec

package aztec.battle.controller {

import aspire.geom.Vector2;
import aspire.util.Log;
import aspire.util.MathUtil;

import aztec.battle.BattleCtx;
import aztec.battle.God;
import aztec.battle.VillagerAction;
import aztec.battle.VillagerCommand;
import aztec.battle.desc.GameDesc;
import aztec.battle.desc.PlayerDesc;
import aztec.battle.view.FestivalView;
import aztec.battle.view.HeartView;
import aztec.battle.view.TempleView;
import aztec.battle.view.VillagerCommandMenu;

import flashbang.core.GameObjectRef;

public class Player extends NetObject
{
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
    
    /** Map [-1, 1] to [0, 1] */
    public function get normalizedAffinity () :Number {
        return (1.0 + (_ctx.affinity.affinity * affinitySign)) * 0.5;
    }
    
    public function get affinitySign () :Number {
        return (_ctx.players[0] == this ? -1 : 1);
    }

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
            // show the command menu
            var commands :Array = VillagerAction.values().map(
                function (action :VillagerAction, ..._) :VillagerCommand {
                    return new VillagerCommand(
                        action,
                        getCommandText(villager, action),
                        getCommandLoc(action));
                });
            
            var commandMenu :VillagerCommandMenu = new VillagerCommandMenu(commands);
            _ctx.viewObjects.addObject(commandMenu, _ctx.uiLayer);
            _regs.addSignalListener(commandMenu.actionSelected, function (action :VillagerAction) :void {
                if (_selectedVillager == villager.ref) {
                    _ctx.messages.doVillagerAction(villager, action);
                    // hide the selected text
                    villager.textSprite.deselect();
                }
                commandMenu.destroySelf();
            });
            
            _regs.addOneShotSignalListener(_ctx.selector.canceled, function () :void {
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
        if (_hearts < GameDesc.MAX_HEARTS) {
            _hearts++;
            _heartView.addHeart();
        }
    }
    
    public function worship (villager :Villager) :void {
        offsetDefense(GameDesc.worshipDefenseOffset);
    }
    
    protected function getCommandText (villager :Villager, action :VillagerAction) :String {
        return GameDesc.commandText(villager.name, action, this.normalizedAffinity);
    }
    
    protected function getCommandLoc (action :VillagerAction) :Vector2 {
        switch (action) {
        case VillagerAction.FESTIVAL: return _desc.festivalCommandLoc;
        case VillagerAction.SACRIFICE: return _desc.sacrificeCommandLoc;
        case VillagerAction.WORSHIP: return _desc.worshipCommandLoc;
        }
        return new Vector2();
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

        _templeView = new TempleView(_desc.color);
        _templeView.display.x = _desc.templeLoc.x;
        _templeView.display.y = _desc.templeLoc.y;
        _ctx.viewObjects.addObject(_templeView, _ctx.board.view.objectLayer);

        _festivalView = new FestivalView();
        _festivalView.display.x = _desc.festivalLoc.x;
        _festivalView.display.y = _desc.festivalLoc.y;
        _ctx.viewObjects.addObject(_festivalView, _ctx.board.view.objectLayer);

        _heartView = new HeartView(isLocalPlayer, !desc.displayedOnRight);
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
