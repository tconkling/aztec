//
// aztec

package aztec.battle.view {

import aztec.battle.Selectable;
import aztec.battle.SelectableProvider;
import aztec.battle.VillagerAction;
import aztec.battle.VillagerCommand;

import flashbang.util.DisplayUtil;

import org.osflash.signals.Signal;

import starling.display.Quad;

public class VillagerCommandMenu extends LocalSpriteObject implements SelectableProvider
{
    public const actionSelected :Signal = new Signal(VillagerAction);
    
    public function VillagerCommandMenu (commands :Array) {
        _commands = commands;
        
        var bg :Quad = DisplayUtil.fillRect(1024, 768, 0);
        bg.alpha = 0.6;
        _sprite.addChild(bg);
    }

    public function get selectables():Array {
        return _commandSprites;
    }

    public function get isExclusive():Boolean {
        return true;
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        // build command views
        
        _commandSprites = _commands.map(function (cmd :VillagerCommand, ..._) :CommandSprite {
            var cmdSprite :CommandSprite = new CommandSprite(cmd, actionSelected.dispatch);
            _sprite.addChild(cmdSprite);
            return cmdSprite;
        });

        _regs.add(_ctx.selector.registerProvider(this));
        _regs.addSignalListener(_ctx.selector.selectionBegan, function (s :Selectable) :void {
            if (s is CommandSprite) {
                CommandSprite(s).expanded = true;
            }
        });
        _regs.addSignalListener(_ctx.selector.selectionCanceled, function (s :Selectable) :void {
            if (s is CommandSprite) {
                CommandSprite(s).expanded = false;
            }
        });
        _regs.addSignalListener(_ctx.selector.canceled, destroySelf);
    }

    protected var _commands :Array;
    protected var _commandSprites :Array;
}
}

import aztec.Aztec;
import aztec.battle.Selectable;
import aztec.battle.VillagerCommand;
import aztec.battle.view.SelectableTextSprite;

import flashbang.resource.MovieResource;
import flashbang.util.DisplayUtil;

import flump.display.Movie;

import starling.display.Sprite;
import starling.text.TextFieldAutoSize;

class CommandSprite extends Sprite
    implements Selectable
{
    public var cmd :VillagerCommand;
    
    public function CommandSprite (cmd :VillagerCommand, onSelected :Function) {
        this.cmd = cmd;
        _onSelected = onSelected;
        
        _textSprite = new SelectableTextSprite(cmd.text, Aztec.COMMAND_FONT, 18,
            TextFieldAutoSize.MULTI_LINE, 400);
        
        redraw();
    }
    
    public function get textSprite () :SelectableTextSprite {
        return _textSprite;
    }
    
    public function get isSelectable () :Boolean {
        return true;
    }
    
    public function markSelected():void {
        _onSelected(cmd.action);
    }
    
    public function get expanded () :Boolean {
        return _expanded;
    }
    
    public function set expanded (val :Boolean) :void {
        if (_expanded != val) {
            _expanded = val;
            this.parent.setChildIndex(this, parent.numChildren - 1);
            redraw();
        }
    }
    
    protected function redraw () :void {
        removeChildren();
        
        _textSprite.text =
            (_expanded || cmd.text.length <= 35 ? cmd.text : cmd.text.substr(0, 35) + "...");
        
        const HMARGIN :int = 8;
        const VMARGIN :int = 12;
        
        var bg :Sprite = DisplayUtil.outlineFillRect(
            _textSprite.width + (HMARGIN * 2),
            _textSprite.height + (VMARGIN * 2),
            0xb1926d,   // fill color
            2,
            0x8b6444);  // outline color
        textSprite.x = HMARGIN;
        textSprite.y = VMARGIN;
        bg.addChild(_textSprite);
        
        var header :Movie = MovieResource.createMovie(cmd.action.promptName);
        bg.addChild(header);
        
        addChild(bg);
        
        this.x = cmd.loc.x;
        this.y = cmd.loc.y;
    }
    
    protected var _onSelected :Function;
    protected var _textSprite :SelectableTextSprite;
    protected var _expanded :Boolean;
}
