//
// aztec

package aztec.connect {

import aztec.Aztec;
import aztec.NewGameCondition;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import org.osflash.signals.Signal;

import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;

public class StartMatchView extends SpriteObject {
    public const startEntered :Signal = new Signal();

    public function StartMatchView (condition :NewGameCondition) {
        _condition = condition;
        _textField = new TextEntryField(200, 30, "", Aztec.UI_FONT, 24);
        if (condition == NewGameCondition.INITIAL) {
            _sprite.addChild(MovieResource.createMovie("aztec/start_match_screen"));
            _sprite.addChild(drawTextAt(160, 349, "Type \"START\" to begin a new match", 14,
                Aztec.TITLE_FONT2));
            _textField.display.x = 184;
            _textField.display.y = 305;
            
        } else {
            if (condition == NewGameCondition.WON) {
                _sprite.addChild(MovieResource.createMovie("aztec/win_screen"));
                _sprite.addChild(drawTextAt(160, 168, "QuetzalCoatl\nSmiles!", 70));
                _sprite.addChild(drawTextAt(160, 325,
                    "Your sacrifices and typing skills\nhave impressed the gods", 18,
                    Aztec.TITLE_FONT2));
                
                _sprite.addChild(drawTextAt(160, 400, TIPS, 14, Aztec.TITLE_FONT2));
                
            } else {
                _sprite.addChild(MovieResource.createMovie("aztec/lose_screen"));
                _sprite.addChild(drawTextAt(160, 168, "Huitzilopochtli\nRages!", 70));
                _sprite.addChild(drawTextAt(160, 325,
                    "More sacrifices must be offered\nto atone for your typing skills", 24,
                    Aztec.TITLE_FONT2));
                
                _sprite.addChild(drawTextAt(160, 400, TIPS, 14, Aztec.TITLE_FONT2));
            }
            
            _sprite.addChild(drawTextAt(160, 667, "Type \"START\" to begin a new match", 12,
                Aztec.TITLE_FONT2));
            
            _textField.display.x = 184;
            _textField.display.y = 627;
        }
        addDependentObject(_textField, _sprite);
    }

    override protected function addedToMode() :void {
        super.addedToMode();
        _regs.addSignalListener(_textField.enterPressed, function () :void {
            if (_startEntered || _textField.text.toLowerCase() != "start") return;
            _startEntered = true;
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
        });
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

    protected var _startEntered :Boolean;
    protected var _condition :NewGameCondition;
    protected var _textField :TextEntryField;
    
    protected static const TIPS :String = "TIPS:\n" +
        "Press 'Escape' to cancel your current typing\nselection.\n\n" +
        "Steal villagers! Sacrifice them while\nthey're dancing or worshipping for your opponent.\n\n" +
        "Summoned Gods will destroy your\nopponent's dancing and worshipping villagers.\n\n" +
        "Capitalization doesn't matter. Neither do spaces.";
        
}
}
