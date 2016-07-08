package aztec.battle.view {

import aztec.battle.controller.BattleDebug;

import flashbang.objects.SimpleTextButton;

public class DebugView extends LocalSpriteObject {
    public function DebugView(debug :BattleDebug, senderOid:int) {
        _debug = debug;
        // Move out of the way of the framerate
        _sprite.y = 768;
        createButton("Sacrifice").clicked.connect(function () :void { _debug.sacrifice(senderOid); });
        createButton("Summon").clicked.connect(function () :void { _debug.summon(senderOid); });
        createButton("Win").clicked.connect(function () :void { _debug.win(senderOid); });
    }

    protected function createButton (title :String) :SimpleTextButton {
        var button :SimpleTextButton = new SimpleTextButton(title);
        button.sprite.y = ++_buttonCount * -40;
        addObject(button, _sprite);
        return button;
    }

    private var _debug :BattleDebug;
    private var _buttonCount :int;
}
}
