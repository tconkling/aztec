//
// aztec

package aztec.view {

import flash.geom.Point;
import flash.geom.Rectangle;

import starling.display.Sprite;
import starling.events.Touch;

import aspire.geom.Vector2;

import flashbang.objects.SpriteObject;

public class BoardView extends SpriteObject
{
    public function BoardView (tileSizePx :Vector2, viewSizePx :Vector2) {
        _tileSizePx = tileSizePx.clone();
        _viewBounds = new Rectangle(0, 0, viewSizePx.x / tileSizePx.x,
            viewSizePx.y / tileSizePx.y);
        _sprite.addChild(_scroller);
    }
    
    public function localToBoard (v :Vector2, out :Vector2 = null) :Vector2 {
        out = (out || new Vector2());
        out.set(Math.floor(v.x / _tileSizePx.x), Math.floor(v.y / _tileSizePx.y));
        return out;
    }
    
    public function boardToLocal (v :Vector2, out :Vector2 = null) :Vector2 {
        out = (out || new Vector2());
        out.set((v.x + 0.5) * _tileSizePx.x, (v.y + 0.5) * _tileSizePx.y);
        return out;
    }
    
    public function screenToLocal (v :Vector2, out :Vector2 = null) :Vector2 {
        return Vector2.fromPoint(
            this.objectRootLayer.globalToLocal(v.toPoint(P)),
            out);
    }
    
    public function localToScreen (v :Vector2, out :Vector2 = null) :Vector2 {
        return Vector2.fromPoint(
            this.objectRootLayer.localToGlobal(v.toPoint(P)),
            out);
    }
    
    public function screenToBoard (v :Vector2, out :Vector2 = null) :Vector2 {
        out = (out || new Vector2());
        return localToBoard(screenToLocal(v, out), out);
    }
    
    public function boardToScreen (v :Vector2, out :Vector2 = null) :Vector2 {
        out = (out || new Vector2());
        return localToScreen(boardToLocal(v, out), out);
    }
    
    public function touchToBoard (t :Touch, out :Vector2 = null) :Vector2 {
        V.set(t.globalX, t.globalY);
        return screenToBoard(V, out);
    }
    
    public function touchToLocal (t :Touch, out :Vector2 = null) :Vector2 {
        V.set(t.globalX, t.globalY);
        return screenToLocal(V, out);
    }
    
    public function get tileSizePx () :Vector2 {
        return _tileSizePx;
    }
    
    public function get viewBounds () :Rectangle {
        return _viewBounds;
    }
    
    public function get viewWidthPx () :Number {
        return _tileSizePx.x * _viewBounds.width;
    }
    
    public function get viewHeightPx () :Number {
        return _tileSizePx.y * _viewBounds.height;
    }
    
    public function get xScroll () :Number {
        return _viewBounds.x;
    }
    
    public function get yScroll () :Number {
        return _viewBounds.y;
    }
    
    public function set xScroll (val :Number) :void {
        setScroll(val, _viewBounds.y);
    }
    
    public function set yScroll (val :Number) :void {
        setScroll(_viewBounds.x, val);
    }
    
    public function setScroll (xScroll :Number, yScroll :Number) :void {
        if (_viewBounds.x != xScroll) {
            _viewBounds.x = xScroll;
            _scroller.x = -_viewBounds.x * _tileSizePx.x;
        }
        
        if (_viewBounds.y != yScroll) {
            _viewBounds.y = yScroll;
            _scroller.y = -_viewBounds.y * _tileSizePx.y;
        }
    }
    
    public function get objectRootLayer () :Sprite {
        return _scroller;
    }
    
    protected var _tileSizePx :Vector2;
    protected var _viewBounds :Rectangle;
    protected var _scroller :Sprite = new Sprite();
    
    // scratch objects
    protected static var P :Point = new Point();
    protected static var V :Vector2 = new Vector2();
}
}

