//
// aztec

package aztec.battle {

import aspire.ui.KeyboardCodes;
import aspire.util.Arrays;
import aspire.util.Registration;
import aspire.util.Registrations;

import aztec.input.KeyboardListener;

import org.osflash.signals.Signal;

import starling.events.KeyboardEvent;

public class TextSelector extends LocalObject
    implements KeyboardListener
{
    public const canceled :Signal = new Signal();
    public const selectionBegan :Signal = new Signal(Selectable);
    public const selectionCanceled :Signal = new Signal(Selectable);
    
    public var selectionColor :uint;

    public function registerProvider (provider :SelectableProvider) :Registration {
        _providers.push(provider);
        return Registrations.createWithFunction(function () :void {
            Arrays.removeAll(_providers, provider);
        });
    }

    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }
        
        if (_curSelectable != null && !_curSelectable.isSelectable) {
            _curSelectable = null;
        }
        
        if (e.keyCode == KeyboardCodes.ESCAPE || e.keyCode == KeyboardCodes.BACKSPACE) {
            // if we have an actor selected, escape deselects.
            // else, escape "cancels" the text selection
            if (_curSelectable != null) {
                endCurSelection();
            } else {
                this.canceled.dispatch();
            }
            
            return true;
            
        } else if (e.keyCode == KeyboardCodes.SPACE) {
            // ignore spaces
            return true;
        }
        
        var typedLetter :String = String.fromCharCode(e.charCode).toLowerCase();
        
        if (_curSelectable == null) {
            // try to select a new selectable
            for each (var potential :Selectable in getSelectables()) {
                if (typedLetter == getLetter(potential, 0) && potential.isSelectable) {
                    // we found one!
                    beginSelection(potential);
                    break;
                }
            }
        }

        if (_curSelectable != null && _selectionLength < this.curText.length) {
            var nextLetter :String = getLetter(_curSelectable, _selectionLength);
            if (nextLetter == typedLetter) {
                _selectionLength++;
                // eat spaces
                while (_selectionLength < this.curText.length && getLetter(_curSelectable, _selectionLength) == " ") {
                    _selectionLength++;
                }
                _curSelectable.textSprite.select(_selectionLength, selectionColor);

                if (_selectionLength >= this.curText.length) {

                    // return/enter sends the "select actor" message over the network
                    var selectable :Selectable = _curSelectable;
                    _curSelectable = null;
                    selectable.markSelected();
                }
            }
        }
        
        return true;
    }

    override protected function addedToMode() :void {
        super.addedToMode();
        _regs.add(_ctx.keyboardInput.registerListener(this));
    }
    
    protected function get curText () :String {
        return _curSelectable.textSprite.text;
    }
    
    protected function getLetter (s :Selectable, idx :int) :String {
        return s.textSprite.text.substr(idx, 1).toLowerCase();
    }
    
    protected function beginSelection (s :Selectable) :void {
        endCurSelection();
        _curSelectable = s;
        _selectionLength = 0;
        this.selectionBegan.dispatch(_curSelectable);
    }
    
    protected function endCurSelection () :void {
        if (_curSelectable != null) {
            if (_curSelectable.isSelectable) {
                _curSelectable.textSprite.deselect();
            }
            var old :Selectable = _curSelectable;
            _curSelectable = null;
            this.selectionCanceled.dispatch(old);
        }
    }
    
    protected function getSelectables () :Array {
        var activeProviders :Array = [];
        var exclusiveActive :Boolean = false;
        for each (var provider :SelectableProvider in _providers) {
            if (provider.isExclusive) {
                if (exclusiveActive) {
                    trace("More than one exclusive provider? Going with the latest one, "  + provider);
                }
                exclusiveActive = true;
                activeProviders = [provider];
            } else if (!exclusiveActive) {
                activeProviders.push(provider);
            }
        }
        var activeSelectables :Array = [];
        for each (provider in activeProviders) {
            activeSelectables = activeSelectables.concat(provider.selectables);
        }
        return activeSelectables;
    }

    protected var _providers :Array = [];
    protected var _curSelectable :Selectable;
    protected var _selectionLength :int;
}
}
