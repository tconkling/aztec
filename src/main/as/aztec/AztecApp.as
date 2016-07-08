//
// Aztec

package aztec {

import aspire.util.Cloneable;
import aspire.util.Log;
import aspire.util.Randoms;

import aztec.battle.BattleMode;
import aztec.battle.controller.Player;
import aztec.battle.desc.GameDesc;
import aztec.connect.ConnectMode;
import aztec.net.LoopbackMessageMgr;
import aztec.text.CustomFontLoader;

import flash.display.DisplayObject;
import flash.events.Event;

import flashbang.core.Flashbang;
import flashbang.core.FlashbangApp;
import flashbang.core.FlashbangConfig;
import flashbang.util.Timers;

import starling.utils.Align;

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
        rsrcs.load()
            .onSuccess(function () :void {
                if (Aztec.DEBUG) {
                    this.starling.showStatsAt(Align.RIGHT, Align.TOP, 0.5);
                    this.starling.showStats = true;
                }
                _modeStack.pushMode(new ConnectMode());
                if (!Aztec.MULTIPLAYER) {
                    var player1 :Player = new Player(1, "Tim", GameDesc.player1, true);
                    var player2 :Player = new Player(2, "Charlie", GameDesc.player2, false);
                    _modeStack.pushMode(new BattleMode(player1, player2,
                        new Randoms().getInt(1000),
                        new LoopbackMessageMgr(Aztec.NETWORK_UPDATE_RATE)));
                }

                // remove the splash screen after a frame
                if (_splashScreen != null) {
                    Timers.delayFrame(function () :void {
                        _splashScreen.parent.removeChild(_splashScreen);
                        _splashScreen = null;
                    });
                }
            })
            .onFailure(function (e :Error) :void {
                Log.getLog(AztecApp).error("Error loading resources", e);
            });
    }

    override protected function createConfig () :FlashbangConfig {
        var config :FlashbangConfig = new FlashbangConfig();
        config.stageWidth = config.windowWidth = Aztec.WIDTH;
        config.stageHeight = config.windowHeight = Aztec.HEIGHT;
        return config;
    }

    protected var _active :Boolean = true;
    protected var _splashScreen :DisplayObject;
}
}
