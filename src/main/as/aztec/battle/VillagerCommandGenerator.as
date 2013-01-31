//
// aztec

package aztec.battle {
import aspire.util.Comparators;
import aspire.util.Log;
import aspire.util.Map;
import aspire.util.Maps;
import aspire.util.Set;
import aspire.util.StringUtil;
import aspire.util.XmlUtil;

import aztec.battle.controller.Villager;

import flashbang.resource.XmlResource;

public class VillagerCommandGenerator extends LocalObject
{
    public function getCommandText (action :VillagerAction, villager :Villager,
        affinity :Number, usedGreetingLetters :Set) :String {
        
        init();
        var commandList :Array = _commands.get(action);
        
        commandList = commandList.filter(function (cmd :CommandText, ..._) :Boolean {
            return (affinity >= cmd.minAffinity);
        });
        
        var highestAffinity :Number = CommandText(commandList[0]).minAffinity;
        commandList = commandList.filter(function (cmd :CommandText, ..._) :Boolean {
            return cmd.minAffinity == highestAffinity;
        });
        
        // perform substitutions
        var text :String = CommandText(rands().pick(commandList)).text;
        text = text.replace(RE_NAME, StringUtil.capitalize(villager.name));
        
        while (true) {
            // reset the regex before exec'ing it
            RE_SUB.lastIndex = 0;
            var result :Object = RE_SUB.exec(text);
            if (result == null) {
                break;
            }
            var subName :String = String(result[1]).toLowerCase();
            var subs :Array = _substitutions.get(subName);
            if (subs == null) {
                log.warning("No substitutions for '" + subName + "'");
                break;
            }
            
            // ensure unique greetings
            if (subName == "greeting" && usedGreetingLetters.size() > 0) {
                subs = subs.filter(function (greeting :String, ..._) :Boolean {
                    var firstLetter :String = greeting.substr(0, 1).toLowerCase();
                    return !usedGreetingLetters.contains(firstLetter);
                });
            }
            
            var sub :String = rands().pick(subs);
            var match :String = result[0];
            text = text.replace(match, sub);
        }
        
        
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
        if (_commands != null) {
            return;
        }
        
        _commands = Maps.newMapOf(VillagerAction);
        var commandList :Array;
        var xml :XML = XmlResource.requireXml("villagerCommands");
        for each (var cmdXml :XML in xml.command) {
            var action :VillagerAction = XmlUtil.getEnumAttr(cmdXml, "action", VillagerAction);
            commandList = _commands.get(action);
            if (commandList == null) {
                commandList = [];
                _commands.put(action, commandList);
            }
            commandList.push(new CommandText(
                XmlUtil.getStringAttr(cmdXml, "text"),
                XmlUtil.getNumberAttr(cmdXml, "affinity")));
        }
        
        for each (commandList in _commands.values()) {
            // sort higher affinities to the top
            commandList.sort(function (a :CommandText, b :CommandText) :int {
                return Comparators.compareNumbers(b.minAffinity, a.minAffinity);
            });
        }
        
        _substitutions = Maps.newMapOf(String);
        for each (var subXml :XML in xml.subs..*) {
            var subName :String = subXml.name();
            if (subName != null) {
                subName = subName.toLowerCase();
                var subs :Array = _substitutions.get(subName);
                if (subs == null) {
                    subs = [];
                    _substitutions.put(subName, subs);
                }
                subs.push(XmlUtil.getStringAttr(subXml, "text"));
            }
        }
    }
    
    protected static var _commands :Map; // <VillagerAction, CommandText>
    protected static var _substitutions :Map; // <String, Array<String>>
    
    protected static const log :Log = Log.getLog(VillagerCommandGenerator);
    
    protected static const RE_NAME :RegExp = /\{name\}/g;
    protected static const RE_SUB :RegExp = /\{(.*?)\}/g;
    
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
