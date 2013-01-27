//
// aztec

package aztec.battle {

import aspire.util.Log;

import aztec.Aztec;
import aztec.battle.controller.Player;
import aztec.battle.controller.Villager;
import aztec.data.AztecMessage;
import aztec.data.SacrificeMessage;
import aztec.data.SacrificeMessage;
import aztec.data.SelectVillagerMessage;
import aztec.net.MessageMgr;

public class BattleMessages
{
    public function BattleMessages (ctx :BattleCtx, mgr :MessageMgr) {
        _ctx = ctx;
        _mgr = mgr;
    }

    public function sacrifice (villager :Villager) :void {
        var msg :SacrificeMessage = new SacrificeMessage(villager.name);
        msg.senderOid = 1;
        _mgr.sendMessage(msg);
    }
    
    public function selectVillager (villager :Villager) :void {
        var msg :SelectVillagerMessage = new SelectVillagerMessage();
        msg.villagerName = villager.name;
        _mgr.sendMessage(msg);
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
    
    protected function handleMessage (msg :AztecMessage) :void {
        var sender :Player = Player.withOid(_ctx, msg.senderOid);
        if (sender == null) {
            log.warning("Message with unrecognized sender oid", "msg", msg);
            return;
        }
        
        if (msg is SelectVillagerMessage) {
            var villagerName :String = SelectVillagerMessage(msg).villagerName;
            var villager :Villager = Villager.withName(_ctx, villagerName);
            if (villager == null) {
                log.warning("SelectVillager: no such villager", "name", villagerName);
            } else {
                villager.select(sender);
            }
        } else if (msg is SacrificeMessage) {
            handleSacrifice(SacrificeMessage(msg));
        } else {
            log.error("Unhandled message!", "msg", msg);
        }
    }

    protected function handleSacrifice (msg :SacrificeMessage) :void  {
        for each (var player :Player in _ctx.netObjects.getObjectsInGroup(Player)) {
            player.sacrifice(msg);
        }
        Villager.withName(_ctx, msg.villager).sacrifice();
    }
    protected var _ctx :BattleCtx;
    protected var _mgr :MessageMgr;
    
    protected static const log :Log = Log.getLog(BattleMessages);
}
}
