//
// aztec

package aztec.battle.controller {
import aspire.geom.Vector2;

import aztec.battle.desc.PlayerDesc;
import aztec.battle.view.TempleView;

public class Player extends BattleObject
{
    public var templeHealth :Number = 1;
    public var templeDefense :Number = 0;
    public var summonPower :int = 0;
    
    public static function withId (ctx :BattleCtx, id :int) :Player {
        return Player(ctx.netObjects.getObjectNamed(nameForId(id)));
    }
    
    public function get name () :String { return _name; }
    public function get id () :int { return _id; }
    
    public function Player (id :int, name :String, desc :PlayerDesc) {
        _id = id;
        _name = name;
        _desc = desc;
    }
    
    override public function get objectNames () :Array {
        return [ nameForId(id) ].concat(super.objectNames);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        _templeView = new TempleView();
        var loc :Vector2 = _ctx.board.view.boardToLocal(_desc.templeLoc);
        _templeView.display.x = loc.x;
        _templeView.display.y = loc.y;
        _ctx.viewObjects.addObject(_templeView, _ctx.board.view.objectLayer);
    }
    
    protected static function nameForId (id :int) :String {
        return "Player_" + id;
    }
    
    protected var _id :int;
    protected var _name :String;
    protected var _desc :PlayerDesc;
    
    protected var _templeView :TempleView;
}
}
