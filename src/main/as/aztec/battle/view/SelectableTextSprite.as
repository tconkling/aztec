//
// aztec

package aztec.battle.view {

import aspire.util.Preconditions;

import aztec.Aztec;
import aztec.text.CustomTextField;

import starling.display.Sprite;
import starling.text.TextFieldAutoSize;

public class SelectableTextSprite extends Sprite
{
    public function SelectableTextSprite (text :String, size :Number = 24) {
        _text = text;
        
        _tf = new CustomTextField(1, 1, text, Aztec.UI_FONT, size);
        _tf.color = 0xffffff;
        _tf.selectionColor = 0x00ff00;
        _tf.autoSize = TextFieldAutoSize.SINGLE_LINE;
        addChild(_tf);
        
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
        
        _tf.selectionColor = color;
        _tf.selectionLength = numCharacters;
    }
    
    protected var _text :String;
    protected var _tf :CustomTextField;
}
}
