//
// aztec

package aztec.battle.view {

import aspire.util.Preconditions;

import aztec.Aztec;

import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;

public class SelectableTextSprite extends Sprite
{
    public function SelectableTextSprite (text :String, size :Number = 24) {
        _text = text;
        
        _tfUnselected = new TextField(1, 1, "", Aztec.UI_FONT, size, 0xffffff);
        _tfUnselected.autoSize = TextFieldAutoSize.SINGLE_LINE;
        
        _tfSelected = new TextField(1, 1, "", Aztec.UI_FONT, size, 0x00ff00);
        _tfSelected.autoSize = TextFieldAutoSize.SINGLE_LINE;
        
        touchable = false;
        
        deselect();
    }
    
    public function get text () :String {
        return _text;
    }
    
    public function deselect () :void {
        select(0, 0);
    }
    
    public function select (numCharacters :uint, color :uint) :void {
        Preconditions.checkArgument(numCharacters <= _text.length);
        
        _tfSelected.color = color;
        
        _tfSelected.removeFromParent();
        _tfUnselected.removeFromParent();
        
        if (numCharacters == 0) {
            _tfUnselected.text = _text;
            _tfUnselected.x = 0;
            addChild(_tfUnselected);
            
        } else if (numCharacters == _text.length) {
            _tfSelected.text = _text;
            _tfSelected.x = 0;
            addChild(_tfSelected);
            
        } else {
            _tfSelected.text = _text.substr(0, numCharacters);
            _tfSelected.x = 0;
            addChild(_tfSelected);
            
            _tfUnselected.text = _text.substr(numCharacters);
            _tfUnselected.x = _tfSelected.width;
            addChild(_tfUnselected);
        }
    }
    
    protected var _text :String;
    protected var _tfUnselected :TextField;
    protected var _tfSelected :TextField;
}
}
