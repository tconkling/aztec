package aztec.connect {
import aspire.ui.KeyboardCodes;

import aztec.Aztec;
import aztec.input.KeyboardListener;

import flashbang.objects.SpriteObject;
import flashbang.resource.ImageResource;

import org.osflash.signals.Signal;

import starling.events.KeyboardEvent;

import starling.text.TextField;

public class StartMatchView extends SpriteObject implements KeyboardListener {
    public const startEntered :Signal = new Signal();

    public function StartMatchView() {
        _sprite.addChild(ImageResource.createImage("aztec/img_start_match"));
        _textField = new TextField(200, 30, "", Aztec.UI_FONT, 24);
        _textField.y = 303;
        _textField.x = 184;
        _sprite.addChild(_textField);
    }

    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }

        if (e.keyCode == KeyboardCodes.ENTER) {
            if (_textField.text.toLowerCase() == "start") {

                var searching :TextField = new TextField(400, 300, "Searching for opponent", Aztec.UI_FONT, 36);
                searching.x = 300;
                searching.y = 100;
                _sprite.addChild(searching);
                startEntered.dispatch();
            }
        } else if (e.keyCode == KeyboardCodes.BACKSPACE) {
            _textField.text = _textField.text.substring(0, _textField.text.length - 1);
        } else if (_textField.text.length < 20) {
            _textField.text += String.fromCharCode(e.charCode);
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
