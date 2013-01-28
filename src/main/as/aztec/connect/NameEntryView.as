//
// Aztec

package aztec.connect {

import aspire.ui.KeyboardCodes;

import aztec.Aztec;
import aztec.input.KeyboardListener;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import org.osflash.signals.Signal;

import starling.events.KeyboardEvent;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;

public class NameEntryView extends SpriteObject implements KeyboardListener {

    public const nameEntered :Signal = new Signal(String);

    public function NameEntryView () {
        _sprite.addChild(MovieResource.createMovie("aztec/intro_screen"));
        
        var title1 :TextField = drawText("Global Game Jam 2013", 26);
        title1.x = 158;
        title1.y = 177;
        _sprite.addChild(title1);
        
        var title2 :TextField = drawText("Quetzalcoatl\nTeaches\nTyping", 70);
        title2.x = 158;
        title2.y = 223;
        _sprite.addChild(title2);
        
        var title3 :TextField = drawText("Charlie Groves\nTim Conkling\nCeleste Masinter",
            24, Aztec.TITLE_FONT2);
        title3.x = 158;
        title3.y = 488;
        _sprite.addChild(title3);
        
        var title4 :TextField = drawText("Type your name!", 14, Aztec.TITLE_FONT2);
        title4.x = 158;
        title4.y = 667;
        _sprite.addChild(title4);
        
        _tfName = new TextField(200, 30, "", Aztec.TITLE_FONT2, 24);
        _tfName.y = 627;
        _tfName.x = 184;
        _sprite.addChild(_tfName);
    }

    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }

        if (e.keyCode == KeyboardCodes.ENTER) {
            if (_tfName.text.length > 0) {
                nameEntered.dispatch(_tfName.text);
            }
        } else if (e.keyCode == KeyboardCodes.BACKSPACE) {
            _tfName.text = _tfName.text.substring(0, _tfName.text.length - 1);
        } else if (_tfName.text.length < 20) {
            var entered :String = String.fromCharCode(e.charCode);
            if (entered.match(/\w/)) {
                _tfName.text += entered;
            }
        }

        return true;
    }
    
    protected function drawText (text :String, size :Number, font :String = "herculanumLarge") :TextField {
        var tf :TextField = new TextField(1, 1, text);
        tf.color = Aztec.TITLE_COLOR;
        tf.hAlign = HAlign.LEFT;
        tf.fontName = font
        tf.fontSize = size;
        tf.autoSize = TextFieldAutoSize.MULTI_LINE;
        return tf;
    }
    
    override protected function addedToMode() :void {
        super.addedToMode();
        _regs.add(ConnectMode(mode).keyboardInput.registerListener(this));
    }

    protected var _tfName :TextField;
}
}
