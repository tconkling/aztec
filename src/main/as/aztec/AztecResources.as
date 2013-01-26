//
// aztec

package aztec {

import flashbang.resource.ResourceSet;

public class AztecResources extends ResourceSet
{
    public function AztecResources () {
        add(futuraFont());
    }
    
    protected function futuraFont () :Object {
        return {
            type: "font",
            name: "futura",
            xmlData: UIFONT_XML,
            textureData: UIFONT_TEXTURE,
            scale: 1
        }
    }
    
    [Embed(source="../../../../rsrc/fonts/FuturaCondensedExtraBold.fnt", mimeType="application/octet-stream")]
    protected static const UIFONT_XML :Class;
    
    [Embed(source="../../../../rsrc/fonts/FuturaCondensedExtraBold.png", mimeType="application/octet-stream")]
    protected static const UIFONT_TEXTURE :Class;
}
}
