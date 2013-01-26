//
// aztec

package aztec.battle.ctx {

import starling.display.Sprite;

import flashbang.core.GameObject;

import aztec.battle.controller.BattleBoard;

public class BattleCtx extends GameObject
{
    public var boardLayer :Sprite = new Sprite();
    public var uiLayer :Sprite = new Sprite();
    
    public var board :BattleBoard;
}
}
