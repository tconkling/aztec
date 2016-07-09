//
// aztec

package aztec.net {
import aztec.data.AztecMessage;

public interface MessageMgr
{
    function get isReady () :Boolean;
    function update (dt :Number) :void;
    
    function get ticks () :Vector.<Vector.<AztecMessage>>;

    function sendMessage (senderOid :int, msg :AztecMessage) :void;
}
}
