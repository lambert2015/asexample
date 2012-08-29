package ;

import js.Dom;
import js.Lib;
import three.math.Color;
import three.math.Matrix4;
import three.math.Vector3;
import UserAgentContext;
import three.math.Vector2;
import three.scenes.Fog;
import three.utils.WebGLUtil;
import three.core.Object3D;
import three.scenes.Scene;
import three.lights.AmbientLight;
import three.lights.DirectionalLight;
import three.lights.PointLight;
import three.lights.SpotLight;
import three.materials.Material;
import three.renderers.renderables.RenderableFace3;
import three.renderers.renderables.RenderableFace4;
import three.renderers.renderables.RenderableLine;
import three.renderers.renderables.RenderableObject;
import three.renderers.renderables.RenderableParticle;
import three.renderers.renderables.RenderableVertex;
import three.renderers.WebGLRenderer;
import three.cameras.Camera;
import three.cameras.PerspectiveCamera;
import three.cameras.OrthographicCamera;
import three.core.Clock;
import three.core.Frustum;
import three.core.BufferGeometry;
import three.renderers.WebGLRenderTarget;
import three.renderers.WebGLRenderTargetCube;
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
	
	private var gl:WebGLRenderingContext;
	public function new()
	{
		this.gl = null;
		Lib.window.onload = onLoad;
	}
	
	
	private function onLoad(e:Event):Void
	{
		var canvas:HTMLCanvasElement = cast Lib.document.getElementById("webgl_canvas");
		gl = cast(canvas.getContext("experimental-webgl"),WebGLRenderingContext);
		gl.viewport(0, 0, canvas.width, canvas.height);
		gl.clearColor(0, 0, 0.8, 1);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		var vertexPosBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexPosBuffer);
		
		var vertices:Array<Float> = [ -0.5, -0.5, 0.5, -0.5, 0, 0.5];
		var floatArray:Float32Array = new Float32Array(vertices);
		//floatArray.set(vertices);
		gl.bufferData(gl.ARRAY_BUFFER, floatArray, gl.STATIC_DRAW);
		
		var vs:String = "attribute vec2 pos;\n" +
						"void main(){ gl_Position = vec4(pos,0,1); }";
		var fs:String = "precision mediump float;\n" +
						"void main() { gl_FragColor = vec4(0,0.8,0,1); }";
		
		var program:WebGLProgram = WebGLUtil.createProgram(gl,vs, fs);
		gl.useProgram(program);
		var index:Int = gl.getAttribLocation(program, "pos");
		gl.enableVertexAttribArray(index);
		gl.vertexAttribPointer(index, 2, gl.FLOAT, false, 0, 0);
		gl.drawArrays(gl.TRIANGLES, 0, 3);
	}
}