//
// aztec

package aztec.battle.view {

import aztec.battle.SelectableProvider;
import aztec.battle.VillagerAction;
import aztec.battle.VillagerCommand;

import flashbang.util.DisplayUtil;

import org.osflash.signals.Signal;

import starling.display.Sprite;

public class VillagerCommandMenu extends LocalSpriteObject implements SelectableProvider
{
    public const actionSelected :Signal = new Signal(VillagerAction);
    
    public function VillagerCommandMenu (commands :Array) {
        _commands = commands;
    }

    public function get selectables():Array {
        return _commands;
    }

    public function get isExclusive():Boolean {
        return true;
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        // build command views
        
        // make the VillagerCommands selectable
        _commands = _commands.map(function (cmd :VillagerCommand, ..._) :SelectableCommand {
            return new SelectableCommand(cmd, actionSelected.dispatch);
        });
        
        for each (var cmd :SelectableCommand in _commands) {
            var textSprite :SelectableTextSprite = cmd.textSprite;
            
            const HMARGIN :int = 8;
            const VMARGIN :int = 12;
            
            var bg :Sprite = DisplayUtil.outlineFillRect(
                textSprite.width + (HMARGIN * 2),
                textSprite.height + (VMARGIN * 2),
                0x707070,   // fill color
                2,
                0x000000);  // outline color
            textSprite.x = HMARGIN;
            textSprite.y = VMARGIN;
            bg.addChild(textSprite);
            
            _sprite.addChild(bg);
            bg.x = cmd.loc.x - (bg.width * 0.5);
            bg.y = cmd.loc.y - (bg.height * 0.5);
        }

        _regs.add(_ctx.selector.registerProvider(this));
        _regs.addSignalListener(_ctx.selector.canceled, destroySelf);
    }

    protected var _commands :Array;
}
}

import aztec.battle.Selectable;
import aztec.battle.VillagerCommand;
import aztec.battle.view.SelectableTextSprite;

import starling.text.TextFieldAutoSize;

class SelectableCommand extends VillagerCommand
    implements Selectable
{
    public function SelectableCommand (cmd :VillagerCommand, onSelected :Function) {
        super(cmd.action, cmd.text, cmd.loc);
        _textSprite = new SelectableTextSprite(cmd.text, "herculanum", 18, TextFieldAutoSize.MULTI_LINE, 400);
        _onSelected = onSelected;
    }
    
    public function get textSprite () :SelectableTextSprite {
        return _textSprite;
    }

    public function get isSelectable () :Boolean {
        return true;
    }

    public function markSelected():void {
        _onSelected(action);
    }

    protected var _onSelected :Function;
    protected var _textSprite :SelectableTextSprite;
}
