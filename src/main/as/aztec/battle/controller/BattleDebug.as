package aztec.battle.controller {
import aztec.battle.LocalObject;
import aztec.battle.view.DebugView;
import aztec.data.SacrificeMessage;

public class BattleDebug extends LocalObject {
    public function BattleDebug() {
    }

    override protected function addedToMode () :void {
        super.addedToMode();

        _view = new DebugView(this);
        _ctx.viewObjects.addObject(_view, _ctx.uiLayer);
    }

    public function sacrifice():void {
        _ctx.messages.sacrifice(Villager.getAll(_ctx)[0]);
    }

    protected var _view :DebugView;

}
}
