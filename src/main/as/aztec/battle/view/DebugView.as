package aztec.battle.view {

import aztec.battle.controller.BattleDebug;

import flashbang.objects.SimpleTextButton;

public class DebugView extends LocalSpriteObject {
    public function DebugView(debug :BattleDebug) {
        _debug = debug;
        // Move out of the way of the framerate
        _sprite.y = 60;
        var sacrificeButton :SimpleTextButton = new SimpleTextButton("Sacrifice");
        addDependentObject(sacrificeButton, _sprite);
        sacrificeButton.clicked.add(function () :void { _debug.sacrifice(); });
        var summonButton :SimpleTextButton = new SimpleTextButton("Summon");
        summonButton.sprite.y += sacrificeButton.sprite.height + 10;
        addDependentObject(summonButton, _sprite);
        summonButton.clicked.add(function () :void { _debug.summon(); });
    }

    private var _debug :BattleDebug;
}
}
