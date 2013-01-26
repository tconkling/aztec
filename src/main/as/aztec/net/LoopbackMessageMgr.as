//
// aztec

package aztec.net {
import aztec.data.AztecMessage;

public class LoopbackMessageMgr
    implements MessageMgr
{
    public function LoopbackMessageMgr (tickInterval :Number) {
        _tickInterval = tickInterval;
        _nextTickTime = tickInterval;
    }
    
    public function get isReady () :Boolean {
        return true;
    }
    
    public function update (dt :Number) :void {
        // create new tick timeslices as necessary
        while (dt > 0) {
            if (dt < _nextTickTime) {
                _nextTickTime -= dt;
                dt = 0;
            } else {
                dt -= _nextTickTime;
                _nextTickTime = _tickInterval;
                _filled.unshift(_filling);
                _filling = new <AztecMessage>[];
            }
        }
    }

    public function get ticks () :Vector.<Vector.<AztecMessage>> {
        const toReturn :Vector.<Vector.<AztecMessage>> = _filled;
        _filled =  new <Vector.<AztecMessage>>[];
        return toReturn;
    }
    
    public function sendMessage (msg :AztecMessage) :void {
        _filling.push(msg);
    }
    
    protected var _tickInterval :Number;
    protected var _nextTickTime :Number;

    protected var _filling :Vector.<AztecMessage> = new <AztecMessage>[];
    protected var _filled :Vector.<Vector.<AztecMessage>> = new <Vector.<AztecMessage>>[];
}
}
