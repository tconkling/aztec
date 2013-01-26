//
// aztec

package aztec.battle {

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;

import aspire.util.Preconditions;

import flashbang.core.AppMode;
import flashbang.core.GameObject;
import flashbang.core.GameObjectRef;

import aztec.battle.controller.BattleBoard;
import aztec.battle.controller.BattleObject;
import aztec.battle.controller.BattleObjectDB;
import aztec.battle.view.BattleBoardView;

public class BattleMode extends AppMode
{
    override protected function setup () :void {
        // layers
        _modeSprite.addChild(_boardLayer);
        _modeSprite.addChild(_uiLayer);
        
        // all the network-synced objects live in here
        _battleObjects = new BattleObjectDB();
        
        // board
        var board :BattleBoard = new BattleBoard();
        _battleObjects.addObject(board);
        _boardView = new BattleBoardView(board);
        addObject(_boardView, _boardLayer);
    }
    
    override protected function beginUpdate (dt :Number) :void {
        super.beginUpdate(dt);
        _boardView.depthSort();
    }
    
    override public function addObject (obj :GameObject,
        displayParent :DisplayObjectContainer = null,
        displayIdx :int = -1) :GameObjectRef {
        
        Preconditions.checkArgument(!(obj is BattleObject),
            "BattleObjects must be added to the BattleObjectDB");
        return super.addObject(obj, displayParent, displayIdx);
    }
    
    protected var _boardLayer :Sprite = new Sprite();
    protected var _uiLayer :Sprite = new Sprite();
    
    protected var _battleObjects :BattleObjectDB;
    
    protected var _boardView :BattleBoardView;
}
}
