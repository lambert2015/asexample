package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
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
	public class TechniqueRefraction extends Technique
	{
		private var _decalMap : TextureMapBase;

		private var _environmentMap : CubeTextureMap;

		private var _transmittance : Number;

		private var _etaRatios : Vector.<Number>;

		public function TechniqueRefraction(decalMap : TextureMapBase, environmentMap : CubeTextureMap, etaRatio : Number = 1.5, transmittance : Number = 0.5)
		{
			super("TechniqueReflective");

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

		public function set etaRatio(value : Number) : void
		{
//			if (value < 1.0)
//				value = 1.0;
			_etaRatios[0] = value;
			_etaRatios[1] = value * value;
			_etaRatios[2] = 1.0 - _etaRatios[1];
		}

		public function get etaRatio() : Number
		{
			return _etaRatios[0];
		}

		/**
		 * 反射率，一般应该设置在0~1之间
		 */
		public function set transmittance(value : Number) : void
		{
			_transmittance = value;
			if (_transmittance < 0)
				_transmittance = 0;
		}

		public function get transmittance() : Number
		{
			return _transmittance;
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
			shader.getUniform(ShaderType.VERTEX, "u_etaRatio").setVector(_etaRatios);
			shader.getUniform(ShaderType.FRAGMENT, "u_transmittance").setFloat(_transmittance);
			shader.getTextureVar("u_decalMap").textureMap = _decalMap;
			shader.getTextureVar("u_environmentMap").textureMap = _environmentMap;
		}

		override protected function getVertexSource(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : String
		{
			return <![CDATA[
				attribute vec3 a_position;
				attribute vec2 a_texCoord;
				attribute vec3 a_normal;
				
				varying vec4 v_texCoord;
				varying vec4 v_refract;
				
				uniform mat4 u_WorldViewProjectionMatrix;
				uniform mat4 u_worldMatrix;
				uniform vec4 u_camPosition;
			    uniform vec4 u_etaRatio;
				
				function main(){
					output = m44(a_position,u_WorldViewProjectionMatrix);

					vec3 t_N = m33(a_normal.xyz,u_worldMatrix);
					t_N = normalize(t_N);

					vec4 t_positionW = m44(a_position,u_worldMatrix);
					vec3 t_I = sub(t_positionW.xyz,u_camPosition.xyz);
			        t_I = normalize(t_I);
			
					v_refract = refract(t_I,t_N,u_etaRatio);
					v_texCoord = a_texCoord;
				}]]>;
		}

		override protected function getFragmentSource(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : String
		{
			return <![CDATA[
				
				uniform vec4 u_transmittance;
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
					vec4 t_reflectedColor = textureCube(v_refract,u_environmentMap,nomip,linear,clamp);
					vec4 t_decalColor = texture2D(v_texCoord,u_decalMap,nomip,linear,clamp);
					output = lerp(t_decalColor,t_reflectedColor,u_transmittance.x);
				}]]>;
		}

		override protected function getBindAttributes(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : Dictionary
		{
			var map : Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.TEXCOORD] = "a_texCoord";
			map[BufferType.NORMAL] = "a_normal";
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

