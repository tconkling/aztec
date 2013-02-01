//
// Aztec

package aztec.connect {

import aztec.Aztec;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import org.osflash.signals.Signal;

import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;

public class NameEntryView extends SpriteObject {

    public const nameEntered :Signal = new Signal(String);

    public function NameEntryView () {
        _sprite.addChild(MovieResource.createMovie("aztec/intro_screen"));

        _sprite.addChild(drawTextAt(158, 177, "Global Game Jam 2013", 26));
        _sprite.addChild(drawTextAt(158, 223, "Quetzalcoatl\nTeaches\nTyping", 70));
        _sprite.addChild(drawTextAt(158, 488, "Charlie Groves\nTim Conkling\nCeleste Masinter",
            24, Aztec.TITLE_FONT2));
        _sprite.addChild(drawTextAt(158, 667, "Type your name!", 14, Aztec.TITLE_FONT2));

        _tfName = new TextEntryField(200, 30, "", Aztec.TITLE_FONT2, 24);
        _tfName.display.y = 627;
        _tfName.display.x = 184;
        addDependentObject(_tfName, _sprite);
        _tfName.enterPressed.add(function () :void {
            if (_tfName.text.length > 0) {
                nameEntered.dispatch(_tfName.text);
            }
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

    protected var _tfName :TextEntryField;
}
}
