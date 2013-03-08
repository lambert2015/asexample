package org.angle3d.material.technique;

import flash.utils.ByteArray;
import flash.utils.Dictionary;
import haxe.ds.StringMap;
import org.angle3d.light.LightType;
import org.angle3d.material.CullMode;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.UniformBinding;
import org.angle3d.material.shader.UniformBindingHelp;
import org.angle3d.material.TestFunction;
import org.angle3d.math.Color;
import org.angle3d.math.FastMath;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.MeshType;


/**
 * andy
 * @author andy
 */
//TODO 算法可能有些问题，线条过于不平滑了。Away3D中好像没这种现象
class TechniqueWireframe extends Technique
{
	[Embed(source = "data/wireframe.vs", mimeType = "application/octet-stream")]
	private static var WireframeVS:Class;
	[Embed(source = "data/wireframe.fs", mimeType = "application/octet-stream")]
	private static var WireframeFS:Class;

	private var _color:Color;
	private var _thickness:Float;

	public function new(color:UInt = 0xFFFFFFFF, thickness:Float = 1)
	{
		super();

		_renderState.applyCullMode = true;
		_renderState.cullMode = CullMode.FRONT;

		_renderState.applyDepthTest = true;
		_renderState.depthTest = true;
		_renderState.compareMode = TestFunction.LESS_EQUAL;

		_renderState.applyBlendMode = false;

		_color = new Color();

		this.color = color;
		this.thickness = thickness;
	}

	public function set color(color:UInt):Void
	{
		_color.setRGB(color);
	}

	public function get color():UInt
	{
		return _color.getColor();
	}

	public function set alpha(alpha:Float):Void
	{
		_color.a = FastMath.fclamp(alpha, 0.0, 1.0);
	}

	public function get alpha():Float
	{
		return _color.a;
	}

	public function set thickness(thickness:Float):Void
	{
		_thickness = thickness * 0.001;
	}

	public function get thickness():Float
	{
		return _thickness;
	}

	override public function updateShader(shader:Shader):Void
	{
		shader.getUniform(ShaderType.VERTEX, "u_color").setColor(_color);
		shader.getUniform(ShaderType.VERTEX, "u_thickness").setFloat(_thickness);
	}

	override private function getVertexSource():String
	{
		var ba:ByteArray = new WireframeVS();
		return ba.readUTFBytes(ba.length);
	}

	override private function getFragmentSource():String
	{
		var ba:ByteArray = new WireframeFS();
		return ba.readUTFBytes(ba.length);
	}

	override private function getBindAttributes(lightType:LightType, meshType:MeshType):StringMap<String>
	{
		var map:Dictionary = new Dictionary();
		map[BufferType.POSITION] = "a_position";
		map[BufferType.POSITION1] = "a_position1";
		return map;
	}

	override private function getBindUniforms(lightType:LightType, meshType:MeshType):Array<UniformBindingHelp>
	{
		var list:Array<UniformBindingHelp> = [];
		list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_worldViewMatrix", UniformBinding.WorldViewMatrix));
		list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_projectionMatrix", UniformBinding.ProjectionMatrix));
		
		return list;
	}
}

