//
// aztec

package aztec.battle {
import aspire.geom.Vector2;

public class VillagerCommand
{
    public var action :VillagerAction;
    public var text :String;
    public var loc :Vector2;
    
    public function VillagerCommand (action :VillagerAction, text :String, loc :Vector2) {
        this.action = action;
        this.text = text;
        this.loc = loc;
    }
}
}
