//
// aztec

package aztec.connect {

import aspire.ui.KeyboardCodes;

import aztec.Aztec;
import aztec.NewGameCondition;
import aztec.input.KeyboardListener;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import org.osflash.signals.Signal;

import starling.events.KeyboardEvent;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;

public class StartMatchView extends SpriteObject implements KeyboardListener {
    public const startEntered :Signal = new Signal();

    public function StartMatchView (condition :NewGameCondition) {
        _condition = condition;
        _textField = new TextField(200, 30, "", Aztec.UI_FONT, 24);
        if (condition == NewGameCondition.INITIAL) {
            _sprite.addChild(MovieResource.createMovie("aztec/start_match_screen"));
            _sprite.addChild(drawTextAt(160, 349, "Type \"START\" to begin a new match", 14,
                Aztec.TITLE_FONT2));
            _textField.x = 184;
            _textField.y = 305;
            
        } else {
            if (condition == NewGameCondition.WON) {
                _sprite.addChild(MovieResource.createMovie("aztec/win_screen"));
                _sprite.addChild(drawTextAt(160, 228, "QuetzalCoatl\nSmiles!", 70));
                _sprite.addChild(drawTextAt(160, 385,
                    "Your sacrifices and typing\nskills have impressed the\ngods", 18,
                    Aztec.TITLE_FONT2));
            } else {
                _sprite.addChild(MovieResource.createMovie("aztec/lose_screen"));
                _sprite.addChild(drawTextAt(160, 228, "Huitzilopochtli\nRages!", 70));
                _sprite.addChild(drawTextAt(160, 385,
                    "More sacrifices must be offered\nto atone for your typing skills", 24,
                    Aztec.TITLE_FONT2));
            }
            
            _sprite.addChild(drawTextAt(160, 667, "Type \"START\" to begin a new match", 14,
                Aztec.TITLE_FONT2));
            
            _textField.x = 184;
            _textField.y = 627;
        }
        _sprite.addChild(_textField);
    }

    public function onKeyboardEvent (e :KeyboardEvent) :Boolean {
        if (e.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }

        if (e.keyCode == KeyboardCodes.ENTER) {
            if (_textField.text.toLowerCase() == "start") {
                var searching :TextField = new TextField(400, 300, "Searching for opponent", Aztec.UI_FONT, 36);
                if (_condition == NewGameCondition.INITIAL) {
                    searching.x = 300;
                    searching.y = 100;
                } else {
                    searching.x = 95;
                    searching.y = 340;
                }
                _sprite.addChild(searching);
                startEntered.dispatch();
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
    
    protected static function drawTextAt (x :Number, y :Number, text :String, size :Number,
        font :String = "herculanumLarge") :TextField {
        
        var tf :TextField = new TextField(1, 1, text);
        tf.color = Aztec.TITLE_COLOR;
        tf.hAlign = HAlign.LEFT;
        tf.fontName = font
        tf.fontSize = size;
        tf.autoSize = TextFieldAutoSize.MULTI_LINE;
        tf.x = x;
        tf.y = y;
        return tf;
    }

    protected var _condition :NewGameCondition;
    protected var _textField :TextField;
}
}
