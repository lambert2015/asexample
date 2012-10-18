package org.angle3d.material.technique;
import flash.display3D.textures.Texture;
import org.angle3d.light.LightType;
import org.angle3d.scene.mesh.MeshType;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.shader.Shader;
import org.angle3d.material.shader.UniformBinding;
import org.angle3d.texture.TextureMapBase;

/**
 * ...
 * @author andy
 */

class TechniqueTexture extends Technique
{
	private var _texture:TextureMapBase;
	public var texture(_getTexture, _setTexture):TextureMapBase;
	
	private var _lightmap:TextureMapBase;
	public var lightmap(_getLightmap, _setLightmap):TextureMapBase;
	
	private var _useTexCoord2:Bool;

	public function new() 
	{
		super("TechniqueTexture");
		
		_useTexCoord2 = false;
		_texture = null;
		_lightmap = null;
	}
	
	public function setUseTexCoord2(value:Bool):Void
	{
		_useTexCoord2 = value;
	}
	
	private function _getTexture():TextureMapBase
	{
		return _texture;
	}

	private function _setTexture(value:TextureMapBase):TextureMapBase
	{
		_texture = value;
		return _texture;
	}

	private function _getLightmap():TextureMapBase
	{
		return _lightmap;
	}

	private function _setLightmap(value:TextureMapBase):TextureMapBase
	{
		_lightmap = value;
		
		return _lightmap;
	}
	
	/**
	 * 更新Uniform属性
	 * @param	shader
	 */
	override public function updateShader(shader:Shader):Void
	{
		shader.getTextureVar("s_texture").textureMap = _texture;
		
		if (_lightmap != null)
		{
			shader.getTextureVar("s_lightmap").textureMap = _lightmap;
		}
	}
	
	override private function getVertexSource():String
	{
		return "attribute vec3 a_position\n" +
				"attribute vec2 a_texCoord\n" +
				"varying vec2 v_texCoord\n" +
				
				"#if lightmap&useTexCoord2\n"+
				    "attribute vec2 a_texCoord2\n" +
				    "varying vec2 v_texCoord2\n" +
				"#end\n" +
				
				"uniform mat4 u_WorldViewProjectionMatrix\n" +
				"@main\n" +
				"op = m44(a_position,u_WorldViewProjectionMatrix)\n" +
				"v_texCoord = a_texCoord\n" +
				
				"#if lightmap&useTexCoord2\n"+
				    "v_texCoord2 = a_texCoord2\n" +
				"#end";
	}
	
	override private function getFragmentSource():String
	{
		return "temp vec4 t_textureMapColor\n" +
				"texture s_texture\n" +
				
				"#if lightmap\n" +
				    "temp vec4 t_lightMapColor\n" +
				    "texture s_lightmap\n" +
				"#end\n" +
				
				"@main\n" +
				"t_textureMapColor = texture(v_texCoord,s_texture<linear,nomip,wrap,2d>)\n" +
				
				"#if lightmap\n" +
				    "#if useTexCoord2\n" +
						"t_lightMapColor = tex(v_texCoord2,s_lightmap<linear,nomip,wrap,2d>)\n" +
					"#else\n" +
						"t_lightMapColor = tex(v_texCoord,s_lightmap<linear,nomip,wrap,2d>)\n" +
					"#end\n" +
				    "t_textureMapColor = multiply(t_textureMapColor,t_lightMapColor)\n" +
				"#end\n" +
				
				"oc = t_textureMapColor\n";
	}
	
	override private function _createOption(lightType:Int = -1, meshType:Int = 0):Array<Array<String>>
	{
		if (_lightmap != null)
		{
			if (_useTexCoord2)
			{
				return [["lightmap", "useTexCoord2"], ["lightmap", "useTexCoord2"]];
			}
			else
			{
				return [["lightmap"],["lightmap"]];
			}
		}
		return null;
	}
	
	override private function _getKey(lightType:Int = -1, meshType:Int = 0):String
	{
		var result:Array<String> = [_name];
		
		if (meshType != 0)
		{
			result.push(Type.enumConstructor(meshType));
		}
		
		if (_lightmap != null)
		{
			result.push("lightmap");
			if (_useTexCoord2)
			{
				result.push("useTexCoord2");
			}
		}
		return result.join("_");
	}
	
	override private function _initUniformBindings():Void
	{
		addUniformBinding(ShaderType.VERTEX, "u_WorldViewProjectionMatrix", UniformBinding.WorldViewProjectionMatrix);
	}
	
}