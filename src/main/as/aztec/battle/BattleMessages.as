//
// aztec

package aztec.battle {

import aspire.util.Log;

import aztec.Aztec;
import aztec.battle.controller.Player;
import aztec.battle.controller.Villager;
import aztec.data.AztecMessage;
import aztec.data.DeselectVillagerMessage;
import aztec.data.SelectVillagerMessage;
import aztec.data.SummonMessage;
import aztec.data.VillagerActionMessage;
import aztec.net.MessageMgr;

public class BattleMessages
{
    public function BattleMessages (ctx :BattleCtx, mgr :MessageMgr) {
        _ctx = ctx;
        _mgr = mgr;
    }

    public function summon (senderOid :int = 0) :void {
        var msg :SummonMessage = new SummonMessage();
        msg.power = 2;
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
            _ctx.netObjects.update(Aztec.NETWORK_UPDATE_RATE);
        }
    }
    
    protected function defaultToLocal (oid :int) :int {
        return (oid != 0 ? oid : _ctx.localPlayer.oid);
    }
    
    protected function handleMessage (msg :AztecMessage) :void {
        var sender :Player = Player.withOid(_ctx, msg.senderOid);
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
            
        } else if (msg is SummonMessage ) {
            handleSummon(SummonMessage(msg));
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
            
            switch (action) {
            case VillagerAction.SACRIFICE:
                sender.sacrifice(villager);
                _ctx.affinity.handleSacrifice(sender, villager);
                break;
            
            case VillagerAction.FESTIVAL:
                _ctx.affinity.handleFestival(sender, villager);
                break;
            
            case VillagerAction.WORSHIP:
                sender.worship(villager);
                break;
            
            default:
                log.warning("handleVillagerAction: unhandled action", "action", action);
                break;
            }
            
            // show an animation and remove self
            villager.performAction(action, sender);
        }
    }

    protected function handleSummon (msg :SummonMessage) :void {
        for each (var player :Player in _ctx.netObjects.getObjectsInGroup(Player)) {
            player.summon(msg);
        }
    }

    protected var _ctx :BattleCtx;
    protected var _mgr :MessageMgr;
    
    protected static const log :Log = Log.getLog(BattleMessages);
}
}
