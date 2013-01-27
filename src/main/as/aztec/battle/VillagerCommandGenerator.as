//
// aztec

package aztec.battle {
import aspire.util.Comparators;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.StringUtil;
import aspire.util.XmlUtil;

import aztec.battle.controller.Villager;

import flashbang.resource.XmlResource;

public class VillagerCommandGenerator extends LocalObject
{
    public function getCommandText (action :VillagerAction, villager :Villager, normalizedAffinity :Number) :String {
        init();
        var commandList :Array = _texts.get(action);
        
        commandList = commandList.filter(function (cmd :CommandText, ..._) :Boolean {
            return (normalizedAffinity >= cmd.minAffinity);
        });
        
        var highestAffinity :Number = CommandText(commandList[0]).minAffinity;
        commandList = commandList.filter(function (cmd :CommandText, ..._) :Boolean {
            return cmd.minAffinity == highestAffinity;
        });
        
        var text :String = CommandText(_ctx.randomsFor(this).pick(commandList)).text;
        const re :RegExp = /\{name\}/g;
        text = text.replace(re, StringUtil.capitalize(villager.name));
        return text;
    }
    
    override public function get objectNames () :Array {
        return [ NAME ].concat(super.objectNames);
    }
    
    override protected function addedToMode () :void {
        super.addedToMode();
        _ctx.commandGenerator = this;
    }
    
    protected static function init () :void {
        if (_texts != null) {
            return;
        }
        
        _texts = Maps.newMapOf(VillagerAction);
        var commandList :Array;
        var xml :XML = XmlResource.requireXml("villagerCommands");
        for each (var cmdXml :XML in xml.command) {
            var action :VillagerAction = XmlUtil.getEnumAttr(cmdXml, "action", VillagerAction);
            commandList = _texts.get(action);
            if (commandList == null) {
                commandList = [];
                _texts.put(action, commandList);
            }
            commandList.push(new CommandText(
                XmlUtil.getStringAttr(cmdXml, "text"),
                XmlUtil.getNumberAttr(cmdXml, "affinity")));
        }
        
        for each (commandList in _texts.values()) {
            // sort higher affinities to the top
            commandList.sort(function (a :CommandText, b :CommandText) :int {
                return Comparators.compareNumbers(b.minAffinity, a.minAffinity);
            });
        }
    }
    
    protected static var _texts :Map;
    
    protected static const NAME :String = "VillagerCommandGenerator";
}
}

class CommandText {
    public var minAffinity :Number;
    public var text :String;
    
    public function CommandText (text :String, minAffinity :Number) {
        this.text = text;
        this.minAffinity = minAffinity;
    }
}
