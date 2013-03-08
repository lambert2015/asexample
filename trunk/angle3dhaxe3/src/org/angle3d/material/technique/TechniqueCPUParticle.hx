package org.angle3d.material.technique;

import flash.utils.ByteArray;
import flash.utils.Dictionary;
import org.angle3d.material.BlendMode;
import org.angle3d.material.CullMode;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.UniformBinding;
import org.angle3d.material.shader.UniformBindingHelp;
import org.angle3d.material.TestFunction;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.texture.TextureMapBase;


/**
 * andy
 * @author andy
 */

class TechniqueCPUParticle extends Technique
{
	[Embed(source = "data/cpuparticle.vs", mimeType = "application/octet-stream")]
	private static var CPUParticleVS:Class;
	[Embed(source = "data/cpuparticle.fs", mimeType = "application/octet-stream")]
	private static var CPUParticleFS:Class;

	private var _texture:TextureMapBase;

	public function new()
	{
		super();

		_renderState.applyCullMode = true;
		_renderState.cullMode = CullMode.FRONT;

		_renderState.applyDepthTest = true;
		_renderState.depthTest = false;
		_renderState.compareMode = TestFunction.LESS_EQUAL;

		_renderState.applyBlendMode = true;
		_renderState.blendMode = BlendMode.AlphaAdditive;
	}

	public function get texture():TextureMapBase
	{
		return _texture;
	}

	public function set texture(value:TextureMapBase):Void
	{
		_texture = value;
	}

	/**
	 * 更新Uniform属性
	 * @param	shader
	 */
	override public function updateShader(shader:Shader):Void
	{
		shader.getTextureVar("s_texture").textureMap = _texture;
	}

	override private function getVertexSource():String
	{
		var ba:ByteArray = new CPUParticleVS();
		return ba.readUTFBytes(ba.length);
	}

	override private function getFragmentSource():String
	{
		var ba:ByteArray = new CPUParticleFS();
		return ba.readUTFBytes(ba.length);
	}

	override private function getOption(lightType:String = "none", meshType:String = "static"):Vector<Vector<String>>
	{
		var results:Vector<Vector<String>> = super.getOption(lightType, meshType);
		return results;
	}

	override private function getKey(lightType:String = "none", meshType:String = "static"):String
	{
		var result:Array = [name, meshType];
		return result.join("_");
	}

	override private function getBindAttributes(lightType:String = "none", meshType:String = "static"):Dictionary
	{
		var map:Dictionary = new Dictionary();
		map[BufferType.POSITION] = "a_position";
		map[BufferType.TEXCOORD] = "a_texCoord";
		map[BufferType.COLOR] = "a_color";
		return map;
	}

	override private function getBindUniforms(lightType:String = "none", meshType:String = "static"):Vector<UniformBindingHelp>
	{
		var list:Vector<UniformBindingHelp> = new Vector<UniformBindingHelp>();
		list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
		
		return list;
	}
}

