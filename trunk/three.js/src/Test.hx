package ;

import js.Browser;
import js.html.CanvasElement;
import js.html.Element;
import js.html.Event;
import js.html.Float32Array;
import js.html.ImageElement;
import js.html.webgl.Program;
import js.html.webgl.RenderingContext;
import js.Lib;
import three.materials.Material;
import three.math.MathUtil;
import three.renderers.ShaderDef;
import three.renderers.ShaderLib;
import three.utils.ImageUtil;
import three.utils.WebGLUtil;
import three.core.EventDispatcher;
import three.loaders.ImageLoader;
import three.loaders.TextureLoader;
/**
 * ...
 * @author 
 */

class Test 
{
	static function main() 
	{
		new Test();
	}
	
	private var gl:RenderingContext;
	public function new()
	{
		Browser.window.onload = onLoad;
	}
	
	private function onLoad(e:Event):Void
	{
		var canvas:CanvasElement = cast Browser.document.getElementById("webgl_canvas");
		gl = canvas.getContextWebGL();
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
		
		//var material:Material = new Material();
		//material.setValues( { name:"abcd", transparent:true } );
		//Lib.alert(material.name);
		//
		//ShaderLib.initShaderLib();
		//
		//var def:ShaderDef = ShaderLib.getShaderDef("phong");
		
		var image:ImageElement = ImageUtil.createImage();
		//cast Browser.document.createElement("img");
		var loader:ImageLoader = new ImageLoader();
		loader.addEventListener('load', function ( event ):Void {
				} );
		loader.load("textures/crate256.jpg", image);
		
		Browser.document.getElementById("webgl").appendChild(image);
		
		var t:Float = MathUtil.clamp(5, 0, 10);
	}
}