//
// aztec

package aztec {

import flashbang.resource.ResourceSet;

public class AztecResources extends ResourceSet
{
    public function AztecResources () {
        add(futuraFont());
        add(herculanumFont());
        add(herculanumLargeFont());
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
            xmlData: HERCULANUM18_XML,
            textureData: HERCULANUM18_TEX,
            scale: 1
        }
    }
    
    protected function herculanumLargeFont () :Object {
        return {
            type: "font",
            name: "herculanumLarge",
            xmlData: HERCULANUM70_XML,
            textureData: HERCULANUM70_TEX,
            scale: 1
        }
    }
    
    protected function arialFont () :Object {
        return {
            type: "font",
            name: "arial",
            xmlData: ARIAL24_XML,
            textureData: ARIAL24_TEX,
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
    protected static const HERCULANUM18_XML :Class;
    
    [Embed(source="../../../../rsrc/fonts/herculanum18.png", mimeType="application/octet-stream")]
    protected static const HERCULANUM18_TEX :Class;
    
    [Embed(source="../../../../rsrc/fonts/herculanum70.fnt", mimeType="application/octet-stream")]
    protected static const HERCULANUM70_XML :Class;
    
    [Embed(source="../../../../rsrc/fonts/herculanum70.png", mimeType="application/octet-stream")]
    protected static const HERCULANUM70_TEX :Class;
    
    [Embed(source="../../../../rsrc/fonts/arial24.fnt", mimeType="application/octet-stream")]
    protected static const ARIAL24_XML :Class;
    
    [Embed(source="../../../../rsrc/fonts/arial24.png", mimeType="application/octet-stream")]
    protected static const ARIAL24_TEX :Class;
    
    [Embed(source="../../../../rsrc/villager_names.xml", mimeType="application/octet-stream")]
    protected static const VILLAGER_NAMES_XML :Class;
    
    [Embed(source="../../../../rsrc/villager_commands.xml", mimeType="application/octet-stream")]
    protected static const VILLAGER_COMMANDS_XML :Class;
}
}
