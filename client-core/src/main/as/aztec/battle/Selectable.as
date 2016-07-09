//
// aztec

package aztec.battle {

import aztec.battle.view.SelectableTextSprite;

public interface Selectable
{
    function get textSprite () :SelectableTextSprite;

    function get isSelectable () :Boolean;

    function markSelected() :void;
}
}
