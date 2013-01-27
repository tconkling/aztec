//
// flashbang

package aztec.text {

import flashbang.resource.ResourceLoader;
import flashbang.resource.XmlLoader;
import flashbang.resource.XmlResource;
import flashbang.util.LoadableBatch;

public class CustomFontLoader extends ResourceLoader
{
    /** The name of the Font (required) */
    public static const NAME :String = "name";
    
    /**
     * a String containing a URL to load the XML from OR
     * a ByteArray containing the XML OR
     * an [Embed]ed class containing the XML
     * (required)
     */
    public static const XML_DATA :String = "xmlData";
    
    /**
     * a String containing a URL to load the XML from OR
     * a ByteArray containing the XML OR
     * an [Embed]ed class containing the XML
     * (required)
     */
    public static const TEXTURE_DATA :String = "textureData";
    
    /** The scale of the font texture (optional, @default 1) */
    public static const SCALE :String = "scale";
    
    public function CustomFontLoader (params :Object)
    {
        super(params);
    }
    
    override protected function doLoad () :void
    {
        var name :String = requireLoadParam(NAME, String);
        
        var xmlLoader :XmlLoader =
            new XmlLoader({ name: "dummy", data: requireLoadParam(XML_DATA) });
        var textureLoader :TextureLoader =
            new TextureLoader(requireLoadParam(TEXTURE_DATA), getLoadParam(SCALE, 1));
        
        _batch = new LoadableBatch();
        _batch.addLoadable(xmlLoader);
        _batch.addLoadable(textureLoader);
        
        _batch.load(
            function () :void {
                try {
                    var texture :LoadedTexture = textureLoader.result;
                    var xml :XML = XmlResource(xmlLoader.result).xml;
                    var font :CustomBitmapFont = new CustomBitmapFont(texture.texture, xml);
                    succeed(new CustomFontResource(name, font));
                } catch (e :Error) {
                    fail(e);
                }
            },
            fail);
    }
    
    override protected function onLoadCanceled () :void
    {
        if (_batch != null) {
            _batch.cancel();
            _batch = null;
        }
    }
    
    protected var _batch :LoadableBatch;
    protected var _xmlLoader :XmlLoader;
}
}

import aspire.util.ClassUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import flashbang.util.Loadable;

import starling.core.Starling;
import starling.textures.Texture;

class LoadedTexture
{
    public function LoadedTexture (loader :Loader, scale :Number)
    {
        _loader = loader;
        
        var bmd :BitmapData = Bitmap(loader.content).bitmapData;
        _tex = Texture.fromBitmapData(bmd, false, false, scale);
        
        // If Starling doesn't need to handle lost contexts, we can close the loader right now.
        if (!Starling.handleLostContext) {
            closeLoader();
        }
    }
    
    public function get texture () :Texture
    {
        return _tex;
    }
    
    public function unload () :void
    {
        _tex.dispose();
        _tex = null;
        closeLoader();
    }
    
    protected function closeLoader () :void
    {
        // Loader may already be closed.
        if (_loader != null) {
            try {
                _loader.close();
            } catch (e :Error) {
                // swallow
            }
            _loader = null;
        }
    }
    
    protected var _tex :Texture;
    protected var _loader :Loader;
}

class TextureLoader extends Loadable
{
    public function TextureLoader (data :Object, scale :Number)
    {
        _data = data;
        _scale = scale;
    }
    
    override protected function doLoad () :void
    {
        if (_data is Class) {
            var clazz :Class = Class(_data);
            _data = ByteArray(new clazz());
        }
        
        _loader = new Loader();
        _loader.contentLoaderInfo.addEventListener(Event.INIT, function (..._) :void {
            try {
                succeed(new LoadedTexture(_loader, _scale));
                _loader = null;
            } catch (e :Error) {
                fail(e);
            }
        });
        
        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,
            function (evt :IOErrorEvent) :void {
                fail(new IOError(evt.text, evt.errorID));
            });
        
        if (_data is String) {
            _loader.load(new URLRequest(_data as String));
        } else if (_data is ByteArray) {
            _loader.loadBytes(_data as ByteArray);
        } else {
            throw new Error("Unrecognized Texture data source: '" +
                ClassUtil.tinyClassName(_data) + "'");
        }
    }
    
    override protected function onLoadCanceled () :void
    {
        // Loader may already be closed.
        if (_loader != null) {
            try {
                _loader.close();
            } catch (e :Error) {
                // swallow
            }
            _loader = null;
        }
    }
    
    protected var _data :Object;
    protected var _scale :Number;
    protected var _loader :Loader;
}
