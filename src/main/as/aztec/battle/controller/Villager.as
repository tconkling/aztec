//
// aztec

package aztec.battle.controller {

import aspire.util.Log;

import aztec.battle.BattleCtx;
import aztec.battle.Selectable;
import aztec.battle.VillagerAction;
import aztec.battle.desc.GameDesc;
import aztec.battle.view.SelectableTextSprite;
import aztec.battle.view.VillagerAlert;
import aztec.battle.view.VillagerView;

import flashbang.tasks.FunctionTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;

import org.osflash.signals.Signal;

public class Villager extends NetObject
    implements Selectable
{
    public const selected :Signal = new Signal();
    public const deselected :Signal = new Signal();

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

    public function get isSelectable() :Boolean {
        return this.isLiveObject && !this.isSelected;
    }

    public function get name () :String {
        return _name;
    }

    public function get textSprite () :SelectableTextSprite {
        return _view.textView;
    }

    public function markSelected () :void {
        _ctx.messages.selectVillager(this, _ctx.localPlayer.oid);
    }

    public function get isSelected () :Boolean {
        for each (var player :Player in _ctx.players) {
            if (player.selectedVillager == this) {
                return true;
            }
        }
        return false;
    }

    public function get performingActionFor () :Player {
        return _performingActionFor;
    }

    public function performAction (action :VillagerAction, forPlayer :Player) :void {
        var wasPerformingFor :Player = _performingActionFor;

        endCurAction();

        _curAction = action;
        _performingActionFor = forPlayer;
        _view.showActionAnim(action, forPlayer);

        // If the villager was stolen away from the local player, show an alert
        if (action != VillagerAction.DEFAULT &&
            wasPerformingFor != null &&
            wasPerformingFor != forPlayer &&
            wasPerformingFor.isLocalPlayer) {

            VillagerAlert.show(_ctx, VillagerAlert.typeForAction(action), forPlayer, [ this ]);
        }

        if (action == VillagerAction.SACRIFICE) {
            destroySelf();
        } else {
            addNamedTask(PERFORM_ACTION_TASK, new SerialTask(
                new TimedTask(_curAction.duration),
                new FunctionTask(endCurAction)));
        }
    }

    protected function endCurAction () :void {
        if (_curAction != null) {
            _curAction = null;
            _performingActionFor = null;
            removeNamedTasks(PERFORM_ACTION_TASK);

            _view.showActionAnim(VillagerAction.DEFAULT, null);
        }
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

    override protected function update (dt :Number) :void {
        super.update(dt);
        if (_curAction == VillagerAction.FESTIVAL) {
            _performingActionFor.offsetAffinity(GameDesc.festivalAffinityPerSecond * dt);
        } else if (_curAction == VillagerAction.WORSHIP) {
            _performingActionFor.offsetDefense(GameDesc.worshipDefensePerSecond * dt);
        }
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

    protected var _curAction :VillagerAction;
    protected var _performingActionFor :Player;

    protected static const log :Log = Log.getLog(Villager);

    protected static const PERFORM_ACTION_TASK :String = "PerformAction";
}
}
