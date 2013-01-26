//
// aztec

package aztec.battle.controller {

import starling.display.Sprite;

import flashbang.core.GameObject;

import aztec.battle.BattleMode;
import aztec.net.MessageMgr;

public class BattleCtx extends GameObject
{
    public var netObjects :BattleObjectDB;
    public var viewObjects :BattleMode;
    
    public var messages :MessageMgr;
    
    public var board :BattleBoard;
    
    public var boardLayer :Sprite = new Sprite();
    public var uiLayer :Sprite = new Sprite();
}
}
