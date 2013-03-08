package org.angle3d.material.technique;

import flash.utils.ByteArray;
import flash.utils.Dictionary;
import org.angle3d.light.LightType;
import org.angle3d.material.CullMode;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.UniformBinding;
import org.angle3d.material.shader.UniformBindingHelp;
import org.angle3d.material.TestFunction;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.MeshType;
import org.angle3d.texture.CubeTextureMap;
import org.angle3d.texture.TextureMapBase;


/**
 * Reflection mapping
 * @author andy
 * @see http://developer.nvidia.com/book/export/html/86
 * @see http://en.wikipedia.org/wiki/Reflection_mapping
 */
class TechniqueRefraction extends Technique
{
	[Embed(source = "data/refraction.vs", mimeType = "application/octet-stream")]
	private static var RefractionVS:Class;
	[Embed(source = "data/refraction.fs", mimeType = "application/octet-stream")]
	private static var RefractionFS:Class;

	private var _decalMap:TextureMapBase;

	private var _environmentMap:CubeTextureMap;

	private var _transmittance:Float;

	private var _etaRatios:Vector<Float>;

	public function new(decalMap:TextureMapBase, environmentMap:CubeTextureMap, etaRatio:Float = 1.5, transmittance:Float = 0.5)
	{
		super();

		_renderState.applyCullMode = true;
		_renderState.cullMode = CullMode.FRONT;

		_renderState.applyDepthTest = true;
		_renderState.depthTest = true;
		_renderState.compareMode = TestFunction.LESS_EQUAL;

		_renderState.applyBlendMode = false;

		_etaRatios = new Vector<Float>(4, true);

		this.decalMap = decalMap;
		this.environmentMap = environmentMap;
		this.etaRatio = etaRatio;
		this.transmittance = transmittance;
	}

	public function set etaRatio(value:Float):Void
	{
//			if (value < 1.0)
//				value = 1.0;
		_etaRatios[0] = value;
		_etaRatios[1] = value * value;
		_etaRatios[2] = 1.0 - _etaRatios[1];
	}

	public function get etaRatio():Float
	{
		return _etaRatios[0];
	}

	/**
	 * 反射率，一般应该设置在0~1之间
	 */
	public function set transmittance(value:Float):Void
	{
		_transmittance = value;
		if (_transmittance < 0)
			_transmittance = 0;
	}

	public function get transmittance():Float
	{
		return _transmittance;
	}

	public function get decalMap():TextureMapBase
	{
		return _decalMap;
	}

	public function set decalMap(value:TextureMapBase):Void
	{
		_decalMap = value;
	}

	public function get environmentMap():CubeTextureMap
	{
		return _environmentMap;
	}

	public function set environmentMap(value:CubeTextureMap):Void
	{
		_environmentMap = value;
	}

	override public function updateShader(shader:Shader):Void
	{
		shader.getUniform(ShaderType.VERTEX, "u_etaRatio").setVector(_etaRatios);
		shader.getUniform(ShaderType.FRAGMENT, "u_transmittance").setFloat(_transmittance);
		shader.getTextureVar("u_decalMap").textureMap = _decalMap;
		shader.getTextureVar("u_environmentMap").textureMap = _environmentMap;
	}

	override private function getVertexSource():String
	{
		var ba:ByteArray = new RefractionVS();
		return ba.readUTFBytes(ba.length);
	}

	override private function getFragmentSource():String
	{
		var ba:ByteArray = new RefractionFS();
		return ba.readUTFBytes(ba.length);
	}

	override private function getBindAttributes(lightType:LightType, meshType:MeshType):StringMap<String>
	{
		var map:Dictionary = new Dictionary();
		map[BufferType.POSITION] = "a_position";
		map[BufferType.TEXCOORD] = "a_texCoord";
		map[BufferType.NORMAL] = "a_normal";
		return map;
	}

	override private function getBindUniforms(lightType:LightType, meshType:MeshType):Array<UniformBindingHelp>
	{
		var list:Vector<UniformBindingHelp> = new Vector<UniformBindingHelp>();
		list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
		list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_worldMatrix", UniformBinding.WorldMatrix));
		list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_camPosition", UniformBinding.CameraPosition));
		
		return list;
	}
}

