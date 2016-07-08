//
// qwf

package aztec.battle.controller {

import aspire.geom.Vector2;

import aztec.battle.desc.GameDesc;
import aztec.battle.view.BattleBoardView;

public class BattleBoard extends NetObject
{
    public function BattleBoard () {
        _width = GameDesc.BOARD_SIZE.x;
        _height = GameDesc.BOARD_SIZE.y;
    }

    public function get width () :int {
        return _width;
    }

    public function get height () :int {
        return _height;
    }

    public function get view () :BattleBoardView {
        return _view;
    }

    override public function get ids () :Array {
        return [ NAME ].concat(super.ids);
    }

    override protected function added () :void {
        super.added();
        _ctx.board = this;

        _view = new BattleBoardView(this);
        _ctx.viewObjects.addObject(_view, _ctx.boardLayer);
    }

    protected var _width :int;
    protected var _height :int;

    protected var _view :BattleBoardView;

    protected static const SCRATCH :Vector2 = new Vector2();

    protected static const NAME :String = "Board";
}
}

