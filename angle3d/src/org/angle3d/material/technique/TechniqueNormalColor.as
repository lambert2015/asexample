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
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;

	/**
	 * ...
	 * @author andy
	 */

	public class TechniqueNormalColor extends Technique
	{
		private var _influences:Vector.<Number>;

		private var _normalScales:Vector.<Number>;

		public function TechniqueNormalColor()
		{
			super("TechniqueNormalColor");

			_renderState.applyCullMode=true;
			_renderState.cullMode=Context3DTriangleFace.FRONT;

			_renderState.applyDepthTest=true;
			_renderState.depthTest=true;
			_renderState.compareMode=Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode=false;

			_normalScales=new Vector.<Number>(4, true);
			_normalScales[3]=1.0;

			normalScale=new Vector3f(1, 1, 1);
		}

		public function set influence(value:Number):void
		{
			if (_influences == null)
				_influences=new Vector.<Number>(4, true);
			_influences[0]=1 - value;
			_influences[1]=value;
		}

		public function get influence():Number
		{
			return _influences[1];
		}

		public function set normalScale(value:Vector3f):void
		{
			_normalScales[0]=value.x;
			_normalScales[1]=value.y;
			_normalScales[2]=value.z;
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):void
		{
			shader.getUniform(ShaderType.FRAGMENT, "u_scale").setVector(_normalScales);

			var uniform:Uniform=shader.getUniform(ShaderType.VERTEX, "u_influences");
			if (uniform != null)
			{
				uniform.setVector(_influences);
			}
		}

		override protected function getVertexSource(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):String
		{
			return <![CDATA[
				attribute vec3 a_position;
				attribute vec3 a_normal;
				
				#ifdef(USE_KEYFRAME){
					attribute vec3 a_position1;
					attribute vec3 a_normal1;
					uniform vec4 u_influences;
				}
			
				varying vec4 v_normal;
			
				uniform mat4 u_WorldViewProjectionMatrix;

				function main()
				{
					#ifdef(USE_KEYFRAME){
						vec3 morphed0;
						morphed0 = mul(a_position,u_influences.x);
						vec3 morphed1;
						morphed1 = mul(a_position1,u_influences.y);
						vec4 morphed;
						morphed.xyz = add(morphed0,morphed1);
						morphed.w = 1.0;
						output = m44(morphed,u_WorldViewProjectionMatrix);
			
						vec3 normalMorphed0;
						normalMorphed0 = mul(a_normal,u_influences.x);
						vec3 normalMorphed1;
						normalMorphed1 = mul(a_normal1,u_influences.y);
						vec3 normalMorphed;
						normalMorphed = add(normalMorphed0,normalMorphed1);
						normalMorphed = normalize(normalMorphed);
						v_normal = normalMorphed;
					}
					#else {
						output = m44(a_position,u_WorldViewProjectionMatrix);
						v_normal = a_normal;
					}
				}]]>;
		}

		override protected function getFragmentSource(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):String
		{
			return <![CDATA[
			
				uniform vec4 u_scale;
				temp vec4 t_normal;
				temp vec4 t_color;
	
			    function main()
				{
					t_normal = mul(v_normal,u_scale);
					t_normal = add(t_normal,u_scale);
					t_color.xyz = t_normal.xyz;
					t_color.w = 1.0;
					output = t_color;
				}]]>;
		}

		override protected function getOption(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):Vector.<Vector.<String>>
		{
			return super.getOption(lightType, meshType);
		}

		override protected function getKey(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):String
		{
			var result:Array=[_name, meshType];
			return result.join("_");
		}

		override protected function getBindAttributes(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary=new Dictionary();
			map[BufferType.POSITION]="a_position";
			map[BufferType.NORMAL]="a_normal";

			if (meshType == MeshType.MT_MORPH_ANIMATION)
			{
				map[BufferType.POSITION1]="a_position1";
				map[BufferType.NORMAL1]="a_normal1";
			}
			return map;
		}

		override protected function getBindUniforms(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):Vector.<UniformBindingHelp>
		{
			var list:Vector.<UniformBindingHelp>=new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
			list.fixed=true;
			return list;
		}
	}
}

