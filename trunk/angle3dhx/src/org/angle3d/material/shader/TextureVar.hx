package org.angle3d.material.shader;
import flash.display3D.textures.TextureBase;
import org.angle3d.texture.TextureMapBase;

/**
 * An attribute is a shader variable mapping to a VertexBuffer data
 * on the CPU.
 *
 * @author Andy
 */
class TextureVar extends ShaderVar
{
	public var textureMap:TextureMapBase;
	
	public function new(name:String,size:Int) 
	{
		super(name,size);
	}
}