package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.material.BlendMode;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * ...
	 * @author andy
	 */

	public class TechniqueCPUParticle extends Technique
	{
		[Embed(source = "data/cpuparticle.vs", mimeType = "application/octet-stream")]
		private static var CPUParticleVS:Class;
		[Embed(source = "data/cpuparticle.fs", mimeType = "application/octet-stream")]
		private static var CPUParticleFS:Class;

		private var _texture:TextureMapBase;

		public function TechniqueCPUParticle()
		{
			super();

			_renderState.applyCullMode = true;
			_renderState.cullMode = Context3DTriangleFace.FRONT;

			_renderState.applyDepthTest = true;
			_renderState.depthTest = false;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = true;
			_renderState.blendMode = BlendMode.AlphaAdditive;
		}

		public function get texture():TextureMapBase
		{
			return _texture;
		}

		public function set texture(value:TextureMapBase):void
		{
			_texture = value;
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):void
		{
			shader.getTextureVar("s_texture").textureMap = _texture;
		}

		override protected function getVertexSource():String
		{
			var ba:ByteArray = new CPUParticleVS();
			return ba.readUTFBytes(ba.length);
		}

		override protected function getFragmentSource():String
		{
			var ba:ByteArray = new CPUParticleFS();
			return ba.readUTFBytes(ba.length);
		}

		override protected function getOption(lightType:String = "none", meshType:String = "static"):Vector.<Vector.<String>>
		{
			var results:Vector.<Vector.<String>> = super.getOption(lightType, meshType);
			return results;
		}

		override protected function getKey(lightType:String = "none", meshType:String = "static"):String
		{
			var result:Array = [name, meshType];
			return result.join("_");
		}

		override protected function getBindAttributes(lightType:String = "none", meshType:String = "static"):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.TEXCOORD] = "a_texCoord";
			map[BufferType.COLOR] = "a_color";
			return map;
		}

		override protected function getBindUniforms(lightType:String = "none", meshType:String = "static"):Vector.<UniformBindingHelp>
		{
			var list:Vector.<UniformBindingHelp> = new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
			list.fixed = true;
			return list;
		}
	}
}

