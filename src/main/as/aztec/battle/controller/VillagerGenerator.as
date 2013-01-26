//
// aztec

package aztec.battle.controller {
import aztec.battle.desc.GameDesc;

public class VillagerGenerator extends NetObject
{
    override protected function update (dt :Number) :void {
        var needed :int = GameDesc.numVillagers - Villager.getCount(_ctx);
        for (var ii :int = 0; ii < needed; ++ii) {
            generate();
        }
    }
    
    protected function generate () :void {
        _ctx.netObjects.addObject(new Villager());
    }
}
}
