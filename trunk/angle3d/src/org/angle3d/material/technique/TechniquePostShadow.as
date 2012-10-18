package org.angle3d.material.technique
{
	import flash.utils.Dictionary;
	
	import org.angle3d.light.LightType;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.Uniform;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;
	import org.angle3d.texture.TextureMap;

	public class TechniquePostShadow extends Technique
	{
		private var _lightViewProjection:Matrix4f;
		private var _texture:TextureMap;
		
		private var _biasMat:Matrix4f;
		
		public function TechniquePostShadow()
		{
			super("TechniquePostShadow");
			
			_lightViewProjection = new Matrix4f();
			
			_biasMat = new Matrix4f([0.5, 0.0, 0.0, 0.0,
				0.0, 0.5, 0.0, 0.0,
				0.0, 0.0, 0.5, 0.0,
				0.5, 0.5, 0.5, 1.0]);
		}
		
		public function setTexture(texture:TextureMap):void
		{
			_texture = texture;
		}
		
		public function setLightViewProjection(matrix:Matrix4f):void
		{
			_lightViewProjection.copyFrom(matrix);
		}
		
		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader : Shader) : void
		{
			shader.getTextureVar("u_diffuseMap").textureMap = _texture;
		}
		
		override protected function getVertexSource(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : String
		{
			return <![CDATA[
				attribute vec3 a_position;

				uniform mat4 u_WorldViewProjectionMatrix;
				uniform mat4 u_WorldMatrix;
				uniform mat4 u_LightViewProjectionMatrix;
				uniform mat4 u_BiasMatrix;
			
				varying vec4 v_projCoord;
				
				function main(){
					output = m44(a_position,u_WorldViewProjectionMatrix);
			
					vec4 t_worldPos = m44(a_position,u_WorldMatrix);
					vec4 t_coord = m44(t_worldPos,m_LightViewProjectionMatrix);
			
					v_projCoord = m44(t_coord,u_BiasMatrix);
				}]]>;
		}
		
		override protected function getFragmentSource(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : String
		{
			return <![CDATA[
				uniform sampler2D u_ShadowMap;

				function main(){
					vec4 t_coord = v_projCoord;
			t_coord.xyz = divide(t_coord.xyz,t_coord.w);
					
					output = t_diffuseColor;
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
			return map;
		}
		
		override protected function getBindUniforms(lightType : String = LightType.None, meshType : String = MeshType.MT_STATIC) : Vector.<UniformBindingHelp>
		{
			var list : Vector.<UniformBindingHelp> = new Vector.<UniformBindingHelp>();
			list.push(new UniformBindingHelp(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix));
			list.fixed = true;
			return list;
		}
	}
}