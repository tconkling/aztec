//
// aztec

package aztec.battle {

import aspire.util.Log;

import aztec.Aztec;
import aztec.battle.controller.Player;
import aztec.battle.controller.Villager;
import aztec.data.AztecMessage;
import aztec.data.DeselectVillagerMessage;
import aztec.data.SacrificeMessage;
import aztec.data.SelectVillagerMessage;
import aztec.data.SummonMessage;
import aztec.net.MessageMgr;

public class BattleMessages
{
    public function BattleMessages (ctx :BattleCtx, mgr :MessageMgr) {
        _ctx = ctx;
        _mgr = mgr;
    }

    public function sacrifice (villager :Villager, senderOid :int = 0) :void {
        var msg :SacrificeMessage = new SacrificeMessage(villager.name);
        _mgr.sendMessage(defaultToLocal(senderOid), msg);
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
            
        } else if (msg is SacrificeMessage) {
            handleSacrifice(SacrificeMessage(msg));
            
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

    protected function handleSacrifice (msg :SacrificeMessage) :void  {
        for each (var player :Player in _ctx.netObjects.getObjectsInGroup(Player)) {
            player.sacrifice(msg);
        }
        Villager.withName(_ctx, msg.villager).sacrifice();
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
