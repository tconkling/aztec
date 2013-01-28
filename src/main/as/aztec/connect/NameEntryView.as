package aztec.connect {
import aspire.ui.KeyboardCodes;

import aztec.Aztec;
import aztec.input.KeyboardListener;

import flashbang.objects.SpriteObject;
import flashbang.resource.ImageResource;

import org.osflash.signals.Signal;

import starling.events.KeyboardEvent;
import starling.text.TextField;

public class NameEntryView extends SpriteObject implements KeyboardListener {

    public const nameEntered :Signal = new Signal(String);

    public function NameEntryView () {
        _sprite.addChild(ImageResource.createImage("aztec/img_intro"));
        _textField = new TextField(200, 30, "", Aztec.UI_FONT, 24);
        _textField.y = 627;
        _textField.x = 184;
        _sprite.addChild(_textField);
    }

    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }

        if (e.keyCode == KeyboardCodes.ENTER) {
            if (_textField.text.length > 0) {
                nameEntered.dispatch(_textField.text);
            }
        } else if (e.keyCode == KeyboardCodes.BACKSPACE) {
            _textField.text = _textField.text.substring(0, _textField.text.length - 1);
        } else if (_textField.text.length < 20) {
            var entered :String = String.fromCharCode(e.charCode);
            if (entered.match(/\w/)) {
                _textField.text += entered;
            }
        }

        return true;
    }
    override protected function addedToMode() :void {
        super.addedToMode();
        _regs.add(ConnectMode(mode).keyboardInput.registerListener(this));
    }

    protected var _textField :TextField;
}
}
