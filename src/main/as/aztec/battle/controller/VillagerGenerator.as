//
// aztec

package aztec.battle.controller {

import aspire.util.Comparators;
import aspire.util.Log;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.Set;
import aspire.util.Sets;
import aspire.util.XmlUtil;

import aztec.battle.God;
import aztec.battle.desc.GameDesc;

import flashbang.resource.XmlResource;

public class VillagerGenerator extends NetObject
{
    override protected function update (dt :Number) :void {
        var needed :int = GameDesc.numVillagers - Villager.getCount(_ctx);
        for (var ii :int = 0; ii < needed; ++ii) {
            generate();
        }
    }

    protected function generate () :void {
        var name :String = generateName();
        var firstLetter :String = name.substr(0, 1);
        var villager :Villager = new Villager(name);

        // track claimed letters
        var added :Boolean = _claimedLetters.add(firstLetter);
        if (!added) {
            log.error("First letter was already claimed!", "name", name);
        }

        _regs.addOneShotSignalListener(villager.destroyed, function () :void {
             var removed :Boolean = _claimedLetters.remove(firstLetter);
             if (!removed) {
                 log.error("First letter was already un-claimed!", "name", name);
             }
        });

        _ctx.netObjects.addObject(villager);
    }

    protected function generateName () :String {
        initNameMap();

        var lists :Array = [];
        for each (var letter :String in _names.keys()) {
            if (!_claimedLetters.contains(letter)) {
                lists.push(_names.get(letter));
            }
        }

        if (lists.length == 0) {
            log.error("Can't generate a unique name!");
            return "Error";
        }

        var list :Array = rands().pick(lists);
        return rands().pick(list);
    }

    protected static function initNameMap () :void {
        if (_names != null) {
            return;
        }

        var list :Array;

        // remove our gods' names' first letters from our alphabet
        var allowedFirstLetters :String = ALPHABET.concat();
        for each (var god :God in God.values()) {
            var godLetter :String = god.displayName.substr(0, 1).toLowerCase();
            allowedFirstLetters = allowedFirstLetters.replace(godLetter, "");
        }

        _names = Maps.newSortedMapOf(String, Comparators.compareStrings);
        for (var ii :int = 0; ii < allowedFirstLetters.length; ++ii) {
            var letter :String = allowedFirstLetters.charAt(ii);
            _names.put(letter, []);
        }

        var allNamesXml :XML = XmlResource.requireXml("villagerNames");
        for each (var nameXml :XML in allNamesXml.name) {
            var name :String = XmlUtil.getText(nameXml).toLowerCase();
            var firstLetter :String = name.substr(0, 1);
            list = _names.get(firstLetter);
            if (list == null) {
                log.warning("Unsupported letter?", "letter", firstLetter, "name", name);
            } else {
                list.push(name);
            }
        }

        for each (var key :String in _names.keys()) {
            list = _names.get(key);
            if (list.length == 0) {
                log.info("No names starting with '" + key + "'");
                _names.remove(key);
            }
        }
    }

    protected static var _names :Map; // <String, Array<String>>

    // Each Villager must have a name that starts with a unique letter.
    // This tracks with letters are claimed by existing Villagers.
    protected static var _claimedLetters :Set =
        Sets.newSortedSetOf(String, Comparators.compareStrings);

    protected static const log :Log = Log.getLog(VillagerGenerator);

    protected static const ALPHABET :String = "abcdefghijklmnopqrstuvwxyz";
}
}
