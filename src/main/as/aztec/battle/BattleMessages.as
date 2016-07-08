//
// aztec

package aztec.battle {

import aspire.util.Log;

import aztec.Aztec;
import aztec.NewGameCondition;
import aztec.battle.controller.Player;
import aztec.battle.controller.Villager;
import aztec.data.AztecMessage;
import aztec.data.DeselectVillagerMessage;
import aztec.data.IWonMessage;
import aztec.data.PlayerDisconnectedMessage;
import aztec.data.SelectVillagerMessage;
import aztec.data.SummonMessage;
import aztec.data.VillagerActionMessage;
import aztec.net.MessageMgr;

import flashbang.core.Flashbang;

public class BattleMessages
{
    public function BattleMessages (ctx :BattleCtx, mgr :MessageMgr) {
        _ctx = ctx;
        _mgr = mgr;
    }

    public function win (senderOid :int = 0) :void {
        _mgr.sendMessage(defaultToLocal(senderOid), new IWonMessage());
    }

    public function summon (god :God, senderOid :int = 0) :void {
        var msg :SummonMessage = new SummonMessage();
        msg.godName = god.name();
        _mgr.sendMessage(defaultToLocal(senderOid), msg);
    }

    public function selectVillager (villager :Villager, senderOid :int = 0) :void {
        var msg :SelectVillagerMessage = new SelectVillagerMessage();
        msg.villagerName = villager.name;
        _mgr.sendMessage(defaultToLocal(senderOid), msg);
    }

    public function deselectVillager (villager :Villager, senderOid :int = 0) :void {
        var msg :DeselectVillagerMessage = new DeselectVillagerMessage();
        msg.villagerName = villager.name;
        _mgr.sendMessage(defaultToLocal(senderOid), msg);
    }

    public function doVillagerAction (villager :Villager, action :VillagerAction,
        senderOid :int = 0) :void {
        var msg :VillagerActionMessage = new VillagerActionMessage();
        msg.villagerName = villager.name;
        msg.action = action.name();
        _mgr.sendMessage(defaultToLocal(senderOid), msg);
    }

    public function processTicks (dt :Number) :void {
        _mgr.update(dt);

        // update the network
        for each (var ticks :Vector.<AztecMessage> in _mgr.ticks) {
            for each (var msg :AztecMessage in ticks) {
                handleMessage(msg);
            }
            _ctx.netObjects.doUpdate(Aztec.NETWORK_UPDATE_RATE);
        }
    }

    protected function defaultToLocal (oid :int) :int {
        return (oid != 0 ? oid : _ctx.localPlayer.id);
    }

    protected function handleMessage (msg :AztecMessage) :void {
        var sender :Player = Player.withId(_ctx, msg.senderId);
        if (sender == null) {
            log.warning("Message with unrecognized sender oid", "msg", msg);
            return;
        }

        if (msg is SelectVillagerMessage) {
            handleSelectVillager(sender, SelectVillagerMessage(msg));

        } else if (msg is DeselectVillagerMessage) {
            handleDeselectVillager(sender, DeselectVillagerMessage(msg));

        } else if (msg is VillagerActionMessage) {
            handleVillagerAction(sender, VillagerActionMessage(msg));

        } else if (msg is SummonMessage) {
            handleSummon(sender, SummonMessage(msg));
        } else if (msg is IWonMessage) {
            if (sender == _ctx.localPlayer) {
                Aztec.newGameCondition = NewGameCondition.WON;
            } else {
                Aztec.newGameCondition = NewGameCondition.LOST;
            }
            Flashbang.app.modeStack.popMode();
        } else if (msg is PlayerDisconnectedMessage) {
            log.info("Opponent disconnected! Ending game.");
            Aztec.newGameCondition = NewGameCondition.OPPONENT_DISCONNECTED;
            Flashbang.app.modeStack.popMode();
        } else {
            log.error("Unhandled message!", "msg", msg);
        }
    }

    protected function handleSelectVillager (sender :Player, msg :SelectVillagerMessage) :void {
        var villager :Villager = Villager.withName(_ctx, msg.villagerName);
        if (villager == null) {
            log.warning("SelectVillager: no such villager", "name", msg.villagerName);
        } else if (villager.isSelected) {
            log.warning("SelectVillager: villager is already selected!", "msg", msg);
        } else {
            sender.selectVillager(villager);
        }
    }

    protected function handleDeselectVillager (sender :Player, msg :DeselectVillagerMessage) :void {
        var villager :Villager = Villager.withName(_ctx, msg.villagerName);
        if (villager == null) {
            log.warning("DeselectVillager: no such villager", "name", msg.villagerName);
        } else if (sender.selectedVillager != villager) {
            log.warning("DeselectVillager: villager not selected by this player", "msg", msg);
        } else {
            sender.deselectVillager();
        }
    }

    protected function handleVillagerAction (sender :Player, msg :VillagerActionMessage) :void {
        var action :VillagerAction;
        try {
            action = VillagerAction.valueOf(msg.action);
        } catch (e :Error) {
            log.warning("handleVillagerAction: unrecognized action", "actionName", msg.action);
            return;
        }

        var villager :Villager = Villager.withName(_ctx, msg.villagerName);
        if (villager == null) {
            log.warning("handleVillagerAction: no such villager", "name", msg.villagerName);
        } else if (sender.selectedVillager != villager) {
            log.warning("handleVillagerAction: villager not selected by this player", "msg", msg);
        } else {
            // performing an action deselects the villager
            sender.deselectVillager();
            sender.handleVillagerAction(villager, action);
            villager.performAction(action, sender);
        }
    }

    protected function handleSummon (sender :Player, msg :SummonMessage) :void {
        var god :God;
        try {
            god = God.valueOf(msg.godName);
        } catch (e :Error) {
            log.error("unrecognized god name: " + msg.godName);
        }

        if (!sender.canSummon(god)) {
            log.warning("handleSummon: player can't summon god", "player", sender, "god", god);
            return;
        }

        for each (var player :Player in _ctx.netObjects.getObjectsInGroup(Player)) {
            player.handleSummon(god, sender);
        }
    }

    protected var _ctx :BattleCtx;
    protected var _mgr :MessageMgr;

    protected static const log :Log = Log.getLog(BattleMessages);
}
}
