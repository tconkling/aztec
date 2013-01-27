//
// aztec

package aztec.battle.view {

import aspire.util.Preconditions;

import aztec.text.CustomTextField;

import starling.display.Sprite;

public class SelectableTextSprite extends Sprite
{
    public function SelectableTextSprite (text :String, font = "futura", size :Number = 24,
        autoSize :String = "singleLine", maxWidth :Number = 0) {
        
        _tf = new CustomTextField(1, 1, text, font, size);
        _tf.color = 0xffffff;
        _tf.selectionColor = 0x00ff00;
        _tf.autoSize = autoSize;
        _tf.autoSizeMaxWidth = maxWidth;
        addChild(_tf);
        
        touchable = false;
        
        deselect();
    }
    
    public function get text () :String {
        return _tf.text;
    }
    
    public function set text (val :String) :void {
        _tf.text = val;
    }
    
    public function deselect () :void {
        select(0, 0);
    }
    
    public function select (numCharacters :uint, color :uint) :void {
        Preconditions.checkArgument(numCharacters <= _tf.text.length);
        
        _tf.selectionColor = color;
        _tf.selectionLength = numCharacters;
    }
    
    protected var _tf :CustomTextField;
}
}
