//
// aztec

package aztec.battle.controller {

import aspire.geom.Vector2;
import aspire.util.MathUtil;
import aspire.util.Set;
import aspire.util.Sets;

import aztec.battle.BattleCtx;
import aztec.battle.God;
import aztec.battle.VillagerAction;
import aztec.battle.VillagerCommand;
import aztec.battle.desc.GameDesc;
import aztec.battle.desc.PlayerDesc;
import aztec.battle.view.FestivalView;
import aztec.battle.view.HeartView;
import aztec.battle.view.ResourceIcon;
import aztec.battle.view.TempleView;
import aztec.battle.view.VillagerAlert;
import aztec.battle.view.VillagerCommandMenu;

import flashbang.core.GameObjectRef;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;

import react.Registration;

public class Player extends NetObject
{
    public static function withId (ctx :BattleCtx, oid :int) :Player {
        return Player(ctx.netObjects.getObjectWithId(nameForId(oid)));
    }

    public static function getAll(ctx:BattleCtx) :Array {

        return ctx.netObjects.getObjectsInGroup(Player);
    }

    public function Player (id :int, name :String, desc :PlayerDesc, localPlayer :Boolean) {
        _id = id;
        _name = name;
        _desc = desc;
        _localPlayer = localPlayer;

        _villagerAffinity = GameDesc.initialAffinity;
        _templeDefense = GameDesc.initialDefense;
    }

    public function get name () :String { return _name; }
    public function get id () :int { return _id; }
    public function get desc () :PlayerDesc { return _desc; }

    public function get affinity () :Number {
        return _villagerAffinity;
    }

    public function offsetAffinity (offset :Number) :void {
        _villagerAffinity = MathUtil.clamp(_villagerAffinity + offset, 0, 1);
    }

    override public function get ids () :Array {
        return [ nameForId(id) ].concat(super.ids);
    }

    override public function get groups () :Array {
        return [ Player ].concat(super.groups);
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
        villager.selected.emit();
        villager.view.textView.select(villager.name.length, _desc.darkColor);

        if (this.isLocalPlayer) {
            // show the command menu
            var usedGreetingLetters :Set = Sets.newSetOf(String);

            var commands :Array = VillagerAction.values().filter(
                function (action :VillagerAction, ..._) :Boolean {
                    return action != VillagerAction.DEFAULT;
                }).map(
                function (action :VillagerAction, ..._) :VillagerCommand {
                    var text :String = _ctx.commandGenerator.getCommandText(
                        action,  villager, affinity, usedGreetingLetters);
                    usedGreetingLetters.add(text.substr(0, 1).toLowerCase());
                    return new VillagerCommand(action, text, getCommandLoc(action));
                });

            var commandMenu :VillagerCommandMenu = new VillagerCommandMenu(commands);
            _ctx.viewObjects.addObject(commandMenu, _ctx.uiLayer);
            this.regs.add(commandMenu.actionSelected.connect(function (action :VillagerAction) :void {
                if (_selectedVillager == villager.ref) {
                    _ctx.messages.doVillagerAction(villager, action);
                    // hide the selected text
                    villager.textSprite.deselect();
                }
                commandMenu.destroySelf();
            }));

            // close the menu if the villager is destroyed
            var villagerDestroyedConn :Registration =
                this.regs.add(villager.destroyed.connect(commandMenu.destroySelf));

            this.regs.add(_ctx.selector.canceled.connect(function () :void {
                if (_selectedVillager == villager.ref) {
                    _ctx.messages.deselectVillager(villager);
                }
            }).once());

            this.regs.add(commandMenu.destroyed.connect(function () :void {
                villagerDestroyedConn.close();
            }).once());
        }
    }

    public function deselectVillager () :void {
        var selected :Villager = this.selectedVillager;
        if (selected != null) {
            _selectedVillager = GameObjectRef.Null();
            selected.view.textView.deselect();
            selected.deselected.emit();
        }
    }

    public function handleSummon (god :God, summoner :Player) :void {
        if (this == summoner) {
            var heartsUsed :int = GameDesc.godHearts(god);
            _hearts -= heartsUsed;
            _heartView.hearts = _hearts;
            _templeView.summonGod(god);

        } else {
            var self :Player = this;
            addObject(new SerialTask(
                new TimedTask(2),
                new FunctionTask(function () :void {
                    var damage :Number = GameDesc.godDamage(god);
                    var absorbedByDefense :Number =
                        Math.min(damage * GameDesc.DEFENSE_STRENGTH, _templeDefense);
                    damage -= absorbedByDefense;

                    offsetDefense(-absorbedByDefense);
                    offsetHealth(-damage);

                    if (GameDesc.summonDestroysOpponentVillagers) {
                        var deadVillagers :Array = Villager.getAll(_ctx).filter(
                            function (v :Villager, ..._) :Boolean {
                                return v.performingActionFor == self;
                            });

                        if (deadVillagers.length > 0) {
                            VillagerAlert.show(_ctx, VillagerAlert.KILLED_BY_SUMMON, self,
                                deadVillagers);

                            for each (var villager :Villager in deadVillagers) {
                                villager.destroySelf();
                            }
                        }
                    }
                })));
        }
    }

    public function canSummon (god :God) :Boolean {
        return (_hearts >= GameDesc.godHearts(god));
    }

    public function handleVillagerAction (villager :Villager, action :VillagerAction) :void {
        switch (action) {
        case VillagerAction.SACRIFICE:
            if (_hearts < GameDesc.MAX_HEARTS) {
                _hearts++;
                _heartView.hearts = _hearts;
            }
            offsetAffinity(GameDesc.sacrificeAffinityOffset);
            if (_templeView.viewState == TempleView.NORMAL) {
                _templeView.viewState = TempleView.BLOODY;
            }

            if (this.isLocalPlayer) {
                for each (var v :Villager in Villager.getAll(_ctx)) {
                    v.view.showResourceIcon(ResourceIcon.ANGRY);
                }
            }
            break;
        }
    }

    public function offsetDefense (offset :Number) :void {
        _templeDefense = MathUtil.clamp(_templeDefense + offset, 0, 1);
        _templeView.updateDefense(_templeDefense);
    }

    protected function getCommandLoc (action :VillagerAction) :Vector2 {
        switch (action) {
        case VillagerAction.FESTIVAL: return _desc.festivalCommandLoc;
        case VillagerAction.SACRIFICE: return _desc.sacrificeCommandLoc;
        case VillagerAction.WORSHIP: return _desc.worshipCommandLoc;
        }
        return new Vector2();
    }

    protected function offsetHealth (offset :Number) :void {
        _templeHealth = MathUtil.clamp(_templeHealth + offset, 0, 1);
        if (_templeHealth <= 0 && _ctx.localPlayer != this) {
            _ctx.messages.win();
        }
        _templeView.updateHealth(_templeHealth);
        if (_templeHealth <= 0.25) {
            _templeView.viewState = TempleView.BROKEN;
        }
    }

    override protected function added () :void {
        super.added();

        _templeView = new TempleView(_name, _desc.color, desc.displayedOnRight);
        _templeView.display.x = _desc.templeLoc.x;
        _templeView.display.y = _desc.templeLoc.y;
        _ctx.viewObjects.addObject(_templeView, _ctx.board.view.objectLayer);

        _templeView.updateDefense(_templeDefense);
        _templeView.updateHealth(_templeHealth);

        _festivalView = new FestivalView();
        _festivalView.display.x = _desc.festivalLoc.x;
        _festivalView.display.y = _desc.festivalLoc.y;
        _ctx.viewObjects.addObject(_festivalView, _ctx.board.view.objectLayer);

        _heartView = new HeartView(isLocalPlayer, !desc.displayedOnRight);
        _heartView.sprite.x = desc.heartLoc.x;
        _heartView.sprite.y = desc.heartLoc.y;
        _ctx.viewObjects.addObject(_heartView, _ctx.uiLayer);
    }

    protected static function nameForId (oid :int) :String {
        return "Player_" + oid;
    }

    protected var _id :int;
    protected var _name :String;
    protected var _desc :PlayerDesc;
    protected var _localPlayer :Boolean;

    protected var _templeHealth :Number = 1;
    protected var _templeDefense :Number = 0;
    protected var _hearts :int = 0;
    protected var _villagerAffinity :Number = 1;

    protected var _selectedVillager :GameObjectRef = GameObjectRef.Null();

    protected var _templeView :TempleView;
    protected var _festivalView :FestivalView;
    protected var _heartView :HeartView;
}
}
