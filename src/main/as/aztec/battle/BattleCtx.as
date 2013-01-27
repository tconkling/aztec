//
// aztec

package aztec.battle {

import aspire.util.Random;
import aspire.util.Randoms;

import aztec.battle.controller.BattleBoard;
import aztec.battle.controller.NetObject;
import aztec.battle.controller.NetObjectDB;
import aztec.input.KeyboardInput;
import aztec.net.MessageMgr;

import flashbang.core.GameObject;

import starling.display.Sprite;

public class BattleCtx extends GameObject
{
    public var netObjects :NetObjectDB;
    public var viewObjects :BattleMode;
    
    public var messages :MessageMgr;
    
    public var board :BattleBoard;
    
    public var boardLayer :Sprite = new Sprite();
    public var uiLayer :Sprite = new Sprite();
    
    public var keyboardInput :KeyboardInput = new KeyboardInput();
    
    public function randomsFor (obj :GameObject) :Randoms {
        return (obj is NetObject ? _netRandoms : _viewRandoms);
    }
    
    protected var _netRandoms :Randoms = new Randoms(Random.create());
    protected var _viewRandoms :Randoms = new Randoms(Random.create());
}
}
