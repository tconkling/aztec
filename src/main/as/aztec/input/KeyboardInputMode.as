package aztec.input {
import flashbang.core.AppMode;

import starling.events.KeyboardEvent;

public class KeyboardInputMode extends AppMode {

    public const keyboardInput :KeyboardInput = new KeyboardInput();

    override public function onKeyDown (keyEvent :KeyboardEvent) :void {
        if (!keyboardInput.handleKeyboardEvent(keyEvent)) {
            super.onKeyDown(keyEvent);
        }
    }

    override public function onKeyUp (keyEvent :KeyboardEvent) :void {
        if (!keyboardInput.handleKeyboardEvent(keyEvent)) {
            super.onKeyUp(keyEvent);
        }
    }
}
}
