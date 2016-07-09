//
// aztec

package aztec.battle.view {

import aspire.util.Preconditions;

import aztec.Aztec;

import flashbang.util.TextFieldBuilder;

import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;

public class SelectableTextSprite extends Sprite
{
    public function SelectableTextSprite (text :String, font :String = null, size :Number = 24,
        autoSize :String = TextFieldAutoSize.HORIZONTAL, maxWidth :Number = 0) {

        font = (font || Aztec.UI_FONT);

        _tf = new TextFieldBuilder(text)
            .color(0xffffff)
            .font(font)
            .fontSize(size)
            .autoSize(autoSize)
            .width(maxWidth)
            .build();
        addChild(_tf);

        touchable = false;

        deselect();
    }

    public function get centered () :Boolean {
        return _centered;
    }

    public function set centered (val :Boolean) :void {
        if (_centered != val) {
            _centered = val;
            updateAlignment();
        }
    }

    public function get selectionLength () :uint {
        return _selectionLength;
    }

    public function get text () :String {
        return _tf.text;
    }

    public function set text (val :String) :void {
        if (_tf.text != val) {
            _tf.text = val;
            updateAlignment();
        }
    }

    public function deselect () :void {
        select(0, 0);
    }

    public function select (numCharacters :uint, color :uint) :void {
        Preconditions.checkArgument(numCharacters <= _tf.text.length);

        _selectionLength = numCharacters;
//        _tf.selectionColor = color;
//        _tf.selectionLength = numCharacters;
    }

    protected function updateAlignment () :void {
        _tf.x = (_centered ? -_tf.width * 0.5 : 0);
        _tf.y = (_centered ? -_tf.height * 0.5 : 0);
    }

    protected var _selectionLength :int;
    protected var _tf :TextField;
    protected var _centered :Boolean;
}
}
