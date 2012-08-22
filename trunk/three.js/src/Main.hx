package ;

import js.Dom;
import js.Lib;
import UserAgentContext;
import three.math.Vector2;
import three.scenes.Fog;

/**
 * ...
 * @author 
 */

class Main 
{
	
	static function main() 
	{
		new Main();
	}
	
	public function new()
	{
		Lib.window.onload = onLoad;
	}
	
	private function onLoad(e:Event):Void
	{
		var canvas:HTMLCanvasElement = cast Lib.document.getElementById("webgl_canvas");
		var gl:WebGLRenderingContext = cast(canvas.getContext("experimental-webgl"),WebGLRenderingContext);
		gl.viewport(0, 0, canvas.width, canvas.height);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
	}
	
}