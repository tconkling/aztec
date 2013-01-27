//
// aztec

package aztec.battle {

import aspire.util.Random;
import aspire.util.Randoms;

import aztec.battle.controller.Affinity;
import aztec.battle.controller.BattleBoard;
import aztec.battle.controller.NetObject;
import aztec.battle.controller.NetObjectDB;
import aztec.battle.controller.Player;
import aztec.input.KeyboardInput;

import flashbang.core.GameObject;

import starling.display.Sprite;

public class BattleCtx extends GameObject
{
    public function BattleCtx (netRandomSeed :int) {
        _netRandoms = new Randoms(new Random(netRandomSeed));
    }

    public var localPlayer :Player;
    
    public var players :Vector.<Player> = new Vector.<Player>(2, true);
    public var affinity :Affinity;
    
    public var netObjects :NetObjectDB;
    public var viewObjects :BattleMode;
    
    public var messages :BattleMessages;

    public var selector :TextSelector;
    
    public var board :BattleBoard;
    
    public var commandGenerator :VillagerCommandGenerator;
    
    public var boardLayer :Sprite = new Sprite();
    public var uiLayer :Sprite = new Sprite();
    public var effectLayer :Sprite = new Sprite();
    
    public var keyboardInput :KeyboardInput = new KeyboardInput();
    
    public function randomsFor (obj :GameObject) :Randoms {
        return (obj is NetObject ? _netRandoms : _viewRandoms);
    }
    
    protected var _netRandoms :Randoms;
    protected var _viewRandoms :Randoms = new Randoms(Random.create());
}
}
