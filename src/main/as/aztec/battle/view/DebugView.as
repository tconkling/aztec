package aztec.battle.view {

import aztec.battle.controller.BattleDebug;

import flashbang.objects.SimpleTextButton;

public class DebugView extends LocalSpriteObject {
    public function DebugView(debug :BattleDebug) {
        _debug = debug;
        // Move out of the way of the framerate
        _sprite.y = 60;
        var sacrificeButton :SimpleTextButton = new SimpleTextButton("Sacrifice 1");
        addDependentObject(sacrificeButton, _sprite);
        sacrificeButton.clicked.add(function () :void { _debug.sacrifice(); });
    }

    private var _debug :BattleDebug;
}
}
