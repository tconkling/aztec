//
// aztec

package aztec.battle.view {

import aztec.battle.VillagerAction;
import aztec.battle.VillagerCommand;

import flashbang.util.DisplayUtil;

import org.osflash.signals.Signal;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class VillagerCommandMenu extends LocalSpriteObject
{
    public const actionSelected :Signal = new Signal(VillagerAction);
    
    public function get canceled () :Signal {
        return _commandSelector.canceled;
    }
    
    public function VillagerCommandMenu (commands :Array) {
        _commands = commands;
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        // build command views
        
        // make the VillagerCommands selectable
        _commands = _commands.map(function (cmd :VillagerCommand, ..._) :SelectableCommand {
            return new SelectableCommand(cmd);
        });
        
        for each (var cmd :SelectableCommand in _commands) {
            var textSprite :SelectableTextSprite = cmd.textSprite;
            
            const HMARGIN :int = 8;
            const VMARGIN :int = 12;
            
            var bg :Sprite = DisplayUtil.outlineFillRect(
                textSprite.width + (HMARGIN * 2),
                textSprite.height + (VMARGIN * 2),
                0xDEDC00,   // fill color
                2,
                0x000000);  // outline color
            textSprite.x = HMARGIN;
            textSprite.y = VMARGIN;
            bg.addChild(textSprite);
            
            _sprite.addChild(bg);
            bg.x = cmd.loc.x - (bg.width * 0.5);
            bg.y = cmd.loc.y - (bg.height * 0.5);
        }
        
        // register the selector
        _commandSelector = new CommandSelector(_ctx, _commands);
        _regs.add(_ctx.keyboardInput.registerListener(_commandSelector));
        
        var self :VillagerCommandMenu = this;
        _regs.addSignalListener(_commandSelector.selected, function (cmd :VillagerCommand) :void {
            self.actionSelected.dispatch(cmd.action);
        });
    }
    
    protected var _commands :Array;
    protected var _commandSelector :CommandSelector;
}
}

import aztec.battle.BattleCtx;
import aztec.battle.Selectable;
import aztec.battle.TextSelector;
import aztec.battle.VillagerCommand;
import aztec.battle.view.SelectableTextSprite;

class SelectableCommand extends VillagerCommand
    implements Selectable
{
    public function SelectableCommand (cmd :VillagerCommand) {
        super(cmd.action, cmd.text, cmd.loc);
        _textSprite = new SelectableTextSprite(cmd.text);
    }
    
    public function get textSprite () :SelectableTextSprite {
        return _textSprite;
    }
    
    protected var _textSprite :SelectableTextSprite;
}

class CommandSelector extends TextSelector
{
    public function CommandSelector (ctx :BattleCtx, commands :Array) {
        super(ctx.localPlayer.desc.color);
        _commands = commands;
    }
    
    override protected function getSelectables () :Array {
        return _commands;
    }
    
    override protected function isValidSelectable (s :Selectable) :Boolean {
        return true;
    }
    
    protected var _commands :Array;
}
