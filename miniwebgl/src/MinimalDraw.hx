package;
import js.Boot;
import js.Browser;
import js.html.CanvasElement;
import js.html.Event;
import js.html.Float32Array;
import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.Lib;
import WebGLUtil;
/**
 * ...
 * @author andy
 */
class MinimalDraw 
{
	static function main() 
	{
		new MinimalDraw();
	}
	
	private var gl:RenderingContext;
	public function new()
	{
		this.gl = null;
		Browser.window.onload = onLoad;
	}
	
	private function onLoad(e:Event):Void
	{
		var canvas:CanvasElement = cast Browser.document.getElementById("webgl_canvas");
		gl = cast(canvas.getContext("experimental-webgl"),RenderingContext);
		gl.viewport(0, 0, canvas.width, canvas.height);
		gl.clearColor(0, 0, 0.8, 1);
		gl.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		
		var vertexPosBuffer = gl.createBuffer();
		gl.bindBuffer(GL.ARRAY_BUFFER, vertexPosBuffer);
		
		var vertices:Array<Float> = [ -0.5, -0.5, 0.5, -0.5, 0, 0.5];
		var floatArray:Float32Array = new Float32Array(vertices);
		gl.bufferData(GL.ARRAY_BUFFER, floatArray, GL.STATIC_DRAW);
		
		var vs:String = "attribute vec2 pos;\n" +
						"void main(){ gl_Position = vec4(pos,0,1); }";
		var fs:String = "precision mediump float;\n" +
						"void main() { gl_FragColor = vec4(0,0.8,0,1); }";
		
		var program:Program = WebGLUtil.createProgram(gl,vs, fs);
		gl.useProgram(program);
		var index:Int = gl.getAttribLocation(program, "pos");
		gl.enableVertexAttribArray(index);
		gl.vertexAttribPointer(index, 2, GL.FLOAT, false, 0, 0);
		gl.drawArrays(GL.TRIANGLES, 0, 3);
	}
}