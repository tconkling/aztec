//
// aztec

package aztec.battle {

import aspire.ui.KeyboardCodes;

import aztec.input.KeyboardListener;

import org.osflash.signals.Signal;

import starling.events.KeyboardEvent;

public class TextSelector
    implements KeyboardListener
{
    public const canceled :Signal = new Signal();
    public const selected :Signal = new Signal(Selectable);
    
    public function TextSelector (selectionColor :uint) {
        _selectionColor = selectionColor;
    }
    
    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }
        
        if (_curSelectable != null && !isValidSelectable(_curSelectable)) {
            _curSelectable = null;
        }
        
        if (e.keyCode == KeyboardCodes.ESCAPE && _curSelectable != null) {
            // escape deselects the actor
            endCurSelection();
            return true;
            
        } else if (e.keyCode == KeyboardCodes.ENTER &&
            _curSelectable != null &&
            _selectionLength >= this.curText.length) {
            
            // return/enter sends the "select actor" message over the network
            var selectable :Selectable = _curSelectable;
            _curSelectable = null;
            this.selected.dispatch(selectable);
            return true;
        }
        
        var typedLetter :String = String.fromCharCode(e.charCode).toLowerCase();
        
        if (_curSelectable == null) {
            // try to select a new selectable
            for each (var potential :Selectable in getSelectables()) {
                if (typedLetter == getLetter(potential, 0) && isValidSelectable(potential)) {
                    // we found one!
                    beginSelection(potential);
                    break;
                }
            }
        }
        
        if (_curSelectable != null && _selectionLength < this.curText.length) {
            var nextLetter :String = this.getLetter(_curSelectable, _selectionLength);
            if (nextLetter == typedLetter) {
                _selectionLength++;
                _curSelectable.selectableTextSprite.select(_selectionLength, _selectionColor);
            }
        }
        
        return true;
    }
    
    protected function get curText () :String {
        return _curSelectable.selectableTextSprite.text;
    }
    
    protected function getLetter (s :Selectable, idx :int) :String {
        return s.selectableTextSprite.text.substr(idx, 1).toLowerCase();
    }
    
    protected function beginSelection (s :Selectable) :void {
        endCurSelection();
        _curSelectable = s;
        _selectionLength = 0;
        onSelectionBegan(_curSelectable);
    }
    
    protected function endCurSelection () :void {
        if (_curSelectable != null) {
            if (isValidSelectable(_curSelectable)) {
                _curSelectable.selectableTextSprite.deselect();
            }
            var old :Selectable = _curSelectable;
            _curSelectable = null;
            onSelectionCanceled(old);
        }
    }
    
    protected function getSelectables () :Array {
        throw new Error("abstract");
    }
    
    protected function isValidSelectable (s :Selectable) :Boolean {
        throw new Error("abstract");
    }
    
    protected function onSelectionBegan (s :Selectable) :void {
    }
    
    protected function onSelectionCanceled (s :Selectable) :void {
    }
    
    protected var _curSelectable :Selectable;
    protected var _selectionLength :int;
    protected var _selectionColor :uint;
}
}
