package org.angle3d.material.technique;

import flash.utils.Dictionary;
import haxe.ds.StringMap;

import org.angle3d.light.LightType;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.UniformBinding;
import org.angle3d.material.shader.UniformBindingHelp;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.MeshType;

class TechniquePreShadow extends Technique
{
	public function new(name:String)
	{
		super();
	}

	override private function getVertexSource():String
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

	override private function getFragmentSource():String
	{
		return <![CDATA[
			uniform sampler2D u_diffuseMap;

			function main(){
				vec4 t_diffuseColor = texture2D(v_texCoord,u_diffuseMap,nomip,linear,clamp);
				t_diffuseColor = t_diffuseColor.a;
				output = t_diffuseColor;
			}]]>;
	}

	override private function getKey(lightType:LightType, meshType:MeshType):String
	{
		var result:Array = [_name, meshType];
		return result.join("_");
	}

	override private function getBindAttributes(lightType:LightType, meshType:MeshType):StringMap<String>
	{
		var map:StringMap<String> = new StringMap<String>();
		map.set(BufferType.POSITION, "a_position");
		map.set(BufferType.TEXCOORD, "a_texCoord");
		return map;
	}

	override private function getBindUniforms(lightType:LightType, meshType:MeshType):Array<UniformBindingHelp>
	{
		var list:Array<UniformBindingHelp> = new Array<UniformBindingHelp>();
		list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
		
		return list;
	}
}
