package aztec.battle.view {
import aztec.battle.God;
import aztec.battle.SelectableProvider;
import aztec.battle.desc.GameDesc;
import aztec.battle.desc.GameDesc;

import flashbang.objects.SpriteObject;
import flashbang.resource.MovieResource;

import flump.display.Movie;

public class HeartView extends LocalSpriteObject implements SelectableProvider {

    public function HeartView () {
        for (var ii :int = 0; ii < GameDesc.MAX_HEARTS; ii++) {
            var heart :Movie = MovieResource.createMovie("aztec/heart");
            heart.y = _hearts.length * -35;
            heart.alpha = .3;
            _hearts.push(heart);
            _sprite.addChildAt(heart,  0);
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
        for each (var god :God in God.values()) {
            if (GameDesc.godHearts(god) == _active) {
                var selectable :SelectableGod = new SelectableGod(god, function(god :God) :void {
                    _ctx.messages.summon(god);
                });
                _selectables.push(selectable);
                sprite.addChild(selectable.textSprite);
                selectable.textSprite.x = 30;
                selectable.textSprite.y = _hearts[_active - 1].y;
            }
        }
    }

    public function removeHeart () :void {
        for each (var god :God in God.values()) {
            if (GameDesc.godHearts(god) == _active) {
                var selectable :SelectableGod = _selectables.pop();
                sprite.removeChild(selectable.textSprite);
            }
        }
        _hearts[--_active].alpha = .3;
    }

    protected var _selectables :Array = [];
    protected var _active :int;
    protected var _hearts :Vector.<Movie> = new <Movie>[];
}
}

import aztec.battle.God;
import aztec.battle.Selectable;
import aztec.battle.view.SelectableTextSprite;

class SelectableGod
    implements Selectable
{
    public function SelectableGod (god :God, onSelected :Function) {
        _textSprite = new SelectableTextSprite(god.displayName);
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
