//
// aztec

package aztec.battle.controller {
import aspire.geom.Vector2;

import aztec.battle.BattleCtx;
import aztec.battle.desc.PlayerDesc;
import aztec.battle.view.TempleView;
import aztec.battle.BattleCtx;
import aztec.data.SacrificeMessage;

public class Player extends NetObject
{
    public var templeHealth :Number = 1;
    public var templeDefense :Number = 0;
    public var summonPower :int = 0;
    public var villagerAffinity :Number = .5;

    public static function withOid (ctx :BattleCtx, oid :int) :Player {
        return Player(ctx.netObjects.getObjectNamed(nameForOid(oid)));
    }
    
    public function Player (oid :int, name :String, desc :PlayerDesc) {
        _oid = oid;
        _name = name;
        _desc = desc;
    }
    
    public function get name () :String { return _name; }
    public function get oid () :int { return _oid; }
    public function get desc () :PlayerDesc { return _desc; }
    
    override public function get objectNames () :Array {
        return [ nameForOid(oid) ].concat(super.objectNames);
    }

    override public function get objectGroups () :Array {
        return [ Player ].concat(super.objectGroups);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        _templeView = new TempleView();
        var loc :Vector2 = _ctx.board.view.boardToLocal(_desc.templeLoc);
        _templeView.display.x = loc.x;
        _templeView.display.y = loc.y;
        _ctx.viewObjects.addObject(_templeView, _ctx.board.view.objectLayer);
    }
    public function sacrifice(msg:SacrificeMessage):void {
        if (msg.senderOid == _oid) {
            villagerAffinity -= .2;
            summonPower++;
        } else {
            villagerAffinity += .2;
        }
    }
    
    protected static function nameForOid (oid :int) :String {
        return "Player_" + oid;
    }
    
    protected var _oid :int;
    protected var _name :String;
    protected var _desc :PlayerDesc;
    
    protected var _templeView :TempleView;

}
}
