//
// aztec

package aztec.battle {

import aspire.util.Registration;

import aztec.battle.controller.Villager;

public class ActorSelector extends LocalObject
{
    override public function get objectNames () :Array {
        return [ ActorSelector ].concat(super.objectNames);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        _textSelector = new ActorTextSelector(_ctx);
        _regs.add(_ctx.keyboardInput.registerListener(_textSelector));
        _regs.addSignalListener(_textSelector.selected, function (v :Villager) :void {
            _ctx.messages.selectVillager(v);
        });
    }
    
    protected var _textSelector :TextSelector;
    protected var _actorSelectedReg :Registration;
}
}

import aztec.battle.BattleCtx;
import aztec.battle.Selectable;
import aztec.battle.TextSelector;
import aztec.battle.controller.Villager;

class ActorTextSelector extends TextSelector {
    public function ActorTextSelector (ctx :BattleCtx) {
        super(ctx.localPlayer.desc.color);
        _ctx = ctx;
    }
    
    override protected function getSelectables () :Array {
        return Villager.getAll(_ctx);
    }
    
    override protected function isValidSelectable (s :Selectable) :Boolean {
        var villager :Villager = Villager(s);
        return (villager.isLiveObject && !villager.isSelected);
    }
    
    protected var _ctx :BattleCtx;
}
