//
// aztec

package aztec.connect {

import aztec.Aztec;

import flashbang.core.Flashbang;
import flashbang.core.ObjectTask;
import flashbang.objects.SpriteObject;
import flashbang.tasks.CallbackTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;
import flashbang.util.DisplayUtil;
import flashbang.util.TextFieldBuilder;

import starling.display.DisplayObject;
import starling.text.TextField;

public class ActivityOverlay extends SpriteObject
{
    public function ActivityOverlay (activity :String, subText :String = null) {
        var dark :DisplayObject =
            DisplayUtil.fillRect(Flashbang.stageWidth, Flashbang.stageHeight, 0);
        dark.alpha = 0.8;
        _sprite.addChild(dark);

        var tfActivity :TextField = new TextFieldBuilder(activity)
            .font(Aztec.UI_FONT)
            .fontSize(42)
            .color(0xffffff)
            .autoSize()
            .build();
        tfActivity.x = (Flashbang.stageWidth - tfActivity.width) * 0.5;
        tfActivity.y = (Flashbang.stageHeight - tfActivity.height) * 0.5;
        _sprite.addChild(tfActivity);

        var numDots :int = 0;

        addObject(new RepeatingTask(function () :ObjectTask {
            return new SerialTask(
                new TimedTask(0.4),
                new CallbackTask(function () :void {
                    if (++numDots > 3) {
                        numDots = 0;
                    }
                    var text :String = activity;
                    for (var ii :int = 0; ii < numDots; ++ii) {
                        text += ".";
                    }
                    tfActivity.text = text;
                }));
        }));

        if (subText != null) {
            var tfSubText :TextField = new TextFieldBuilder(subText)
                .font(Aztec.UI_FONT)
                .fontSize(20)
                .color(0xEBEBEB)
                .autoSize()
                .build();
            tfSubText.x = (Flashbang.stageWidth - tfSubText.width) * 0.5;
            tfSubText.y = tfActivity.y + tfActivity.height + 30;
            _sprite.addChild(tfSubText);
        }
    }
}
}
