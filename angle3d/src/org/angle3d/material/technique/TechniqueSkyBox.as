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
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;
	import org.angle3d.texture.CubeTextureMap;

	/**
	 * 天空体
	 * @author andy
	 */

	public class TechniqueSkyBox extends Technique
	{
		private var _cubeTexture:CubeTextureMap;

		public function TechniqueSkyBox(cubeTexture:CubeTextureMap)
		{
			super("TechniqueSkyBox");

			_cubeTexture=cubeTexture;

			_renderState.applyCullMode=true;
			_renderState.cullMode=Context3DTriangleFace.NONE;

			_renderState.compareMode=Context3DCompareMode.ALWAYS;

			_renderState.applyDepthTest=false;
			_renderState.depthTest=false;

			_renderState.applyBlendMode=false;
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):void
		{
			shader.getTextureVar("t_cubeTexture").textureMap=_cubeTexture;
		}

		override protected function getVertexSource(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):String
		{
			return <![CDATA[
				attribute vec3 a_position;
				
				uniform mat4 u_ViewMatrix;
				uniform mat4 u_ProjectionMatrix;
				uniform mat4 u_WorldMatrix;

				varying vec4 v_direction;

			    function main(){
			        vec4 t_temp;
					t_temp.xyz = m33(a_position.xyz,u_ViewMatrix);
					t_temp.w = 1.0;
			
					output = m44(t_temp,u_ProjectionMatrix);
			
					t_temp.xyz = m33(a_position.xyz,u_WorldMatrix);
					v_direction = t_temp.xyz;
                }]]>;
		}

		override protected function getFragmentSource(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):String
		{
			return <![CDATA[
			    uniform samplerCube t_cubeTexture;
				function main(){
					vec3 t_dir = normalize(v_direction.xyz);
					output = textureCube(t_dir,t_cubeTexture,nomip,linear,clamp);
                }]]>;
		}

		override protected function getBindAttributes(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary=new Dictionary();
			map[BufferType.POSITION]="a_position";
			return map;
		}

		override protected function getBindUniforms(lightType:String=LightType.None, meshType:String=MeshType.MT_STATIC):Vector.<UniformBindingHelp>
		{
			var list:Vector.<UniformBindingHelp>=new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_ViewMatrix", UniformBinding.ViewMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_ProjectionMatrix", UniformBinding.ProjectionMatrix));
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldMatrix", UniformBinding.WorldMatrix));
			list.fixed=true;
			return list;
		}
	}
}

