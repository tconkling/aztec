//
// Aztec

package aztec {

import aspire.util.Cloneable;
import aspire.util.DelayUtil;
import aspire.util.Log;
import aspire.util.Randoms;

import aztec.battle.BattleMode;
import aztec.battle.controller.Player;
import aztec.battle.desc.GameDesc;
import aztec.connect.ConnectMode;
import aztec.debug.DebugOverlayMode;
import aztec.net.LoopbackMessageMgr;
import aztec.text.CustomFontLoader;

import flash.display.DisplayObject;
import flash.events.Event;

import flashbang.core.Config;
import flashbang.core.Flashbang;
import flashbang.core.FlashbangApp;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
public class AztecApp extends FlashbangApp
{
    // classes needed by the network code
    Cloneable;

    public function AztecApp (splashScreen :DisplayObject = null) {
        _splashScreen = splashScreen;
        if (_splashScreen != null) {
            addChild(splashScreen);
        }
    }

    public function get active () :Boolean {
        return _active;
    }

    override protected function run () :void {
        // scale our content if we're running in a scaled-down wrapper
        _mainSprite.scaleX = _mainSprite.scaleY = Math.min(
            this.stage.stageWidth / this.config.windowWidth,
            this.stage.stageHeight / this.config.windowHeight);

        Flashbang.rsrcs.registerResourceLoader("customFont", CustomFontLoader);

        Aztec.newGameCondition = NewGameCondition.INITIAL;

        addEventListener(Event.ACTIVATE, function (event:Event) :void {
            _active = true;
        });
        addEventListener(Event.DEACTIVATE, function (event: Event) :void {
            _active = false;
        });

        var rsrcs :AztecResources = new AztecResources();
        rsrcs.load(
            function () :void {
                if (Aztec.DEBUG) {
                    createViewport("debug").pushMode(new DebugOverlayMode());
                }
                defaultViewport.pushMode(new ConnectMode());
                if (!Aztec.MULTIPLAYER) {
                    var player1 :Player = new Player(1, "Tim", GameDesc.player1, true);
                    var player2 :Player = new Player(2, "Charlie", GameDesc.player2, false);
                    defaultViewport.pushMode(new BattleMode(player1, player2,
                        new Randoms().getInt(1000),
                        new LoopbackMessageMgr(Aztec.NETWORK_UPDATE_RATE)));
                }

                // remove the splash screen after a frame
                if (_splashScreen != null) {
                    DelayUtil.delayFrame(function () :void {
                        _splashScreen.parent.removeChild(_splashScreen);
                        _splashScreen = null;
                    });
                }
            },
            function (e :Error) :void {
                Log.getLog(AztecApp).error("Error loading resources", e);
            });
    }

    override protected function createConfig () :Config {
        var config :Config = new Config();
        config.stageWidth = config.windowWidth = Aztec.WIDTH;
        config.stageHeight = config.windowHeight = Aztec.HEIGHT;
        return config;
    }

    protected var _active :Boolean = true;
    protected var _splashScreen :DisplayObject;
}
}
