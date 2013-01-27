//
// aztec

package aztec.battle.view {

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;

import aspire.util.Comparators;

import flashbang.resource.ImageResource;
import flashbang.util.DisplayUtil;

import aztec.Aztec;
import aztec.battle.controller.BattleBoard;
import aztec.view.BoardView;

public class BattleBoardView extends BoardView
{
    public static const GRID_COLOR :uint = 0xDCE7BC;
    
    public function BattleBoardView (board :BattleBoard) {
        super(Aztec.TILE_SIZE_PX, Aztec.BOARD_SIZE.mult(Aztec.TILE_SIZE_PX));
        _board = board;
        
        _groundLayer.addChild(ImageResource.createImage("aztec/img_background"));
//        _groundLayer.addChild(createGridLines());
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

    protected function createGridLines () :Sprite {
        var gridLines :Sprite = new Sprite();
        
        const LINE_SIZE :Number = 1;
        
        var line :Quad = null;
        
        // horizontal lines
        const width :Number = _board.width * _tileSizePx.x;
        for (var yy :int = 0; yy <= _board.height; ++yy) {
            line = DisplayUtil.fillRect(width, LINE_SIZE, GRID_COLOR);
            line.y = yy * _tileSizePx.y;
            gridLines.addChild(line);
        }
        // vertical lines
        const height :Number = _board.height * _tileSizePx.y;
        for (var xx :int = 0; xx <= _board.width; ++xx) {
            line = DisplayUtil.fillRect(LINE_SIZE, height, GRID_COLOR);
            line.x = xx * _tileSizePx.x;
            gridLines.addChild(line);
        }
        
        gridLines.flatten();
        
        return gridLines;
    }
    
    protected static function depthCompare (a :DisplayObject, b :DisplayObject) :Number {
        return Comparators.compareNumbers(a.y, b.y);
    }
    
    protected var _board :BattleBoard;
    
    protected var _groundLayer :Sprite = new Sprite();
    protected var _objectLayer :Sprite = new Sprite();
}
}

