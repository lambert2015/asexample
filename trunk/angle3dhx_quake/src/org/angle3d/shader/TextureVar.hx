package org.angle3d.shader;
import flash.display3D.textures.TextureBase;

/**
 * An attribute is a shader variable mapping to a VertexBuffer data
 * on the CPU.
 *
 * @author Andy
 */
class TextureVar extends ShaderVar
{
	private var _texture:TextureBase;
	
	public function new(name:String,size:Int) 
	{
		super(name,size);
	}
	
	public function setTexture(text:TextureBase):Void
	{
		_texture = text;
	}
	
	public function getTexture():TextureBase
	{
		return _texture;
	}
}