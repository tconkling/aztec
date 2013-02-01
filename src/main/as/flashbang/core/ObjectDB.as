//
// aztec

package flashbang.core {

import aspire.util.Preconditions;

public class ObjectDB extends AppMode
{
    public function ObjectDB () {
        _modeSprite = null;
    }

    public final function shutdown () :void {
        Preconditions.checkState(!_destroyed, "already destroyed");
        _destroyed = true;

        var ref :GameObjectRef = _listHead;
        while (null != ref) {
            if (!ref.isNull) {
                var obj :GameObject = ref._obj;
                ref._obj = null;
                obj.cleanupInternal();
            }

            ref = ref._next;
        }

        _listHead = null;
        _objectCount = 0;
        _objectsPendingRemoval = null;
        _namedObjects = null;
        _groupedObjects = null;

        _regs.cancel();
        _regs = null;
    }

    override protected final function setup () :void {
        throw new Error("ObjectDB may not be added to a modestack");
    }

    override protected final function destroy () :void {
        // this will never be called.
    }
}
}
