//
// aztec

package aztec.connect {

import flash.ui.Keyboard;

import flashbang.core.ObjectTask;
import flashbang.input.KeyboardListener;
import flashbang.objects.SpriteObject;
import flashbang.tasks.CallbackTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;
import flashbang.util.TextFieldBuilder;

import react.Signal;
import react.UnitSignal;

import starling.display.DisplayObject;
import starling.events.KeyboardEvent;
import starling.text.TextField;

public class TextEntryField extends SpriteObject implements KeyboardListener {
    public const enterPressed :UnitSignal = new UnitSignal();

    public const textChanged :Signal = new Signal(String);

    public function TextEntryField(width:int, height:int, text:String, fontName:String="Verdana",
                                   fontSize:Number=12, color:uint=0x0, bold:Boolean=false) {

        _tf = new TextFieldBuilder(text)
            .width(width)
            .height(height)
            .font(fontName)
            .fontSize(fontSize)
            .color(color)
            .bold(true)
            .build();
        
        _sprite.addChild(_tf);
        _pipe = DisplayUtil.fillRect(2, _tf.height - 4, color);
        _sprite.addChild(_pipe);

        // force the text to change
        _tf.text = text + " ";
        this.text = text;
    }

    public function get text () :String {
        return _tf.text;
    }

    public function set text (newText :String) :void {
        if (newText == _tf.text) return;
        _tf.text = newText;
        _pipe.x = _tf.x + _tf.textBounds.right;
        textChanged.emit(newText);
    }

    override protected function added() :void {
        super.added();

        this.regs.add(mode.keyboardInput.registerListener(this));
        addObject(new RepeatingTask(function () :ObjectTask {
            return new SerialTask(
                new TimedTask(0.5),
                new CallbackTask(function () :void {
                    _pipe.visible = !_pipe.visible;
                }));
        }));
    }

    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }

        if (e.keyCode == Keyboard.ENTER) {
            enterPressed.emit();
        } else if (e.keyCode == Keyboard.BACKSPACE) {
            this.text = this.text.substring(0, this.text.length - 1);
        } else if (_tf.text.length < 20) {
            var entered :String = String.fromCharCode(e.charCode);
            if (entered.match(/\w/)) {
                this.text += entered;
            }
        }

        return true;
    }

    protected var _pipe :DisplayObject;
    protected var _tf :TextField;
}
}
