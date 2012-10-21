package org.angle3d.material.technique
{
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

	/**
	 * ...
	 * @author andy
	 */

	public class TechniqueTexture extends Technique
	{
		private var _texture:TextureMapBase;

		private var _lightmap:TextureMapBase;

		private var _useTexCoord2:Boolean;

		private var _influences:Vector.<Number>;

		private var _skinningMatrices:Vector.<Number>;

		public function TechniqueTexture()
		{
			super("TechniqueTexture");

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

		override protected function getVertexSource(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			var source:String = "attribute vec3 a_position;" + "attribute vec2 a_texCoord;" +

				"varying vec4 v_texCoord;" +

				"#ifdef(lightmap && useTexCoord2){" + "   attribute vec2 a_texCoord2;" + "   varying vec4 v_texCoord2;" + "}" +

				"uniform mat4 u_WorldViewProjectionMatrix;" +

				"#ifdef(USE_KEYFRAME){" + "   attribute vec3 a_position1;" + "   uniform vec4 u_influences;" + "}" + "#elseif(USE_SKINNING){" + "	attribute vec4 a_boneWeights;" + "	attribute vec4 a_boneIndices;" + "	uniform vec4 u_boneMatrixs[" + Skeleton.MAX_BONE_COUNT * 3 + "];" + "}" +


				"function main(){" + "	#ifdef(USE_KEYFRAME){" + "		vec3 morphed0 = mul(a_position,u_influences.x);" + "		vec3 morphed1 = mul(a_position1,u_influences.y);" + "		vec4 morphed;" + "		morphed.xyz = add(morphed0,morphed1);" + "		morphed.w = 1.0;" + "		output = m44(morphed,u_WorldViewProjectionMatrix);" + "	}" + "	#elseif(USE_SKINNING){" + "		mat3 t_skinTransform;" + "		vec4 t_vec;" + "		vec4 t_vec1;" + "		vec4 t_boneIndexVec = mul(a_boneIndices,3);" +

				//计算最终蒙皮矩阵
				"		t_vec1 = mul(a_boneWeights.x,u_boneMatrixs[t_boneIndexVec.x]);" + "		t_vec  = mul(a_boneWeights.y,u_boneMatrixs[t_boneIndexVec.y]);" + "		t_vec1 = add(t_vec1,t_vec);" + "		t_vec  = mul(a_boneWeights.z,u_boneMatrixs[t_boneIndexVec.z]);" + "		t_vec1 = add(t_vec1,t_vec);" + "		t_vec  = mul(a_boneWeights.w,u_boneMatrixs[t_boneIndexVec.w]);" + "		t_skinTransform[0] = add(t_vec1,t_vec);" +

				"		t_vec1 = mul(a_boneWeights.x,u_boneMatrixs[t_boneIndexVec.x + 1]);" + "		t_vec  = mul(a_boneWeights.y,u_boneMatrixs[t_boneIndexVec.y + 1]);" + "		t_vec1 = add(t_vec1,t_vec);" + "		t_vec  = mul(a_boneWeights.z,u_boneMatrixs[t_boneIndexVec.z + 1]);" + "		t_vec1 = add(t_vec1,t_vec);" + "		t_vec  = mul(a_boneWeights.w,u_boneMatrixs[t_boneIndexVec.w + 1]);" + "		t_skinTransform[1] = add(t_vec1,t_vec);" +

				"		t_vec1 = mul(a_boneWeights.x,u_boneMatrixs[t_boneIndexVec.x + 2]);" + "		t_vec  = mul(a_boneWeights.y,u_boneMatrixs[t_boneIndexVec.y + 2]);" + "		t_vec1 = add(t_vec1,t_vec);" + "		t_vec  = mul(a_boneWeights.z,u_boneMatrixs[t_boneIndexVec.z + 2]);" + "		t_vec1 = add(t_vec1,t_vec);" + "		t_vec  = mul(a_boneWeights.w,u_boneMatrixs[t_boneIndexVec.w + 2]);" + "		t_skinTransform[2] = add(t_vec1,t_vec);" +

				"		vec4 t_localPos;" + "		t_localPos.xyz = m34(a_position,t_skinTransform);" + "		t_localPos.w = 1.0;" + "		output = m44(t_localPos,u_WorldViewProjectionMatrix);" + "	}" + "	#else {" + "		output = m44(a_position,u_WorldViewProjectionMatrix);" + "	}" + "	v_texCoord = a_texCoord;" + "	#ifdef( lightmap && useTexCoord2){" + "		v_texCoord2 = a_texCoord2;" + "	}" + "}";
			return source;
		}

		override protected function getFragmentSource(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			return <![CDATA[
			
			    temp vec4 t_textureMapColor;
			
				uniform sampler2D s_texture;
			
				#ifdef(lightmap){
				    temp vec4 t_lightMapColor;
			        uniform sampler2D s_lightmap;
			    }
			
				function main(){
				    t_textureMapColor = texture2D(v_texCoord,s_texture,linear,nomip,wrap);
			
				    #ifdef(lightmap){
				        #ifdef(useTexCoord2){
				            t_lightMapColor = texture2D(v_texCoord2,s_lightmap,linear,nomip,wrap);
				        }
				        #else{
				            t_lightMapColor = texture2D(v_texCoord,s_lightmap,linear,nomip,wrap);
				        }

				        t_textureMapColor = multiply(t_textureMapColor,t_lightMapColor);
			        }
			        output = t_textureMapColor;
			    }]]>;
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
			_keys.push(_name);
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

			if (meshType == MeshType.MT_MORPH_ANIMATION)
			{
				map[BufferType.POSITION1] = "a_position1";
			}
			else if (meshType == MeshType.MT_SKELETAL_ANIMATION)
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

