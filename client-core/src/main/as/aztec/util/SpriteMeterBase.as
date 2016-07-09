//
// aztec

package aztec.util {

import aspire.util.MathUtil;

import starling.display.Sprite;

public class SpriteMeterBase extends Sprite
    implements Meter
{
    public final function draw () :void {
        if (_needsDisplayUpdate) {
            _needsDisplayUpdate = false;
            updateDisplay();
        }
    }

    public function get maxValue () :Number {
        return _maxValue;
    }

    public function set maxValue (val :Number) :void {
        if (_maxValue != val) {
            _maxValue = val;
            _minValue = Math.min(_minValue, _maxValue);
            _value = MathUtil.clamp(_value, _minValue, _maxValue);
            _needsDisplayUpdate = true;
        }
    }

    public function get minValue () :Number {
        return _minValue;
    }

    public function set minValue (val :Number) :void {
        if (_minValue != val) {
            _minValue = val;
            _maxValue = Math.max(_maxValue, _minValue);
            _value = MathUtil.clamp(_value, _minValue, _maxValue);
            _needsDisplayUpdate = true;
        }
    }

    public function get value () :Number {
        return _value;
    }

    public function set value (val :Number) :void {
        val = MathUtil.clamp(val, _minValue, _maxValue);
        if (_value != val) {
            _value = val;
            _needsDisplayUpdate = true;
        }
    }

    protected function get normalizedValue () :Number {
        var denom :Number = (_maxValue - _minValue);
        return (denom != 0 ? (_value - _minValue) / denom : 0);
    }

    /** Subclasses override */
    protected function updateDisplay () :void {
    }

    protected var _maxValue :Number = 0;
    protected var _minValue :Number = 0;
    protected var _value :Number = 0;

    protected var _needsDisplayUpdate :Boolean = true;
}
}
