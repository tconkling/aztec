//
// aztec

package aztec.battle.view {

import aztec.battle.God;
import aztec.battle.SelectableProvider;
import aztec.battle.desc.GameDesc;

import flashbang.objects.SceneObject;
import flashbang.resource.MovieResource;
import flashbang.tasks.AnimateValueTask;
import flashbang.tasks.RepeatingTask;
import flashbang.tasks.TimedTask;
import flashbang.util.BoxedNumber;
import flashbang.util.Easing;

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
                var obj :SceneObject = new SceneObject(textSprite);
                addDependentObject(obj, _sprite);
                _godNameObjects.push(obj);
            }
        }
    }

    public function get selectables():Array {
        return _selectables;
    }

    public function get isExclusive():Boolean {
        return false;
    }

    public function get hearts () :int {
        return _numHearts;
    }

    public function set hearts (val :int) :void {
        if (_numHearts == val) {
            return;
        }
        var origHearts :int = _numHearts;
        _numHearts = val;

        var ii :int = 0;
        for (ii = 0; ii < _hearts.length; ++ii) {
            _hearts[ii].alpha = (_numHearts > ii ? 1 : DISABLED_ALPHA);
        }
        updateHeartPulse();

        if (_forLocalPlayer) {
            var gods :Array = God.values();
            for (ii = 0; ii < gods.length; ++ii) {
                var god :God = gods[ii];
                var textSpriteObj :SceneObject = _godNameObjects[ii];
                var textSprite :SelectableTextSprite = SelectableTextSprite(textSpriteObj.display);
                var requiredHearts :int = GameDesc.godHearts(god);
                var wasActive :Boolean = origHearts >= requiredHearts;
                var active :Boolean = _numHearts >= requiredHearts;
                textSprite.alpha = (active ? 1 : DISABLED_ALPHA);

                //const GOD_PULSE :String = "GodPulse";
                if (active && !wasActive) {
                    /*textSpriteObj.addNamedTask(GOD_PULSE, new SerialTask(
                        new ScaleTask(2, 2, 0.25, Easing.easeIn),
                        new TimedTask(1),
                        new ScaleTask(1, 1, 0.1, Easing.easeOut)));*/
                    _selectables.push(new SelectableGod(god, textSprite, _ctx.messages.summon));

                } else if (!active && wasActive) {
                    //textSpriteObj.removeNamedTasks(GOD_PULSE);
                    //textSprite.scaleX = textSprite.scaleY = 1;
                    _selectables.pop();
                }

                if (_numHearts < origHearts) {
                    textSprite.deselect();
                }
            }
        }
    }

    protected function updateHeartPulse () :void {
        const HEART_PULSE :String = "HeartPulse";

        removeNamedTasks(HEART_PULSE);
        _pulse.value = 1;

        if (_numHearts > 0) {
            const MIN_DELAY :Number = 0;
            const MAX_DELAY :Number = 1;
            var m :Number = (GameDesc.MAX_HEARTS - _numHearts) / GameDesc.MAX_HEARTS;
            var delay :Number = MIN_DELAY + (m * (MAX_DELAY - MIN_DELAY));
            addNamedTask(HEART_PULSE, new RepeatingTask(
                new AnimateValueTask(_pulse, 1.2, 0.25, Easing.easeIn),
                new AnimateValueTask(_pulse, 1, 0.1, Easing.easeOut),
                new TimedTask(delay)));
        }
    }

    override protected function update (dt :Number) :void {
        for (var ii :int = 0; ii < _hearts.length; ++ii) {
            var heart :Movie = _hearts[ii];
            heart.scaleX = heart.scaleY = (_numHearts > ii ? _pulse.value : 1);
        }
    }

    override protected function addedToMode():void {
        super.addedToMode();

        _regs.add(_ctx.selector.registerProvider(this));
    }

    protected var _selectables :Array = [];
    protected var _godNameObjects :Vector.<SceneObject> = new <SceneObject>[];
    protected var _numHearts :int;
    protected var _hearts :Vector.<Movie> = new <Movie>[];
    protected var _forLocalPlayer :Boolean;

    protected var _pulse :BoxedNumber = new BoxedNumber(1);

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
