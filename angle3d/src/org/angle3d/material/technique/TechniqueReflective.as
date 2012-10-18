package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.Uniform;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.math.Color;
	import org.angle3d.math.FastMath;
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
	public class TechniqueReflective extends Technique
	{
		private var _influences : Vector.<Number>;

		private var _decalMap : TextureMapBase;

		private var _environmentMap : CubeTextureMap;

		private var _reflectivity : Number;

		public function TechniqueReflective(decalMap : TextureMapBase, environmentMap : CubeTextureMap, reflectivity : Number = 0.5)
		{
			super("TechniqueReflective");

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

		public function set influence(value : Number) : void
		{
			if (_influences == null)
				_influences = new Vector.<Number>(4, true);
			_influences[0] = 1 - value;
			_influences[1] = value;
		}

		public function get influence() : Number
		{
			return _influences[1];
		}

		/**
		 * 反射率，一般应该设置在0~1之间
		 */
		public function set reflectivity(value : Number) : void
		{
			_reflectivity = value;
			if (_reflectivity < 0)
				_reflectivity = 0;
		}

		public function get reflectivity() : Number
		{
			return _reflectivity;
		}

		public function get decalMap() : TextureMapBase
		{
			return _decalMap;
		}

		public function set decalMap(value : TextureMapBase) : void
		{
			_decalMap = value;
		}

		public function get environmentMap() : CubeTextureMap
		{
			return _environmentMap;
		}

		public function set environmentMap(value : CubeTextureMap) : void
		{
			_environmentMap = value;
		}

		override public function updateShader(shader : Shader) : void
		{
			shader.getUniform(ShaderType.FRAGMENT, "u_reflectivity").setFloat(_reflectivity);
			shader.getTextureVar("u_decalMap").textureMap = _decalMap;
			shader.getTextureVar("u_environmentMap").textureMap = _environmentMap;

			var uniform : Uniform = shader.getUniform(ShaderType.VERTEX, "u_influences");
			if (uniform != null)
			{
				uniform.setVector(_influences);
			}
		}

		override protected function getVertexSource(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : String
		{
			return <![CDATA[
				attribute vec3 a_position;
				attribute vec2 a_texCoord;
				attribute vec3 a_normal;
			
				#ifdef(USE_KEYFRAME){
					attribute vec3 a_position1;
					attribute vec3 a_normal1;
					uniform vec4 u_influences;
				}

				varying vec4 v_texCoord;
				varying vec4 v_R;
				
				uniform mat4 u_WorldViewProjectionMatrix;
				uniform mat4 u_worldMatrix;
				uniform vec4 u_camPosition;
				
				function main(){
					#ifdef(USE_KEYFRAME){
						vec3 morphed0;
						morphed0 = mul(a_position,u_influences.x);
						vec3 morphed1;
						morphed1 = mul(a_position1,u_influences.y);
						vec4 t_position;
						t_position.xyz = add(morphed0,morphed1);
						t_position.w = 1.0;
						output = m44(t_position,u_WorldViewProjectionMatrix);
						
						vec3 normalMorphed0;
						normalMorphed0 = mul(a_normal,u_influences.x);
						vec3 normalMorphed1;
						normalMorphed1 = mul(a_normal1,u_influences.y);
						vec3 t_normal = add(normalMorphed0,normalMorphed1);

					}
					#else {
						vec4 t_position;
						t_position.xyz = a_position;
						t_position.w = 1.0;
						output = m44(t_position,u_WorldViewProjectionMatrix);
						vec3 t_normal = a_normal;
					}

			        vec3 t_N = m33(t_normal.xyz,u_worldMatrix);
			        t_N = normalize(t_N);

			        vec4 t_positionW = m44(t_position,u_worldMatrix);
			        vec3 t_I = sub(t_positionW.xyz,u_camPosition.xyz);
			
			        v_R = reflect(t_I,t_N);
			        v_texCoord = a_texCoord;
				}]]>;
		}

		override protected function getFragmentSource(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : String
		{
			return <![CDATA[
			    
				uniform vec4 u_reflectivity;
				uniform sampler2D u_decalMap;
				uniform samplerCube u_environmentMap;
			
				function lerp(vec4 source1,vec4 source2,float percent){
					float t_percent1 = percent;
					t_percent1 = sub(1.0,t_percent1);
					vec4 t_local1 = mul(source1,t_percent1);
					vec4 t_local2 = mul(source2,percent);
					return add(t_local1,t_local2);
				}
			
				function main(){
					vec4 t_reflectedColor = textureCube(v_R,u_environmentMap,nomip,linear,clamp);
					vec4 t_decalColor = texture2D(v_texCoord,u_decalMap,nomip,linear,clamp);
					output = lerp(t_decalColor.xyzw,t_reflectedColor.xyzw,u_reflectivity.x);
				}]]>;
		}

		override protected function getKey(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : String
		{
			var result : Array = [_name, meshType];
			return result.join("_");
		}

		override protected function getBindAttributes(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : Dictionary
		{
			var map : Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.TEXCOORD] = "a_texCoord";
			map[BufferType.NORMAL] = "a_normal";
			if (meshType == MeshType.MT_MORPH_ANIMATION)
			{
				map[BufferType.POSITION1] = "a_position1";
				map[BufferType.NORMAL1] = "a_normal1";
			}
			return map;
		}

		override protected function getBindUniforms(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : Vector.<UniformBindingHelp>
		{
			var list : Vector.<UniformBindingHelp> = new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_worldMatrix", UniformBinding.WorldMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_camPosition", UniformBinding.CameraPosition));
			list.fixed = true;
			return list;
		}
	}
}

