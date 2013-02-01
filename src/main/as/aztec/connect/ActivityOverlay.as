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

public class ActivityOverlay extends SpriteObject {
    public function ActivityOverlay(activity :String) {
        var dark :DisplayObject =
            DisplayUtil.fillRect(Flashbang.stageWidth, Flashbang.stageHeight, 0);
        dark.alpha = 0.8;
        _sprite.addChild(dark);
        var searching :CustomTextField = new CustomTextField(1, 1, activity,
                Aztec.UI_FONT, 36, 0xffffff);
        searching.autoSize = TextFieldAutoSize.SINGLE_LINE;
        searching.x = (Flashbang.stageWidth - searching.width) * 0.5;
        searching.y = (Flashbang.stageHeight - searching.height) * 0.5;
        _sprite.addChild(searching);

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
                    searching.text = text;
                })));
    }
}
}
