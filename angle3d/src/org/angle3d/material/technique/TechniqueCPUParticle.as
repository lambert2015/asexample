package org.angle3d.material.technique
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.utils.Dictionary;

	import org.angle3d.light.LightType;
	import org.angle3d.material.BlendMode;
	import org.angle3d.material.shader.Shader;
	import org.angle3d.material.shader.ShaderType;
	import org.angle3d.material.shader.UniformBinding;
	import org.angle3d.material.shader.UniformBindingHelp;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.MeshType;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * ...
	 * @author andy
	 */

	public class TechniqueCPUParticle extends Technique
	{
		private var _texture:TextureMapBase;

		public function TechniqueCPUParticle()
		{
			super("TechniqueCPUParticle");

			_renderState.applyCullMode = true;
			_renderState.cullMode = Context3DTriangleFace.FRONT;

			_renderState.applyDepthTest = true;
			_renderState.depthTest = false;
			_renderState.compareMode = Context3DCompareMode.LESS_EQUAL;

			_renderState.applyBlendMode = true;
			_renderState.blendMode = BlendMode.AlphaAdditive;
		}

		public function get texture():TextureMapBase
		{
			return _texture;
		}

		public function set texture(value:TextureMapBase):void
		{
			_texture = value;
		}

		/**
		 * 更新Uniform属性
		 * @param	shader
		 */
		override public function updateShader(shader:Shader):void
		{
			shader.getTextureVar("s_texture").textureMap = _texture;
		}

		override protected function getVertexSource(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			var source:String = "attribute vec3 a_position;" + 
				"attribute vec2 a_texCoord;" + 
				"attribute vec4 a_color;" +

				"varying vec4 v_texCoord;" + 
				"varying vec4 v_color;" +

				"uniform mat4 u_WorldViewProjectionMatrix;" +

				"function main(){" + 
				"	output = m44(a_position,u_WorldViewProjectionMatrix);" + 
				"	v_texCoord = a_texCoord;" + 
				"	v_color = a_color;" + 
				"}";
			return source;
		}

		override protected function getFragmentSource(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):String
		{
			return <![CDATA[
				uniform sampler2D s_texture;
				function main(){
					vec4 t_diffuseColor = texture2D(v_texCoord,s_texture,linear,nomip,clamp);
					t_diffuseColor = mul(t_diffuseColor,v_color);
					output = t_diffuseColor;
				}]]>;
		}

		override protected function getOption(lightType:String = LightType.None, meshType:String = MeshType.MT_STATIC):Vector.<Vector.<String>>
		{
			var results:Vector.<Vector.<String>> = super.getOption(lightType, meshType);
			return results;
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
			map[BufferType.COLOR] = "a_color";
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

