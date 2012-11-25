package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
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
	public class TechniqueRefraction extends Technique
	{
		[Embed(source = "data/refraction.vs", mimeType = "application/octet-stream")]
		private static var RefractionVS:Class;
		[Embed(source = "data/refraction.fs", mimeType = "application/octet-stream")]
		private static var RefractionFS:Class;

		private var _decalMap:TextureMapBase;

		private var _environmentMap:CubeTextureMap;

		private var _transmittance:Number;

		private var _etaRatios:Vector.<Number>;

		public function TechniqueRefraction(decalMap:TextureMapBase, environmentMap:CubeTextureMap, etaRatio:Number = 1.5, transmittance:Number = 0.5)
		{
			super();

			_renderState.applyCullMode = true;
			_renderState.cullMode = Context3DTriangleFace.FRONT;

			_renderState.applyDepthTest = true;
			_renderState.depthTest = true;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = false;

			_etaRatios = new Vector.<Number>(4, true);

			this.decalMap = decalMap;
			this.environmentMap = environmentMap;
			this.etaRatio = etaRatio;
			this.transmittance = transmittance;
		}

		public function set etaRatio(value:Number):void
		{
//			if (value < 1.0)
//				value = 1.0;
			_etaRatios[0] = value;
			_etaRatios[1] = value * value;
			_etaRatios[2] = 1.0 - _etaRatios[1];
		}

		public function get etaRatio():Number
		{
			return _etaRatios[0];
		}

		/**
		 * 反射率，一般应该设置在0~1之间
		 */
		public function set transmittance(value:Number):void
		{
			_transmittance = value;
			if (_transmittance < 0)
				_transmittance = 0;
		}

		public function get transmittance():Number
		{
			return _transmittance;
		}

		public function get decalMap():TextureMapBase
		{
			return _decalMap;
		}

		public function set decalMap(value:TextureMapBase):void
		{
			_decalMap = value;
		}

		public function get environmentMap():CubeTextureMap
		{
			return _environmentMap;
		}

		public function set environmentMap(value:CubeTextureMap):void
		{
			_environmentMap = value;
		}

		override public function updateShader(shader:Shader):void
		{
			shader.getUniform(ShaderType.VERTEX, "u_etaRatio").setVector(_etaRatios);
			shader.getUniform(ShaderType.FRAGMENT, "u_transmittance").setFloat(_transmittance);
			shader.getTextureVar("u_decalMap").textureMap = _decalMap;
			shader.getTextureVar("u_environmentMap").textureMap = _environmentMap;
		}

		override protected function getVertexSource():String
		{
			var ba:ByteArray = new RefractionVS();
			return ba.readUTFBytes(ba.length);
		}

		override protected function getFragmentSource():String
		{
			var ba:ByteArray = new RefractionFS();
			return ba.readUTFBytes(ba.length);
		}

		override protected function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.TEXCOORD] = "a_texCoord";
			map[BufferType.NORMAL] = "a_normal";
			return map;
		}

		override protected function getBindUniforms(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector.<UniformBindingHelp>
		{
			var list:Vector.<UniformBindingHelp> = new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_worldMatrix", UniformBinding.WorldMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_camPosition", UniformBinding.CameraPosition));
			list.fixed = true;
			return list;
		}
	}
}

