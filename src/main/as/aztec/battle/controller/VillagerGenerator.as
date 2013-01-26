//
// aztec

package aztec.battle.controller {
import aspire.util.Log;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.XmlUtil;

import flashbang.resource.XmlResource;

import aztec.battle.desc.GameDesc;

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
        log.info("generated name '" + name + "'");
        _ctx.netObjects.addObject(new Villager(name));
    }
    
    protected function generateName () :String {
        var list :Array;
        var name :String;
        
        if (_names == null) {
            _names = Maps.newMapOf(String);
            for (var ii :int = 0; ii < ALPHABET.length; ++ii) {
                var letter :String = ALPHABET.charAt(ii);
                _names.put(letter, []);
            }
            
            var allNamesXml :XML = XmlResource.requireXml("villagerNames");
            for each (var nameXml :XML in allNamesXml.name) {
                name = XmlUtil.getText(nameXml).toLowerCase();
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
        
        list = rands().pick(_names.values());
        name = rands().pick(list);
        
        return name;
    }
    
    protected static var _names :Map; // <String, Array<String>>
    
    protected static const log :Log = Log.getLog(VillagerGenerator);
    
    protected static const ALPHABET :String = "abcdefghijklmnopqrstuvwxyz";
}
}
