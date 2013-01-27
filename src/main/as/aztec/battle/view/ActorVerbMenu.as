//
// aztec

package aztec.battle.view {

import aspire.util.StringUtil;

import flashbang.util.DisplayUtil;

import org.osflash.signals.Signal;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class ActorVerbMenu extends LocalSpriteObject
{
    public const verbSelected :Signal = new Signal(String);
    
    public function get canceled () :Signal {
        return _verbSelector.canceled;
    }
    
    public function ActorVerbMenu (verbNames :Vector.<String>) {
        _verbNames = verbNames;
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        
        // build the menu
        var textSprite :Sprite = new Sprite();
        var yOffset :Number = 0;
        var verbs :Array = [];
        for each (var verbName :String in _verbNames) {
            var verb :Verb = new Verb(verbName);
            verb.textSprite.y = yOffset;
            textSprite.addChild(verb.textSprite);
            
            verbs.push(verb);
            yOffset += verb.textSprite.height + 3;
        }
        
        const HMARGIN :int = 4;
        const VMARGIN :int = 6;
        
        var bg :DisplayObject = DisplayUtil.outlineFillRect(
            textSprite.width + (HMARGIN * 2),
            textSprite.height + (VMARGIN * 2),
            0xDEDC00,   // fill color
            2,
            0x000000);  // outline color
        _sprite.addChild(bg);
        
        textSprite.x = HMARGIN;
        textSprite.y = VMARGIN;
        _sprite.addChild(textSprite);
        
        // register the VerbSelector
        _verbSelector = new VerbSelector(_ctx, verbs);
        _regs.add(_ctx.keyboardInput.registerListener(_verbSelector));
        
        var self :ActorVerbMenu = this;
        _regs.addSignalListener(_verbSelector.selected, function (verb :Verb) :void {
            self.verbSelected.dispatch(verb.name);
        });
    }
    
    protected var _verbNames :Vector.<String>;
    protected var _verbSelector :VerbSelector;
}
}

import aspire.util.StringUtil;

import aztec.battle.BattleCtx;
import aztec.battle.Selectable;
import aztec.battle.TextSelector;
import aztec.battle.view.SelectableTextSprite;

class Verb
    implements Selectable
{
    public function Verb (name :String) {
        _name = name;
        _textSprite = new SelectableTextSprite(StringUtil.capitalize(name));
    }
    
    public function get name () :String {
        return _name;
    }
    
    public function get textSprite () :SelectableTextSprite {
        return _textSprite;
    }
    
    protected var _textSprite :SelectableTextSprite;
    protected var _name :String;
}

class VerbSelector extends TextSelector
{
    public function VerbSelector (ctx :BattleCtx, verbs :Array) {
        super(ctx.localPlayer.desc.color);
        _verbs = verbs;
    }
    
    override protected function getSelectables () :Array {
        return _verbs;
    }
    
    override protected function isValidSelectable (s :Selectable) :Boolean {
        return true;
    }
    
    protected var _verbs :Array;
}
