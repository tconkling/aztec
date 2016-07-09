//
// aciv

package aztec {

import flash.display.DisplayObject;
import flash.display.Screen;
import flash.events.Event;
import flash.geom.Rectangle;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
public class AztecDesktopApp extends AztecApp {
    public function AztecDesktopApp (splashScreen :DisplayObject = null) {
        super(splashScreen);
    }

    override protected function onAddedToStage (e :Event) :void {
        // center our window and show it
        var screenBounds :Rectangle = Screen.mainScreen.bounds;
        var windowBounds :Rectangle = this.stage.nativeWindow.bounds;
        this.stage.nativeWindow.x = screenBounds.x + ((screenBounds.width - windowBounds.width) * 0.5);
        this.stage.nativeWindow.y = screenBounds.y + ((screenBounds.height - windowBounds.height) * 0.5);
        this.stage.nativeWindow.visible = true;

        super.onAddedToStage(e);
    }
}
}
