package org.angle3d.material.technique
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.angle3d.animation.Skeleton;
	import org.angle3d.light.LightType;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.Uniform;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;
	import org.angle3d.texture.TextureMapBase;
	import org.angle3d.utils.StringUtil;

	/**
	 * ...
	 * @author andy
	 */

	public class TechniqueTexture extends Technique
	{
		[Embed(source = "data/texture.vs", mimeType = "application/octet-stream")]
		private static var TextureVS:Class;
		[Embed(source = "data/texture.fs", mimeType = "application/octet-stream")]
		private static var TextureFS:Class;

		private var _texture:TextureMapBase;

		private var _lightmap:TextureMapBase;

		private var _useTexCoord2:Boolean;

		private var _influences:Vector.<Number>;

		private var _skinningMatrices:Vector.<Number>;

		public function TechniqueTexture()
		{
			super();

			_useTexCoord2 = false;
			_texture = null;
			_lightmap = null;
		}

		public function set influence(value:Number):void
		{
			if (_influences == null)
				_influences = new Vector.<Number>(4, true);
			_influences[0] = 1 - value;
			_influences[1] = value;
		}

		public function set skinningMatrices(data:Vector.<Number>):void
		{
			_skinningMatrices = data;
		}

		public function get influence():Number
		{
			return _influences[1];
		}

		public function set useTexCoord2(value:Boolean):void
		{
			_useTexCoord2 = value;
		}

		public function get texture():TextureMapBase
		{
			return _texture;
		}

		public function set texture(value:TextureMapBase):void
		{
			_texture = value;
		}

		public function get lightmap():TextureMapBase
		{
			return _lightmap;
		}

		public function set lightmap(value:TextureMapBase):void
		{
			_lightmap = value;
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):void
		{
			shader.getTextureVar("s_texture").textureMap = _texture;

			if (_lightmap != null)
			{
				shader.getTextureVar("s_lightmap").textureMap = _lightmap;
			}

			var uniform:Uniform = shader.getUniform(ShaderType.VERTEX, "u_influences");
			if (uniform != null)
			{
				uniform.setVector(_influences);
			}

			uniform = shader.getUniform(ShaderType.VERTEX, "u_boneMatrixs");
			if (uniform != null)
			{
				uniform.setVector(_skinningMatrices);
			}
		}

		override protected function getVertexSource():String
		{
			var ba:ByteArray = new TextureVS();
			var source:String = ba.readUTFBytes(ba.length);
			source = StringUtil.format(source, Skeleton.MAX_BONE_COUNT * 3);
			return source;
		}

		override protected function getFragmentSource():String
		{
			var ba:ByteArray = new TextureFS();
			return ba.readUTFBytes(ba.length);
		}

		override protected function getOption(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector.<Vector.<String>>
		{
			var results:Vector.<Vector.<String>> = super.getOption(lightType, meshType);

			if (_lightmap != null)
			{
				results[0].push("lightmap");
				results[1].push("lightmap");
				if (_useTexCoord2)
				{
					results[0].push("useTexCoord2");
					results[1].push("useTexCoord2");
				}
			}
			return results;
		}

		//TODO 优化，key应该缓存，不需要每次都计算
		override protected function getKey(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			_keys.length = 0;
			_keys.push(name);
			_keys.push(meshType);

			if (_lightmap != null)
			{
				_keys.push("lightmap");
				if (_useTexCoord2)
				{
					_keys.push("useTexCoord2");
				}
			}
			return _keys.join("_");
		}

		override protected function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.TEXCOORD] = "a_texCoord";

			if (_lightmap != null && _useTexCoord2)
			{
				map[BufferType.TEXCOORD2] = "a_texCoord2";
			}

			if (meshType == MeshType.MT_KEYFRAME)
			{
				map[BufferType.POSITION1] = "a_position1";
			}
			else if (meshType == MeshType.MT_SKINNING)
			{
				map[BufferType.BONE_INDICES] = "a_boneIndices";
				map[BufferType.BONE_WEIGHTS] = "a_boneWeights";
			}

			return map;
		}

		override protected function getBindUniforms(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector.<UniformBindingHelp>
		{
			var list:Vector.<UniformBindingHelp> = new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
			list.fixed = true;
			return list;
		}
	}
}

