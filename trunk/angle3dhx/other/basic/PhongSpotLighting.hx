package org.angle3d.shader.basic;
import flash.display3D.Context3D;
import org.angle3d.shader.Shader;
import org.angle3d.shader.ShaderType;
import org.angle3d.shader.Uniform;
import org.angle3d.shader.UniformBinding;

/**
 * 测试用，PointLight测试
 */
class PhongSpotLighting extends Shader
{
	public function new() 
	{
		super("PhongSpotLighting");
		
		var sources:Array<String> = [];
		
		sources[0] =  
		      "attribute vec3 a_position\n" +
			  "attribute vec3 a_normal\n" +
			  "attribute vec2 a_texCoord\n" +
					  
			  "uniform mat4 u_WorldViewProjectionMatrix\n" +
			  "uniform mat4 u_WorldViewMatrix\n" +
			  "uniform mat3 u_NormalMatrix\n" +
			  "uniform mat4 u_ViewMatrix\n" +
			  "uniform vec4 u_Ambient\n" +
			  "uniform vec4 u_Diffuse\n" +
			  "uniform vec4 u_Specular\n" +
			  "uniform vec4 u_LightColor\n" +
			  "uniform vec4 u_LightPosition\n" +
			  "uniform vec4 u_LightDirection\n" +
						  
			  "varying vec2 v_texCoord\n" +
			  "varying vec4 v_Ambient\n" +
			  "varying vec4 v_Diffuse\n" +
			  "varying vec4 v_Specular\n" +
			  "varying vec3 v_Normal\n" +
			  "varying vec3 v_ViewDir\n" +
			  "varying vec4 v_LightDir\n" +
			  "varying vec4 v_LightDirection\n" +

			  "temp vec4 t_color\n" +
			  "temp vec4 t_wvPosition\n" +
			  "temp vec4 t_wvLightPos\n" +
			  "temp vec3 t_wvNormal\n" +
			  "temp vec3 t_viewDir\n" +
			  "temp vec4 t_lightDir\n" +
			  "temp float t_lightDist\n" +

			  "##main\n" +
						  
			  "op = m44(a_position,u_WorldViewProjectionMatrix)\n" +

			  "t_wvPosition = m44(a_position,u_WorldViewMatrix)\n" +
			  
			  "t_wvNormal = m33(a_normal,u_NormalMatrix)\n" +
			  "t_wvNormal = normalize(t_wvNormal)\n" +
						  
			  //viewDir = normalize(-wvPosition)
			  "t_viewDir = negate(t_wvPosition.xyz)\n" + 
			  "t_viewDir = normalize(t_viewDir)\n" +
						  
			  "t_wvLightPos = u_LightPosition\n" +
			  //方向光时为0，其他情况为1
			  "t_wvLightPos.w = 1.0\n" +
			  "t_wvLightPos = m44(t_wvLightPos,u_ViewMatrix)\n" +
			  "t_wvLightPos.w = u_LightPosition.w\n" +
						  
			  //lights in world space
			  "t_lightDir.xyz = sub(t_wvLightPos.xyz,t_wvPosition.xyz)\n" +
			  
			  "t_lightDist = length3(t_lightDir.xyz)\n" +
			  
			  "t_lightDir.xyz = divide(t_lightDir.xyz,t_lightDist)\n" +
			  
			  "t_lightDist = mul(t_wvLightPos.w,t_lightDist)\n" +
			  "t_lightDist = sub(1.0,t_lightDist)\n" +
			  "t_lightDir.w = clamp(t_lightDist,0.0,1.0)\n" +
			  
			  "t_color = u_Diffuse\n" +
			  "t_color = mul(t_color,u_LightColor)\n" +
			  "v_Diffuse = t_color\n" +
						  
			  "t_color = u_Specular\n" +
			  "t_color.xyz = mul(t_color.xyz,u_LightColor.xyz)\n" +
			  "v_Specular = t_color\n" +
		
			  "v_Normal = t_wvNormal\n" +	

			  "v_ViewDir = t_viewDir\n" +
			  "v_LightDir = t_lightDir\n" +
			  "v_LightDirection = u_LightDirection\n" +
			  "v_texCoord = a_texCoord\n" +
			  "v_Ambient = u_Ambient\n";
						  
		sources[1] =  
		      "texture s_texture\n" +
			  "temp vec4 t_Diffuse\n" +
			  "temp vec4 t_DiffuseSum\n" +
			  "temp vec4 t_SpecularSum\n" +
			  "temp vec4 t_result\n" +

			  "temp float t_diffuseFactor\n" +
			  "temp float t_specularFactor\n" +
			  "temp vec3 t_normal\n" +
			  "temp vec4 t_lightDir\n" +
			  "temp vec3 t_viewDir\n" +
			  
			  "temp float t_spotFallOff\n" +
			  "temp vec3 t_L\n" +
			  "temp vec3 t_spotdir\n" +
			  "temp float t_curAngleCos\n" +
			  "temp float t_innerAngleCos\n" +
			  "temp float t_outerAngleCos\n" +
			  "temp float t_innerMinusOuter\n" +
			  
			  "##main\n" +
			  
			  "t_Diffuse = tex(v_texCoord,s_texture<nearest,nomip,wrap,2d>)\n" +
			  //"t_Diffuse = 1.0\n" +
			  "t_normal = normalize(v_Normal)\n" +
			  "t_lightDir = v_LightDir\n" +
			  "t_lightDir.xyz = normalize(t_lightDir.xyz)\n" +
			  "t_viewDir = v_ViewDir\n" +
			  
			  //compute spotFallOff
			  "t_spotdir.xyz = v_LightDirection.xyz\n" +
			  "t_spotdir = normalize(t_spotdir)\n" +
			  "t_L = t_lightDir.xyz\n" +
			  "t_L = negate(t_L)\n" +
			  "t_curAngleCos = dot3(t_L,t_spotdir)\n" +
			  "t_innerAngleCos = v_LightDirection.w\n" +
			  "t_innerAngleCos = floor(t_innerAngleCos)\n" +
			  "t_innerAngleCos = mul(t_innerAngleCos,0.001)\n" +
			  "t_outerAngleCos = v_LightDirection.w\n" +
			  "t_outerAngleCos = fract(t_outerAngleCos)\n" +
			  "t_innerMinusOuter = sub(t_innerAngleCos,t_outerAngleCos)\n" +
			  "t_spotFallOff = sub(t_curAngleCos,t_outerAngleCos)\n" +
			  "t_spotFallOff = divide(t_spotFallOff,t_innerMinusOuter)\n" +
			  "t_spotFallOff = clamp(t_spotFallOff,0.0,1.0)\n" +
			  
			  "t_lightDir.w = mul(t_lightDir.w,t_spotFallOff)\n" +
			  
			  //computeDiffuse
			  "t_diffuseFactor = computeDiffuse(t_normal,t_lightDir)\n" +
			  //根据距离衰减
			  "t_diffuseFactor = mul(t_diffuseFactor,t_lightDir.w)\n" +
			  //computeSpecular
			  "t_specularFactor = computeSpecular(t_normal,t_viewDir,t_lightDir,v_Specular.w)\n" +
			  //根据距离衰减
			  "t_specularFactor = mul(t_specularFactor,t_lightDir.w)\n" +
			  

			  "t_DiffuseSum = mul(v_Diffuse,t_Diffuse)\n" +
			  "t_DiffuseSum = mul(t_DiffuseSum,t_diffuseFactor)\n" +

			  "t_result = add(v_Ambient,t_DiffuseSum)\n" +
			  "t_SpecularSum = mul(v_Specular,t_specularFactor)\n" +
			  "t_result.xyz = add(t_result.xyz,t_SpecularSum.xyz)\n" +
			  "t_result.w = 1.0\n" +
			  "oc = t_result";  
					  
		setSource(sources);
	}
	
	override private function setUniformBinding():Void
	{
		bindUniform(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix);
		bindUniform(ShaderType.VERTEX, "u_WorldViewMatrix", UniformBinding.WorldViewMatrix);
		bindUniform(ShaderType.VERTEX, "u_NormalMatrix", UniformBinding.NormalMatrix);
		bindUniform(ShaderType.VERTEX, "u_ViewMatrix",UniformBinding.ViewMatrix);
	}
}