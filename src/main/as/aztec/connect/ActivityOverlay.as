//
// aztec

package aztec.connect {

import aztec.Aztec;
import aztec.text.CustomTextField;

import flashbang.core.Flashbang;
import flashbang.objects.SpriteObject;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;

import starling.display.DisplayObject;
import starling.text.TextFieldAutoSize;

public class ActivityOverlay extends SpriteObject
{
    public function ActivityOverlay (activity :String, subText :String = null) {
        var dark :DisplayObject =
            DisplayUtil.fillRect(Flashbang.stageWidth, Flashbang.stageHeight, 0);
        dark.alpha = 0.8;
        _sprite.addChild(dark);
        var tfActivity :CustomTextField = new CustomTextField(1, 1, activity,
                Aztec.UI_FONT, 42, 0xffffff);
        tfActivity.autoSize = TextFieldAutoSize.MULTI_LINE;
        tfActivity.x = (Flashbang.stageWidth - tfActivity.width) * 0.5;
        tfActivity.y = (Flashbang.stageHeight - tfActivity.height) * 0.5;
        _sprite.addChild(tfActivity);

        var numDots :int = 0;
        addTask(new RepeatingTask(
                new TimedTask(0.4),
                new FunctionTask(function () :void {
                    if (++numDots > 3) {
                        numDots = 0;
                    }
                    var text :String = activity;
                    for (var ii :int = 0; ii < numDots; ++ii) {
                        text += ".";
                    }
                    tfActivity.text = text;
                })));

        if (subText != null) {
            var tfSubText :CustomTextField =
                new CustomTextField(1, 1, subText, Aztec.UI_FONT, 20, 0xEBEBEB);
            tfSubText.autoSize = TextFieldAutoSize.MULTI_LINE;
            tfSubText.x = (Flashbang.stageWidth - tfSubText.width) * 0.5;
            tfSubText.y = tfActivity.y + tfActivity.height + 30;
            _sprite.addChild(tfSubText);
        }
    }
}
}
