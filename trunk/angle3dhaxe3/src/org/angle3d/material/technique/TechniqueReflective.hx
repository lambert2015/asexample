package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.Uniform;
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
	class TechniqueReflective extends Technique
	{
		[Embed(source = "data/reflective.vs", mimeType = "application/octet-stream")]
		private static var ReflectiveVS:Class;
		[Embed(source = "data/reflective.fs", mimeType = "application/octet-stream")]
		private static var ReflectiveFS:Class;

		private var _influences:Vector<Float>;

		private var _decalMap:TextureMapBase;

		private var _environmentMap:CubeTextureMap;

		private var _reflectivity:Float;

		public function TechniqueReflective(decalMap:TextureMapBase, environmentMap:CubeTextureMap, reflectivity:Float = 0.5)
		{
			super();

			_renderState.applyCullMode = true;
			_renderState.cullMode = Context3DTriangleFace.FRONT;

			_renderState.applyDepthTest = true;
			_renderState.depthTest = true;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = false;

			this.decalMap = decalMap;
			this.environmentMap = environmentMap;
			this.reflectivity = reflectivity;
		}

		public function set influence(value:Float):Void
		{
			if (_influences == null)
				_influences = new Vector<Float>(4, true);
			_influences[0] = 1 - value;
			_influences[1] = value;
		}

		public function get influence():Float
		{
			return _influences[1];
		}

		/**
		 * 反射率，一般应该设置在0~1之间
		 */
		public function set reflectivity(value:Float):Void
		{
			_reflectivity = value;
			if (_reflectivity < 0)
				_reflectivity = 0;
		}

		public function get reflectivity():Float
		{
			return _reflectivity;
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
			shader.getUniform(ShaderType.FRAGMENT, "u_reflectivity").setFloat(_reflectivity);
			shader.getTextureVar("u_decalMap").textureMap = _decalMap;
			shader.getTextureVar("u_environmentMap").textureMap = _environmentMap;

			var uniform:Uniform = shader.getUniform(ShaderType.VERTEX, "u_influences");
			if (uniform != null)
			{
				uniform.setVector(_influences);
			}
		}

		override private function getVertexSource():String
		{
			var ba:ByteArray = new ReflectiveVS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getFragmentSource():String
		{
			var ba:ByteArray = new ReflectiveFS();
			return ba.readUTFBytes(ba.length);
		}

		override private function getKey(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			var result:Array = [name, meshType];
			return result.join("_");
		}

		override private function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.TEXCOORD] = "a_texCoord";
			map[BufferType.NORMAL] = "a_normal";
			if (meshType == MeshType.MT_KEYFRAME)
			{
				map[BufferType.POSITION1] = "a_position1";
				map[BufferType.NORMAL1] = "a_normal1";
			}
			return map;
		}

		override private function getBindUniforms(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector<UniformBindingHelp>
		{
			var list:Vector<UniformBindingHelp> = new Vector<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_worldMatrix", UniformBinding.WorldMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_camPosition", UniformBinding.CameraPosition));
			list.fixed = true;
			return list;
		}
	}
}

