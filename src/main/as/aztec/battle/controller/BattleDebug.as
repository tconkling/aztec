package aztec.battle.controller {
import aztec.battle.LocalObject;
import aztec.battle.view.DebugView;
import aztec.data.SacrificeMessage;

public class BattleDebug extends LocalObject {
    public function BattleDebug() {
    }

    override protected function addedToMode () :void {
        super.addedToMode();

        for each (var player :Player in Player.getAll(_ctx)) {
            var view :DebugView = new DebugView(this, player.oid);
            if (!player.desc.player1) {
                view.sprite.x = 960;
            }
            _ctx.viewObjects.addObject(view, _ctx.uiLayer);
        }
    }

    public function sacrifice(senderOid :int):void {
        _ctx.messages.sacrifice(senderOid, Villager.getAll(_ctx)[0]);
    }

    public function summon(senderOid :int):void {
        _ctx.messages.summon(senderOid);
    }

}
}
