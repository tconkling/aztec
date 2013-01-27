//
// aztec

package aztec.battle {

import aztec.Aztec;
import aztec.data.AztecMessage;
import aztec.data.MoveMessage;
import aztec.net.MessageMgr;

public class BattleMessages
{
    public function BattleMessages (ctx :BattleCtx, mgr :MessageMgr) {
        _ctx = ctx;
        _mgr = mgr;
    }
    
    public function processTicks (dt :Number) :void {
        _mgr.update(dt);
        
        // update the network
        for each (var ticks :Vector.<AztecMessage> in _mgr.ticks) {
            for each (var msg :AztecMessage in ticks) {
                handleMessage(msg);
            }
            _ctx.netObjects.update(Aztec.NETWORK_UPDATE_RATE);
        }
    }
    
    protected function handleMessage (msg :AztecMessage) :void {
        if (msg is MoveMessage) {
        } else {
            trace("Unhandled message! " + msg);
        }
    }
    
    protected var _ctx :BattleCtx;
    protected var _mgr :MessageMgr;
}
}
