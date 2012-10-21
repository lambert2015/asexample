package org.angle3d.material.technique
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.BlendMode;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.Uniform;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.math.Color;
	import org.angle3d.math.FastMath;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;

	/**
	 * ...
	 * @author andy
	 */

	public class TechniqueFill extends Technique
	{
		private var _color:Color;

		private var _influences:Vector.<Number>;

		public function TechniqueFill(color:uint=0xFFFFF)
		{
			super("FillTechnique");

			_renderState.applyDepthTest=true;
			_renderState.depthTest=true;
			_renderState.compareMode=Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode=false;

			_color=new Color(0, 0, 0, 1);

			this.color=color;
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

		public function set color(color:uint):void
		{
			_color.setRGB(color);
		}

		public function set alpha(alpha:Number):void
		{
			_color.a=FastMath.fclamp(alpha, 0.0, 1.0);

			if (alpha < 1)
			{
				_renderState.applyBlendMode=true;
				_renderState.blendMode=BlendMode.Alpha;
			}
			else
			{
				_renderState.applyBlendMode=false;
				_renderState.blendMode=BlendMode.Off;
			}
		}

		public function get alpha():Number
		{
			return _color.a;
		}

		public function get color():uint
		{
			return _color.getColor();
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):void
		{
			shader.getUniform(ShaderType.VERTEX, "u_color").setColor(_color);

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
				varying vec4 v_color;
				uniform mat4 u_WorldViewProjectionMatrix;
				uniform vec4 u_color;
			
				#ifdef(USE_KEYFRAME){
				    attribute vec3 a_position1;
				    uniform vec4 u_influences;
				}
			
				function main(){
			    	#ifdef(USE_KEYFRAME){
				        vec3 morphed0;
				        morphed0 = mul(a_position,u_influences.x);
				        vec3 morphed1;
				        morphed1 = mul(a_position1,u_influences.y);
				        vec4 morphed;
				        morphed.xyz = add(morphed0,morphed1);
				        morphed.w = 1.0;
				        output = m44(morphed,u_WorldViewProjectionMatrix);
				    }
				    #else {
				        output = m44(a_position,u_WorldViewProjectionMatrix);
				    }
				    v_color = u_color;
                }]]>;
		}

		override protected function getFragmentSource(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):String
		{
			return <![CDATA[
               function main(){
			       output = v_color;
                }]]>;
		}

		override protected function getOption(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):Vector.<Vector.<String>>
		{
			return super.getOption(lightType, meshType);
		}

		override protected function getBindAttributes(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary=new Dictionary();
			map[BufferType.POSITION]="a_position";

			if (meshType == MeshType.MT_MORPH_ANIMATION)
			{
				map[BufferType.POSITION1]="a_position1";
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

