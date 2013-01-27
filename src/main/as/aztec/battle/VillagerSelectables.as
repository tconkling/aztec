//
// aztec

package aztec.battle {

import aztec.battle.controller.Villager;

public class VillagerSelectables extends LocalObject implements SelectableProvider
{
    public function get selectables():Array {
        return Villager.getAll(_ctx);
    }

    public function get isExclusive():Boolean {
        return false;
    }

    override protected function addedToMode () :void {
        super.removedFromMode();

        _regs.add(_ctx.selector.registerProvider(this));
    }
}
}
