//
// aztec

package aztec.battle {

import aspire.ui.KeyboardCodes;

import aztec.battle.controller.Villager;
import aztec.input.KeyboardListener;

import flashbang.core.GameObjectRef;

import starling.events.KeyboardEvent;

public class ActorSelector extends LocalObject
    implements KeyboardListener
{
    override public function get objectNames () :Array {
        return [ NAME ].concat(super.objectNames);
    }
    
    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }
        
        var curActor :Villager = this.curActor;
        
        if (e.keyCode == KeyboardCodes.ESCAPE && curActor != null) {
            // escape deselects the actor
            deselectCurActor();
            return true;
            
        } else if (e.keyCode == KeyboardCodes.ENTER &&
            // return/enter sends the "select actor" message over the network
            curActor != null &&
            _selectionLength >= curActor.name.length) {
            _ctx.messages.selectVillager(curActor);
            _actor = GameObjectRef.Null();
            return true;
        }
        
        var typedLetter :String = String.fromCharCode(e.charCode).toLowerCase();
        
        if (curActor == null) {
            // try to select a villager
            for each (var villager :Villager in Villager.getAll(_ctx)) {
                if (villager.firstLetter == typedLetter) {
                    // we found one!
                    selectActor(villager);
                    curActor = villager;
                    break;
                }
            }
        }
        
        
        if (curActor != null && _selectionLength < curActor.name.length) {
            var nextLetter :String = curActor.name.substr(_selectionLength, 1);
            if (nextLetter == typedLetter) {
                _selectionLength++;
                curActor.view.textView.select(_selectionLength);
            }
        }
        
        return true;
    }
    
    protected function selectActor (villager :Villager) :void {
        deselectCurActor();
        _actor = villager.ref;
        _selectionLength = 0;
    }
    
    protected function deselectCurActor () :void {
        var curActor :Villager = this.curActor;
        if (curActor != null) {
            curActor.view.textView.deselect();
            _actor = GameObjectRef.Null();
        }
    }
    
    protected function get curActor () :Villager {
        return Villager(_actor.object);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        _regs.add(_ctx.keyboardInput.registerListener(this));
    }
    
    protected var _actor :GameObjectRef = GameObjectRef.Null();
    protected var _selectionLength :int;
    
    protected static const NAME :String = "NounSelector";
}
}
