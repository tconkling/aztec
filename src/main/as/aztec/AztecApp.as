//
// Aztec

package aztec {

import aspire.util.Log;

import flashbang.core.Config;
import flashbang.core.FlashbangApp;

import aztec.debug.DebugOverlayMode;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
public class AztecApp extends FlashbangApp
{
    override protected function run () :void {
        var rsrcs :AztecResources = new AztecResources();
        rsrcs.load(
            function () :void {
                createViewport("debug").pushMode(new DebugOverlayMode());
                //defaultViewport.changeMode(new ServerDebugMode());
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
