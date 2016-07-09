//
// aztec

package aztec.battle {

import aspire.util.F;

import aztec.battle.controller.Villager;

import react.RegistrationGroup;
import react.Signal;

public class VillagerSelectionMgr extends LocalObject
    implements SelectableProvider
{
    public const emphasizedVillagerChanged :Signal = new Signal(Villager);

    public function VillagerSelectionMgr () {
        this.regs.add(_villagerRegs);
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

    override public function get ids () :Array {
        return [ NAME ].concat(super.ids);
    }

    override protected function added () :void {
        super.added();

        _ctx.villagerSelectionMgr = this;

        this.regs.add(_ctx.selector.registerProvider(this));
        this.regs.add(_ctx.selector.selectionBegan.connect(function (s :Selectable) :void {
            if (s is Villager) {
                onSelectionBegan(Villager(s));
            }
        }));
        this.regs.add(_ctx.selector.selectionCanceled.connect(function (s :Selectable) :void {
            if (s is Villager) {
                onSelectionEnded(Villager(s));
            }
        }));
    }

    protected function onSelectionBegan (v :Villager) :void {
        setEmphasizedVillager(v);
        _villagerRegs.add(v.destroyed.connect(F.bind(onSelectionEnded, v)));
        _villagerRegs.add(v.deselected.connect(F.bind(onSelectionEnded, v)));
    }

    protected function onSelectionEnded (v :Villager) :void {
        if (_emphasizedVillager == v) {
            setEmphasizedVillager(null);
        }
    }

    protected function setEmphasizedVillager (v :Villager) :void {
        if (_emphasizedVillager != v) {
            _villagerRegs.close();
            _emphasizedVillager = v;
            this.emphasizedVillagerChanged.emit(v);
        }
    }

    protected var _emphasizedVillager :Villager;
    protected const _villagerRegs :RegistrationGroup = new RegistrationGroup();

    protected static const NAME :String = "VillagerSelectionMgr";
}
}
