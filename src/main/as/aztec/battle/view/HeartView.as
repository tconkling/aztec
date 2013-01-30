package aztec.battle.view {
import aztec.battle.God;
import aztec.battle.SelectableProvider;
import aztec.battle.desc.GameDesc;

import flashbang.resource.MovieResource;

import flump.display.Movie;

public class HeartView extends LocalSpriteObject implements SelectableProvider {

    public function HeartView (forLocalPlayer :Boolean, textToRight :Boolean) {
        _forLocalPlayer = forLocalPlayer;
        for (var ii :int = 0; ii < GameDesc.MAX_HEARTS; ii++) {
            var heart :Movie = MovieResource.createMovie("aztec/heart");
            heart.y = _hearts.length * -35;
            heart.alpha = DISABLED_ALPHA;
            _hearts.push(heart);
            _sprite.addChildAt(heart,  0);
        }
        
        if (forLocalPlayer) {
            for each (var god :God in God.values()) {
                var textSprite :SelectableTextSprite = new SelectableTextSprite(god.displayName);
                if (textToRight) {
                    textSprite.x = 30;
                } else {
                    textSprite.x = -_hearts[0].width - textSprite.width + 10;
                }
                textSprite.y = _hearts[GameDesc.godHearts(god) - 1].y;
                textSprite.alpha = DISABLED_ALPHA;
                _sprite.addChild(textSprite);
                _godNameTextFields.push(textSprite);
            }
        }
    }

    override protected function addedToMode():void {
        super.addedToMode();

        _regs.add(_ctx.selector.registerProvider(this));
    }

    public function get selectables():Array {
        return _selectables;
    }

    public function get isExclusive():Boolean {
        return false;
    }

    public function addHeart () :void {
        _hearts[_active++].alpha = 1;
        if (!_forLocalPlayer) { return; }
        for each (var god :God in God.values()) {
            if (GameDesc.godHearts(god) == _active) {
                var textSprite :SelectableTextSprite = _godNameTextFields[god.ordinal()];
                textSprite.alpha = 1.0;
                var selectable :SelectableGod =
                    new SelectableGod(god, textSprite, _ctx.messages.summon)
                _selectables.push(selectable);
            }
        }
    }

    public function removeHeart () :void {
        if (_forLocalPlayer) {
            for each (var god :God in God.values()) {
                if (GameDesc.godHearts(god) == _active) {
                    var selectable :SelectableGod = _selectables.pop();
                    selectable.textSprite.deselect();
                    selectable.textSprite.alpha = DISABLED_ALPHA;
                }
            }
        }
        _hearts[--_active].alpha = DISABLED_ALPHA;
    }

    protected var _selectables :Array = [];
    protected var _godNameTextFields :Array = [];
    protected var _active :int;
    protected var _hearts :Vector.<Movie> = new <Movie>[];
    protected var _forLocalPlayer :Boolean;
    
    protected static const DISABLED_ALPHA :Number = 0.3;
}
}

import aztec.battle.God;
import aztec.battle.Selectable;
import aztec.battle.view.SelectableTextSprite;

class SelectableGod
    implements Selectable
{
    public function SelectableGod (god :God, textSprite :SelectableTextSprite, onSelected :Function) {
        _textSprite = textSprite;
        _onSelected = onSelected;
        _god = god;
    }

    public function get textSprite () :SelectableTextSprite {
        return _textSprite;
    }

    public function get isSelectable () :Boolean {
        return true;
    }

    public function markSelected():void {
        _onSelected(_god);
    }

    protected var _god :God;
    protected var _onSelected :Function;
    protected var _textSprite :SelectableTextSprite;
}
