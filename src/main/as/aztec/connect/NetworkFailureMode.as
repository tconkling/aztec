package aztec.connect {

import aztec.Aztec;
import aztec.text.CustomTextField;

import flashbang.core.AppMode;

import flashbang.resource.MovieResource;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.Align;

public class NetworkFailureMode extends AppMode {
    public function NetworkFailureMode(reason :String) {
        _reason = reason;
    }

    override protected function setup() :void {
        var fixed :Sprite = new Sprite();
        _modeSprite.addChild(fixed);
        fixed.addChild(MovieResource.createMovie("aztec/lose_screen"));
        fixed.addChild(drawTextAt(160, 168, "Huitzilopochtli\nRages!", 70));
        fixed.addChild(drawTextAt(160, 325, _reason, 24, Aztec.TITLE_FONT2));
        fixed.addChild(drawTextAt(160, 667, "Type \"START\" to try again", 12, Aztec.TITLE_FONT2));

        _textField = new TextEntryField(200, 30, "", Aztec.UI_FONT, 24);
        _textField.display.x = 184;
        _textField.display.y = 627;
        addObject(_textField,  _modeSprite);

        _regs.add(_textField.enterPressed.connect(function () :void {
            if (_textField.text.toLowerCase() != "start") {
                return;
            }

            _modeStack.unwindToMode(new ConnectMode());
        }));
    }

    protected static function drawTextAt (x :Number, y :Number, text :String, size :Number,
                                          font :String = "herculanumLarge", color :uint = 0x192E20) :DisplayObject {

        if (CustomTextField.getBitmapFont(font) != null) {
            var ctf :CustomTextField = new CustomTextField(1, 1, text);
            ctf.color = color;
            ctf.hAlign = Align.LEFT;
            ctf.fontName = font;
            ctf.fontSize = size;
            ctf.autoSize = TextFieldAutoSize.MULTI_LINE;
            ctf.x = x;
            ctf.y = y;
            return ctf;
        } else {
            var tf :TextField = new TextField(1, 1, text);
            tf.color = color;
            tf.hAlign = Align.LEFT;
            tf.fontName = font
            tf.fontSize = size;
            tf.autoSize = TextFieldAutoSize.MULTI_LINE;
            tf.x = x;
            tf.y = y;
            return tf;
        }
    }

    private var _reason :String;
    protected var _textField :TextEntryField;
}
}
