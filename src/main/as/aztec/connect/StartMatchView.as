//
// aztec

package aztec.connect {

import aztec.Aztec;
import aztec.NewGameCondition;
import aztec.battle.desc.GameDesc;
import aztec.battle.view.SelectableTextSprite;
import aztec.text.CustomTextField;

import flashbang.core.GameObject;
import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;
import flashbang.tasks.RepeatingTask;

import org.osflash.signals.Signal;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;

public class StartMatchView extends SpriteObject {
    public const startEntered :Signal = new Signal();

    public function StartMatchView (condition :NewGameCondition) {
        _condition = condition;
        _textField = new TextEntryField(200, 30, "", Aztec.UI_FONT, 24);


        var static :Sprite = new Sprite();
        _sprite.addChild(static);

        if (condition == NewGameCondition.INITIAL) {
            static.addChild(MovieResource.createMovie("aztec/new_match_screen"));
            static.addChild(drawTextAt(673, 673, "Type \"START\" to begin a new match", 14,
                Aztec.TITLE_FONT2));
            _textField.display.x = 704;
            _textField.display.y = 636;

            static.addChild(drawTextAt(47, 126, KEYBOARD_ONLY, 12, Aztec.TITLE_FONT2, 0xffffff));

            static.addChild(drawTextAt(417, 150, "How to Play", 30));

            const HELP_SIZE :Number = 18;

            static.addChild(drawTextAt(238, 220, HELP_1, HELP_SIZE, Aztec.COMMAND_FONT));
            static.addChild(drawTextAt(603, 220, HELP_2, HELP_SIZE, Aztec.COMMAND_FONT));
            static.addChild(drawTextAt(534, 376, HELP_3, HELP_SIZE, Aztec.COMMAND_FONT));
            static.addChild(drawTextAt(50, 505, HELP_4, HELP_SIZE, Aztec.COMMAND_FONT));
            static.addChild(drawTextAt(58, 584, HELP_5, HELP_SIZE, Aztec.COMMAND_FONT));
            static.addChild(drawTextAt(210, 690, HELP_6, HELP_SIZE, Aztec.COMMAND_FONT));

            var animator :GameObject = new GameObject();
            addDependentObject(animator);

            var sts :SelectableTextSprite = new SelectableTextSprite("Xoxipepe", Aztec.UI_FONT, 24);
            sts.x = 145;
            sts.y = 180;
            _sprite.addChild(sts);
            animator.addTask(SelectNextCharacterTask.createTypingAnimTask(
                sts, GameDesc.player1.color));

            sts = new SelectableTextSprite("Quetzalcoatl", Aztec.UI_FONT, 24);
            sts.x = 334;
            sts.y = 302;
            _sprite.addChild(sts);
            animator.addTask(SelectNextCharacterTask.createTypingAnimTask(
                sts, GameDesc.player1.color));

        } else {
            if (condition == NewGameCondition.WON) {
                static.addChild(MovieResource.createMovie("aztec/win_screen"));
                static.addChild(drawTextAt(160, 168, "QuetzalCoatl\nSmiles!", 70));
                static.addChild(drawTextAt(160, 325,
                    "Your sacrifices and typing skills\nhave impressed the gods", 18,
                    Aztec.TITLE_FONT2));

                static.addChild(drawTextAt(160, 395, TIPS, 14, Aztec.TITLE_FONT2));

            } else {
                static.addChild(MovieResource.createMovie("aztec/lose_screen"));
                static.addChild(drawTextAt(160, 168, "Huitzilopochtli\nRages!", 70));
                static.addChild(drawTextAt(160, 325,
                    "More sacrifices must be offered\nto atone for your typing skills", 24,
                    Aztec.TITLE_FONT2));

                static.addChild(drawTextAt(160, 395, TIPS, 14, Aztec.TITLE_FONT2));
            }

            static.addChild(drawTextAt(160, 667, "Type \"START\" to begin a new match", 12,
                Aztec.TITLE_FONT2));

            _textField.display.x = 184;
            _textField.display.y = 627;
        }

        static.flatten();

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
        font :String = "herculanumLarge", color :uint = 0x192E20) :DisplayObject {

        if (CustomTextField.getBitmapFont(font) != null) {
            var ctf :CustomTextField = new CustomTextField(1, 1, text);
            ctf.color = color;
            ctf.hAlign = HAlign.LEFT;
            ctf.fontName = font
            ctf.fontSize = size;
            ctf.autoSize = TextFieldAutoSize.MULTI_LINE;
            ctf.x = x;
            ctf.y = y;
            return ctf;
        } else {
            var tf :TextField = new TextField(1, 1, text);
            tf.color = color;
            tf.hAlign = HAlign.LEFT;
            tf.fontName = font
            tf.fontSize = size;
            tf.autoSize = TextFieldAutoSize.MULTI_LINE;
            tf.x = x;
            tf.y = y;
            return tf;
        }
    }

    protected var _startEntered :Boolean;
    protected var _condition :NewGameCondition;
    protected var _textField :TextEntryField;

    protected static const KEYBOARD_ONLY :String = "Quetzalcoatl Teaches Typing is a keyboard-only game!\nPut down that mouse.";

    protected static const HELP_1 :String = "Type a villager's name to\nselect them.";
    protected static const HELP_2 :String = "A selected villager can be\nsacrificed for a heart.";
    protected static const HELP_3 :String = "Spend hearts to summon gods and\nattack your opponent's temple!";
    protected static const HELP_4 :String = "Sacrifices make other villagers angry! Angry villagers require more typing to command.";
    protected static const HELP_5 :String = "Send villagers to the Festival\nto make them happier!";
    protected static const HELP_6 :String = "Make villagers worship to\nincrease your defenses!";

    protected static const TIPS :String = "TIPS:\n" +
        "Press 'Escape' to cancel your current typing selection.\n\n" +
        "Steal villagers! Sacrifice them while\nthey're dancing or worshipping for your opponent.\n\n" +
        "Summoned Gods will destroy your\nopponent's dancing and worshipping villagers.\n\n" +
        "Capitalization doesn't matter. Neither do spaces.\n\n" +
        "Higher-ranked Gods do much more damage than\nlower-ranked ones.";
}
}

import aspire.util.Randoms;

import aztec.battle.view.SelectableTextSprite;

import flashbang.core.GameObject;
import flashbang.core.ObjectTask;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.VariableTimedTask;

class SelectNextCharacterTask implements ObjectTask {
    public static function createTypingAnimTask (sprite :SelectableTextSprite, color :uint) :ObjectTask {
        var rands :Randoms = new Randoms();
        var endDelay :Number = rands.getNumberInRange(2, 4);
        return new RepeatingTask(
            new VariableTimedTask(0.2, 0.8, new Randoms()),
            new SelectNextCharacterTask(sprite, color),
            new FunctionTask(function (dt :Number) :Boolean {
                if (sprite.selectionLength < sprite.text.length) {
                    return true;
                } else {
                    endDelay -= dt;
                    if (endDelay <= 0) {
                        endDelay = rands.getNumberInRange(2, 4);
                        return true;
                    }
                }
                return false;
            }));
    }

    public function SelectNextCharacterTask (sprite :SelectableTextSprite, color :uint) {
        _sprite = sprite;
        _color = color;
    }

    public function update (dt :Number, obj :GameObject) :Boolean {
        var numChars :int = _sprite.selectionLength + 1;
        if (numChars > _sprite.text.length) {
            numChars = 0;
        }
        _sprite.select(numChars, _color);
        return true;
    }

    public function clone () :ObjectTask {
        return new SelectNextCharacterTask(_sprite, _color);
    }

    protected var _sprite :SelectableTextSprite;
    protected var _color :uint;
}
