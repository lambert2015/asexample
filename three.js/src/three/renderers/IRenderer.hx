package three.renderers;
import three.cameras.Camera;
import three.scenes.Scene;

/**
 * ...
 * @author 
 */

interface IRenderer 
{
	function render(scene:Scene, camera:Camera, renderTarget:WebGLRenderTarget, forceClear:Bool = false):Void;
	function clear(color:Bool, detph:Bool, stencil:Bool):Void;
	function addPostPlugin(plugin:IPostRenderPlugin):Void;
	function addPrePlugin(plugin:IPreRenderPlugin):Void;
}