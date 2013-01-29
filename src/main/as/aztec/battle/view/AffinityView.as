//
// aztec

package aztec.battle.view {

import flashbang.resource.ImageResource;

import starling.display.Image;

public class AffinityView extends LocalSpriteObject
{
    public function AffinityView () {
        var bar :Image = ImageResource.createImage("aztec/img_alignment_background");
        _sprite.x = 512;
        _sprite.y = 680;
        bar.y = 10;
        _sprite.addChild(bar);
        _range = bar.width/2;
        _head = ImageResource.createImage("aztec/img_alignment_head");
        _sprite.addChild(_head);
    }
    
    override protected function update (dt :Number) :void {
        _head.x = _ctx.localPlayer.affinity * _range;
    }

    protected var _range :Number;
    protected var _head :Image;
}
}
