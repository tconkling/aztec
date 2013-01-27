//
// aztec

package aztec.battle.view {

import aspire.util.StringUtil;

import aztec.input.KeyboardListener;

import flashbang.util.DisplayUtil;

import org.osflash.signals.Signal;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.KeyboardEvent;

public class ActorVerbMenu extends LocalSpriteObject
    implements KeyboardListener
{
    public const canceled :Signal = new Signal();
    public const verbSelected :Signal = new Signal(String);
    
    public function ActorVerbMenu (verbs :Vector.<String>) {
        _verbs = verbs;
        
        var textSprite :Sprite = new Sprite();
        var yOffset :Number = 0;
        for each (var verb :String in verbs) {
            var tf :SelectableTextSprite = new SelectableTextSprite(StringUtil.capitalize(verb));
            tf.y = yOffset;
            textSprite.addChild(tf);
            
            _textSprites.push(tf);
            yOffset += tf.height + 3;
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
    }
    
    public function onKeyboardEvent (k :KeyboardEvent) :Boolean {
        if (k.type != KeyboardEvent.KEY_DOWN) {
            return false;
        }
        return true;
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        _regs.add(_ctx.keyboardInput.registerListener(this));
    }
    
    protected var _textSprites :Vector.<SelectableTextSprite> = new <SelectableTextSprite>[];
    protected var _verbs :Vector.<String>;
}
}
