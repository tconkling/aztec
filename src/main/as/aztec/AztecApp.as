//
// Aztec

package aztec {

import aspire.util.Log;

import aztec.connect.ConnectMode;
import aztec.net.LoopbackMessageMgr;

import flashbang.core.Config;
import flashbang.core.FlashbangApp;

import aztec.debug.DebugOverlayMode;
import aztec.battle.BattleMode;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
public class AztecApp extends FlashbangApp
{
    override protected function run () :void {
        var rsrcs :AztecResources = new AztecResources();
        rsrcs.load(
            function () :void {
                createViewport("debug").pushMode(new DebugOverlayMode());
                if (Aztec.MULTIPLAYER) {
                    defaultViewport.pushMode(new ConnectMode());
                } else {
                    defaultViewport.pushMode(new BattleMode(new LoopbackMessageMgr(Aztec.NETWORK_UPDATE_RATE)));
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
