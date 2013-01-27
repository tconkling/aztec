//
// aztec

package aztec.battle.controller {

import aztec.battle.God;
import aztec.battle.LocalObject;
import aztec.battle.VillagerAction;
import aztec.battle.view.DebugView;

public class BattleDebug extends LocalObject {
    override protected function addedToMode () :void {
        super.addedToMode();

        for each (var player :Player in Player.getAll(_ctx)) {
            var view :DebugView = new DebugView(this, player.oid);
            if (!player.isLocalPlayer) {
                view.sprite.x = 960;
            }
            _ctx.viewObjects.addObject(view, _ctx.uiLayer);
        }
    }

    public function sacrifice(senderOid :int):void {
        _ctx.messages.selectVillager(Villager.getAll(_ctx)[0], senderOid);
        _ctx.messages.doVillagerAction(Villager.getAll(_ctx)[0], VillagerAction.SACRIFICE, senderOid);
    }

    public function summon (senderOid :int):void {
        _ctx.messages.summon(God.HUITZ, senderOid);
    }

    public function win (senderOid :int):void {
        _ctx.messages.win(senderOid);
    }
}
}
