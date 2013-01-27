package aztec.connect {
import flashbang.objects.SpriteObject;

import org.osflash.signals.Signal;

public class StartMatchView extends SpriteObject {
    public const startEntered :Signal = new Signal(String);
    public function StartMatchView() {
    }
}
}
