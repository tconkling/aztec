package aztec.battle.controller {

import aspire.util.MathUtil;

import aztec.battle.desc.GameDesc;
import aztec.battle.view.AffinityView;

public class Affinity extends NetObject {
    /** Ranges from -1 for entirely player1 to 1 for entirely player2. */
    public function get affinity() :Number {
        return _affinity;
    }

    public function handleSacrifice (player :Player, villager :Villager) :void {
        adjustAffinity(player.affinitySign * GameDesc.sacrificeAffinityAdjust);
    }
    
    override public function get objectNames () :Array {
        return [ NAME ].concat(super.objectNames);
    }

    protected function adjustAffinity (amount :Number) :void {
        _affinity = MathUtil.clamp(_affinity + amount, -1, 1);
        _view.affinity = _affinity;
    }

    override protected function addedToMode () :void {
        super.addedToMode();

        _ctx.affinity = this;
        _ctx.viewObjects.addObject(_view, _ctx.uiLayer);
    }

    protected var _view :AffinityView = new AffinityView();
    protected var _affinity :Number = 0;
    
    protected static const NAME :String = "Affinity";
}
}
