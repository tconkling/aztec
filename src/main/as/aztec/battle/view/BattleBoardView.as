//
// aztec

package aztec.battle.view {

import aspire.util.Comparators;

import aztec.battle.controller.BattleBoard;

import flashbang.objects.SpriteObject;
import flashbang.resource.ImageResource;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class BattleBoardView extends SpriteObject
{
    public static const GRID_COLOR :uint = 0xDCE7BC;
    
    public function BattleBoardView (board :BattleBoard) {
        _sprite.addChild(_scroller);
        
        _board = board;
        
        _groundLayer.addChild(ImageResource.createImage("aztec/img_background"));
        _groundLayer.flatten();
        
        _scroller.addChild(_groundLayer);
        _scroller.addChild(_objectLayer);
    }
    
    public function depthSort () :void {
        _objectLayer.sortChildren(depthCompare);
    }
    
    public function get groundLayer () :Sprite {
        return _groundLayer;
    }
    
    public function get objectLayer () :Sprite {
        return _objectLayer;
    }
    
    protected static function depthCompare (a :DisplayObject, b :DisplayObject) :Number {
        return Comparators.compareNumbers(a.y, b.y);
    }
    
    protected var _board :BattleBoard;
    
    protected var _scroller :Sprite = new Sprite();
    protected var _groundLayer :Sprite = new Sprite();
    protected var _objectLayer :Sprite = new Sprite();
}
}

