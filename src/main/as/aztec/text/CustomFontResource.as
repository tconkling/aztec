//
// flashbang

package aztec.text {

import aspire.util.Preconditions;

import flashbang.resource.Resource;

public class CustomFontResource extends Resource
{
    public function CustomFontResource (name :String, font :CustomBitmapFont)
    {
        super(name);

        // ResourceManager should prevent this from ever happening
        Preconditions.checkState(CustomTextField.getBitmapFont(name) == null,
            "A font with this name somehow already exists");

        CustomTextField.registerBitmapFont(font, name);
    }

    override protected function unload () :void
    {
        CustomTextField.unregisterBitmapFont(_name, /*dispose=*/true);
    }
}
}

