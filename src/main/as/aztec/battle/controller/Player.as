//
// aztec

package aztec.battle.controller {

public class Player extends BattleObject
{
    public var templeHealth :Number = 1;
    public var templeDefense :Number = 0;
    public var summonPower :int = 0;
    
    public function get name () :String { return _name; }
    
    public function Player (id :int, name :String) {
        _id = id;
        _name = name;
    }
    
    protected var _id :int;
    protected var _name :String;
}
}
