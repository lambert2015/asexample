package three.renderers;
import three.cameras.Camera;
import three.scenes.Scene;

/**
 * ...
 * @author 
 */

interface IPlugin 
{
	function render(scene:Scene, camera:Camera, width:Int, height:Int):Void;
}