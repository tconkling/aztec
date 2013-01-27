package aztec.net {
import aztec.data.AztecMessage;
import aztec.data.MatchObject;

import com.threerings.io.TypedArray;

public class NetworkedMessageMgr implements MessageMgr {
    public function NetworkedMessageMgr(matchObj: MatchObject) {
        _matchObject = matchObj;
        _matchObject.messagesChanged.add(function (newMessages :TypedArray, oldMessages :TypedArray) :void {
            const tick :Vector.<AztecMessage> = new <AztecMessage>[];
            for each (var message :AztecMessage in newMessages) {
                tick.push(message);
            }
            _ticks.push(tick);
        });
    }

    public function get isReady () :Boolean {
        return true;
    }

    public function update (dt :Number) :void {
    }

    public function get ticks () :Vector.<Vector.<AztecMessage>> {
        const toReturn :Vector.<Vector.<AztecMessage>> = _ticks;
        _ticks = new Vector.<Vector.<AztecMessage>>();
        return toReturn;
    }

    public function sendMessage (senderOid :int,  msg :AztecMessage) :void {
        msg.senderOid = senderOid;
        _matchObject.marshaller.sendMessage(msg);
    }

    protected var _matchObject :MatchObject;
    protected var _ticks :Vector.<Vector.<AztecMessage>> = new Vector.<Vector.<AztecMessage>>();

}
}
