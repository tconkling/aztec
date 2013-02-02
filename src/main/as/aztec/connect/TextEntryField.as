//
// aztec

package aztec.connect {

import aspire.ui.KeyboardCodes;

import aztec.input.KeyboardInputMode;

import aztec.input.KeyboardListener;

import flashbang.objects.SpriteObject;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;

import org.osflash.signals.Signal;

import starling.display.DisplayObject;

import starling.events.KeyboardEvent;

import starling.text.TextField;

public class TextEntryField extends SpriteObject implements KeyboardListener {
    public const enterPressed :Signal = new Signal();

    public const textChanged :Signal = new Signal(String);

    public function TextEntryField(width:int, height:int, text:String, fontName:String="Verdana",
                                   fontSize:Number=12, color:uint=0x0, bold:Boolean=false) {
        _tf = new TextField(width, height, text, fontName, fontSize, color, bold);
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
        textChanged.dispatch(newText);
    }

    override protected function addedToMode() :void {
        super.addedToMode();
        _regs.add(KeyboardInputMode(mode).keyboardInput.registerListener(this));
        addTask(new RepeatingTask(new TimedTask(.5),
            new FunctionTask(function () :void {
                _pipe.visible = !_pipe.visible;
            })));
    }

    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }

        if (e.keyCode == KeyboardCodes.ENTER) {
            enterPressed.dispatch();
        } else if (e.keyCode == KeyboardCodes.BACKSPACE) {
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
