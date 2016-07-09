//
// aztec

package flashbang.core {

import aspire.util.Preconditions;

public class ObjectDB extends AppMode {
    public function ObjectDB () {
        _modeSprite = null;
    }

    public function doUpdate (dt :Number) :void {
        _runningTime += dt;
        // update all Updatable objects
        _update.emit(dt);
    }

    public final function shutdown () :void {
        Preconditions.checkState(!_disposed, "already destroyed");
        _disposed = true;

        _rootObject.disposeInternal();
        _rootObject = null;

        _deadGroupedObjects = null;
        _idObjects = null;
        _groupedObjects = null;

        _regs.close();
        _regs = null;

        _modeStack = null;
    }

    override protected final function setup () :void {
        throw new Error("ObjectDB may not be added to a modestack");
    }

    override protected final function dispose () :void {
        // this will never be called.
    }
}
}
