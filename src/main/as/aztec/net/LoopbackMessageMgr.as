//
// aztec

package aztec.net {

public class LoopbackMessageMgr
    implements MessageMgr
{
    public function LoopbackMessageMgr (tickInterval :Number) {
        _tickInterval = tickInterval;
        _nextTickTime = tickInterval;
        _ticks.unshift(new GameTickMsg());
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
                _ticks.unshift(new GameTickMsg());
            }
        }
    }
    
    public function get hasTick () :Boolean {
        return _ticks.length > 1;
    }
    
    public function getNextTick () :GameTickMsg {
        // we don't return the last tick
        return (_ticks.length > 1 ? _ticks.pop() : null);
    }
    
    public function sendMessage (msg :Message) :void {
        _ticks[0].messages.push(msg);
    }
    
    protected var _tickInterval :Number;
    protected var _nextTickTime :Number;
    
    protected var _ticks :Vector.<GameTickMsg> = new <GameTickMsg>[];
}
}
