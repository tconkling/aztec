//
// aztec

package aztec.net {

public interface MessageMgr
{
    function get isReady () :Boolean;
    function update (dt :Number) :void;
    
    function get hasTick () :Boolean;
    function getNextTick () :GameTickMsg;
    
    function sendMessage (msg :Message) :void;
}
}
