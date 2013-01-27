//
// Aztec

package aztec {

import aspire.util.Cloneable;
import aspire.util.Log;

import flashbang.core.Config;
import flashbang.core.FlashbangApp;

import aztec.battle.BattleMode;
import aztec.connect.ConnectMode;
import aztec.debug.DebugOverlayMode;
import aztec.net.LoopbackMessageMgr;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
public class AztecApp extends FlashbangApp
{
    // classes needed by the network code
    Cloneable;
    
    override protected function run () :void {
        var rsrcs :AztecResources = new AztecResources();
        rsrcs.load(
            function () :void {
                createViewport("debug").pushMode(new DebugOverlayMode());
                if (Aztec.MULTIPLAYER) {
                    defaultViewport.pushMode(new ConnectMode());
                } else {
                    defaultViewport.pushMode(new BattleMode(Aztec.rands.getInt(1000), new LoopbackMessageMgr(Aztec.NETWORK_UPDATE_RATE)));
                }
            },
            function (e :Error) :void {
                Log.getLog(AztecApp).error("Error loading resources", e);
            });
    }
    
    override protected function createConfig () :Config {
        var config :Config = new Config();
        config.stageWidth = config.windowWidth = 1024;
        config.stageHeight = config.windowHeight = 768;
        return config;
    }
}
}
