//
// aztec

package aztec {

import flashbang.resource.ResourceSet;

public class AztecResources extends ResourceSet
{
    public function AztecResources () {
        add(futuraFont());
        add(herculanumFont());
        add(aztecFlump());
        add(villagerNames());
        add(villagerCommands());
    }
    
    protected function aztecFlump () :Object {
        return {
            type: "flump",
            name: "aztec",
            data: AZTEC_FLUMP
        }
    }
    
    protected function futuraFont () :Object {
        return {
            type: "customFont",
            name: "futura",
            xmlData: FUTURA_XML,
            textureData: FUTURA_TEX,
            scale: 1
        }
    }
    
    protected function herculanumFont () :Object {
        return {
            type: "customFont",
            name: "herculanum",
            xmlData: HERCULANUM_XML,
            textureData: HERCULANUM_TEX,
            scale: 1
        }
    }
    
    protected function villagerNames () :Object {
        return {
            type: "xml",
            name: "villagerNames",
            data: VILLAGER_NAMES_XML
        };
    }
    
    protected function villagerCommands () :Object {
        return {
            type: "xml",
            name: "villagerCommands",
            data: VILLAGER_COMMANDS_XML
        };
    }
    
    [Embed(source="../../../../rsrc/art/aztec.zip", mimeType="application/octet-stream")]
    protected static const AZTEC_FLUMP :Class;
    
    [Embed(source="../../../../rsrc/fonts/FuturaCondensedExtraBold.fnt", mimeType="application/octet-stream")]
    protected static const FUTURA_XML :Class;
    
    [Embed(source="../../../../rsrc/fonts/FuturaCondensedExtraBold.png", mimeType="application/octet-stream")]
    protected static const FUTURA_TEX :Class;
    
    [Embed(source="../../../../rsrc/fonts/herculanum18.fnt", mimeType="application/octet-stream")]
    protected static const HERCULANUM_XML :Class;
    
    [Embed(source="../../../../rsrc/fonts/herculanum18.png", mimeType="application/octet-stream")]
    protected static const HERCULANUM_TEX :Class;
    
    [Embed(source="../../../../rsrc/villager_names.xml", mimeType="application/octet-stream")]
    protected static const VILLAGER_NAMES_XML :Class;
    
    [Embed(source="../../../../rsrc/villager_commands.xml", mimeType="application/octet-stream")]
    protected static const VILLAGER_COMMANDS_XML :Class;
}
}
