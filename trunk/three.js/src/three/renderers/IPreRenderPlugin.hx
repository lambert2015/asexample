package three.renderers;
import three.cameras.Camera;
import three.scenes.Scene;

/**
 * ...
 * @author 
 */

interface IPreRenderPlugin 
{
	function init(renderer:IRenderer):Void;
	
	function update(scene:Scene, camera:Camera):Void;
}