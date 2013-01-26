//
// qwf

package aztec.battle.controller {

import aspire.geom.Vector2;

import aztec.Aztec;

public class BattleBoard extends BattleObject
{
    public function BattleBoard () {
        _width = Aztec.BOARD_SIZE.x;
        _height = Aztec.BOARD_SIZE.y;
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
    }
    
    protected var _width :int;
    protected var _height :int;
    
    protected static const SCRATCH :Vector2 = new Vector2();
    
    protected static const NAME :String = "Board";
}
}

