//
// Aztec

package aztec.connect {

import aztec.Aztec;

import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;
import flashbang.util.TextFieldBuilder;

import react.Signal;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

public class NameEntryView extends SpriteObject {
    public const nameEntered :Signal = new Signal(String);

    public function NameEntryView () {
        _sprite.addChild(MovieResource.createMovie("aztec/intro_screen"));

        _sprite.addChild(drawTextAt(158, 177, "Global Game Jam 2013", 26));
        _sprite.addChild(drawTextAt(158, 223, "Quetzalcoatl\nTeaches\nTyping", 70));
        _sprite.addChild(drawTextAt(158, 488, "Charlie Groves\nTim Conkling\nCeleste Masinter",
            24, Aztec.TITLE_FONT2));

        _sprite.addChild(drawTextAt(350, 492, "(@groves)", 18, Aztec.TITLE_FONT2, "http://twitter.com/groves"));
        _sprite.addChild(drawTextAt(350, 519, "(@timconkling)", 18, Aztec.TITLE_FONT2, "http://twitter.com/timconkling"));
        _sprite.addChild(drawTextAt(350, 546, "(@ephemeratics)", 18, Aztec.TITLE_FONT2, "http://twitter.com/ephemeratics"));
        _sprite.addChild(drawTextAt(158, 667, "Type your name!", 14, Aztec.TITLE_FONT2));

        _tfName = new TextEntryField(200, 30, "", Aztec.TITLE_FONT2, 24);
        _tfName.display.y = 627;
        _tfName.display.x = 184;
        addObject(_tfName, _sprite);
        _tfName.enterPressed.connect(function () :void {
            if (_tfName.text.length > 0) {
                nameEntered.emit(_tfName.text);
            }
        });
    }

    protected function drawTextAt (x :Number, y :Number, text :String, size :Number,
        font :String = "herculanumLarge", url :String = null) :TextField {

        var tf :TextField = new TextFieldBuilder(text)
            .color(Aztec.TITLE_COLOR)
            .hAlign(Align.LEFT)
            .font(font)
            .fontSize(size)
            .autoSizeVertical()
            .build();

        tf.x = x;
        tf.y = y;

        if (url != null) {
            this.regs.addEventListener(tf, TouchEvent.TOUCH, function (event :TouchEvent) :void {
                Mouse.cursor = (event.interactsWith(tf) ? MouseCursor.BUTTON : MouseCursor.AUTO);
                var touch:Touch = event.getTouch(tf);
                if (touch != null && touch.phase == TouchPhase.ENDED) {
                    openUrl(url, "_self");
                }
            });
        }

        return tf;
    }

    protected static function openUrl (url :String, window :String) :void {
        if (ExternalInterface.available) {
            ExternalInterface.call("window.open", url, window);
        } else {
            navigateToURL(new URLRequest(url), window);
        }
    }

    protected var _tfName :TextEntryField;
}
}
