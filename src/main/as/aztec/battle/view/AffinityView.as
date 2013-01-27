package aztec.battle.view {
import flashbang.objects.SpriteObject;
import flashbang.resource.ImageResource;
import flashbang.resource.MovieResource;

import starling.display.Image;

public class AffinityView extends SpriteObject {
    public function AffinityView() {
        var bar :Image = ImageResource.createImage("aztec/img_alignment_background");
        _sprite.x = 512;
        _sprite.y = 680;
        bar.y = 10;
        _sprite.addChild(bar);
        _range = bar.width/2;
        _head = ImageResource.createImage("aztec/img_alignment_head");
        _sprite.addChild(_head);
    }

    public function set affinity(affinity:Number):void {
        _head.x = _range * affinity;
    }

    protected var _range :Number;
    protected var _head :Image;
}
}
