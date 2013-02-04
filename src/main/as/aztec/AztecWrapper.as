//
// aztec

package aztec {

import flash.display.Loader;
import flash.display.Sprite;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.system.Security;
import flash.system.SecurityDomain;

[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
public class AztecWrapper extends Sprite
{
    public function AztecWrapper () {
        Security.allowDomain("*");

        var url :URLRequest = new URLRequest("http://" + Aztec.SERVER + "/aztec.swf");

        var ctx :LoaderContext = null;
        if (Security.sandboxType == Security.REMOTE) {
            ctx = new LoaderContext(false, new ApplicationDomain(), SecurityDomain.currentDomain);
        }

        var loader :Loader = new Loader();
        loader.load(url, ctx);
        addChild(loader);
    }
}
}
