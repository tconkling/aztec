package aztec.battle.controller {
import aspire.util.MathUtil;

import aztec.battle.view.AffinityView;

import aztec.data.SacrificeMessage;

public class Affinity extends NetObject {
    /** Ranges from -1 for entirely player1 to 1 for entirely player2. */
    public function get affinity() :Number {
        return _affinity;
    }

    public function sacrifice (msg :SacrificeMessage) :void {
        adjustAffinity(Player.withOid(_ctx, msg.senderOid).affinitySign * .2);
    }

    protected function adjustAffinity (amount :Number) :void {
        _affinity = MathUtil.clamp(_affinity + amount, -1, 1);
        _view.affinity = _affinity;
    }

    override protected function addedToMode () :void {
        super.addedToMode();

        _ctx.viewObjects.addObject(_view, _ctx.uiLayer);
    }

    protected var _view :AffinityView = new AffinityView();
    protected var _affinity :Number;
}
}
