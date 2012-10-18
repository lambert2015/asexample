package org.angle3d.material;
import flash.display3D.textures.TextureBase;
import org.angle3d.renderer.IRenderer;

/**
 * ...
 * @author 
 */
class MatParamTexture 
{
	public var texture:TextureBase;
	
	public var index:Int;
	
	public var name:String;

	public function new(name:String,index:Int,texture:TextureBase) 
	{
		this.name = name;
		this.index = index;
		this.texture = texture;
	}
	
	public inline function apply(render:IRenderer,mat:Material):Void 
	{
        mat.updateTextureParam(name, texture);
    }
}