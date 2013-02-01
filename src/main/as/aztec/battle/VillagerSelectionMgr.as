//
// aztec

package aztec.battle {

import aspire.util.F;
import aspire.util.RegistrationList;

import aztec.battle.controller.Villager;

import flashbang.util.ListenerRegistrations;

import org.osflash.signals.Signal;

public class VillagerSelectionMgr extends LocalObject
    implements SelectableProvider
{
    public const emphasizedVillagerChanged :Signal = new Signal(Villager);

    public function VillagerSelectionMgr () {
        _regs.add(_villagerRegs);
    }

    public function get emphasizedVillager () :Villager {
        return _emphasizedVillager;
    }

    public function get selectables () :Array {
        return Villager.getAll(_ctx);
    }

    public function get isExclusive() :Boolean {
        return false;
    }

    override public function get objectNames () :Array {
        return [ NAME ].concat(super.objectNames);
    }

    override protected function addedToMode () :void {
        super.addedToMode();

        _ctx.villagerSelectionMgr = this;

        _regs.add(_ctx.selector.registerProvider(this));
        _regs.addSignalListener(_ctx.selector.selectionBegan, function (s :Selectable) :void {
            if (s is Villager) {
                onSelectionBegan(Villager(s));
            }
        });
        _regs.addSignalListener(_ctx.selector.selectionCanceled, function (s :Selectable) :void {
            if (s is Villager) {
                onSelectionEnded(Villager(s));
            }
        });
    }

    protected function onSelectionBegan (v :Villager) :void {
        setEmphasizedVillager(v);
        _villagerRegs.addSignalListener(v.destroyed, F.callback(onSelectionEnded, v));
        _villagerRegs.addSignalListener(v.deselected, F.callback(onSelectionEnded, v));
    }

    protected function onSelectionEnded (v :Villager) :void {
        if (_emphasizedVillager == v) {
            setEmphasizedVillager(null);
        }
    }

    protected function setEmphasizedVillager (v :Villager) :void {
        if (_emphasizedVillager != v) {
            _villagerRegs.cancel();
            _emphasizedVillager = v;
            this.emphasizedVillagerChanged.dispatch(v);
        }
    }

    protected var _emphasizedVillager :Villager;
    protected const _villagerRegs :ListenerRegistrations = new ListenerRegistrations();

    protected static const NAME :String = "VillagerSelectionMgr";
}
}
