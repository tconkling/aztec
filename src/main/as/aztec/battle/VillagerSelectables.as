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

        trace("ADDDDINNGGG");
        _ctx.selector.addProvider(this);
    }

    override protected function removedFromMode () :void {
        super.removedFromMode();

        _ctx.selector.removeProvider(this);
    }
}
}
