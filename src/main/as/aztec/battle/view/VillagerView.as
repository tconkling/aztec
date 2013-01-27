//
// aztec

package aztec.battle.view {

import aspire.geom.Vector2;
import aspire.util.Randoms;
import aspire.util.StringUtil;

import aztec.Aztec;
import aztec.battle.controller.Villager;
import aztec.battle.desc.GameDesc;

import flash.geom.Rectangle;

import flashbang.resource.MovieResource;

import flump.display.Movie;

public class VillagerView extends LocalSpriteObject
{
    public function VillagerView (villager :Villager) {
        _actor = villager;
        _movie = MovieResource.createMovie("aztec/villager_0" + Aztec.rands.getInRange(1, 4));
        _sprite.addChild(_movie);
        
        _textView = new SelectableTextSprite(StringUtil.capitalize(villager.name));
        var bounds :Rectangle = _sprite.getBounds(_sprite);
        _textView.x = ((bounds.width - _textView.width) * 0.5) + bounds.x;
        _textView.y = -_textView.height + bounds.y - 4;
        _sprite.addChild(_textView);
        
        _regs.addSignalListener(villager.destroyed, destroySelf);
    }
    
    public function get textView () :SelectableTextSprite {
        return _textView;
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        var rands :Randoms = _ctx.randomsFor(this);
        _movie.goTo(rands.getInRange(0, _movie.frames));
        _movie.loop();
        
        // generate our loc
        _loc = pickRandomLoc();
    }
    
    override protected function update (dt :Number) :void {
        _sprite.x = _loc.x;
        _sprite.y = _loc.y;
        _movie.advanceTime(dt);
    }
    
    protected function pickRandomLoc () :Vector2 {
        var rands :Randoms = _ctx.randomsFor(this);
        var r :Rectangle = GameDesc.villagerWalkBounds;
        return new Vector2(
            r.x + rands.getNumberInRange(0, r.width),
            r.y + rands.getNumberInRange(0, r.height));
    }
    
    protected var _actor :Villager;
    
    protected var _movie :Movie;
    protected var _textView :SelectableTextSprite;
    
    protected var _loc :Vector2;
    
    protected static const SCRATCH :Vector2 = new Vector2();
}
}
