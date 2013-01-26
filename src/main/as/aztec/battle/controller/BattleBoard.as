//
// qwf

package aztec.battle.controller {

import aspire.geom.Vector2;

import flashbang.core.Flashbang;

import aztec.Aztec;
import aztec.battle.ctx.BattleObject;
import aztec.battle.view.BattleBoardView;

public class BattleBoard extends BattleObject
{
    public function BattleBoard () {
        _width = Aztec.BOARD_SIZE.x;
        _height = Aztec.BOARD_SIZE.y;
    }
    
    public function get view () :BattleBoardView {
        return _view;
    }
    
    public function get width () :int {
        return _width;
    }
    
    public function get height () :int {
        return _height;
    }
    
    override public function get objectNames () :Array {
        return [ NAME ].concat(super.objectNames);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        _ctx.board = this;
        _view = new BattleBoardView(this);
        addDependentObject(_view, _ctx.boardLayer);
        _view.display.x = (Flashbang.stageWidth - _view.display.width) * 0.5;
        _view.display.y = 30;
    }
    
    protected var _view :BattleBoardView;
    
    protected var _width :int;
    protected var _height :int;
    
    protected static const SCRATCH :Vector2 = new Vector2();
    
    protected static const NAME :String = "Board";
}
}

