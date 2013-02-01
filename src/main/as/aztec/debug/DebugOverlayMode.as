//
// aztec

package aztec.debug {

import flashbang.core.AppMode;
import flashbang.debug.FramerateView;

import starling.text.TextFieldAutoSize;

public class DebugOverlayMode extends AppMode
{
    override protected function setup () :void {
        var fpsView :FramerateView = new FramerateView();
        fpsView.extendedData = false;
        fpsView.textField.fontSize = 32;
        fpsView.textField.autoSize = TextFieldAutoSize.SINGLE_LINE;
        fpsView.textField.x = 3;
        fpsView.textField.y = 3;
        addObject(fpsView, _modeSprite);
    }

    override protected function enter () :void {
        _modeSprite.touchable = false;
    }
}
}

