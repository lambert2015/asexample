package org.angle3d.material.technique
{
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;

	public class TechniquePreShadow extends Technique
	{
		public function TechniquePreShadow(name:String)
		{
			super(name);
		}

		override protected function getVertexSource():String
		{
			return <![CDATA[
				attribute vec3 a_position;
				attribute vec2 a_texCoord;

				varying vec4 v_texCoord;
				
				uniform mat4 u_WorldViewProjectionMatrix;
				
				function main(){
					output = m44(a_position,u_WorldViewProjectionMatrix);
					v_texCoord = a_texCoord;
				}]]>;
		}

		override protected function getFragmentSource():String
		{
			return <![CDATA[
				uniform sampler2D u_diffuseMap;

				function main(){
					vec4 t_diffuseColor = texture2D(v_texCoord,u_diffuseMap,nomip,linear,clamp);
					t_diffuseColor = t_diffuseColor.a;
					output = t_diffuseColor;
				}]]>;
		}

		override protected function getKey(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			var result:Array = [_name, meshType];
			return result.join("_");
		}

		override protected function getBindAttributes(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Dictionary
		{
			var map:Dictionary = new Dictionary();
			map[BufferType.POSITION] = "a_position";
			map[BufferType.TEXCOORD] = "a_texCoord";
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
