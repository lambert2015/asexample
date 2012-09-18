package three.renderers;
import three.cameras.Camera;
import three.scenes.Scene;

/**
 * ...
 * @author 
 */

interface IPostRenderPlugin implements IPlugin
{
	function init(renderer:IRenderer):Void;
	function update(scene:Scene, camera:Camera):Void;
}