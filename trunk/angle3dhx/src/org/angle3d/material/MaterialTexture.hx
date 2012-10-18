package org.angle3d.material;
import flash.display3D.textures.Texture;
import org.angle3d.material.technique.TechniqueTexture;
import org.angle3d.texture.TextureMapBase;

/**
 * ...
 * @author andy
 */

class MaterialTexture extends Material
{
	private var _technique:TechniqueTexture;

	public function new() 
	{
		super();
		
		_technique = new TechniqueTexture();
		addTechnique(_technique);
	}
	
	public function setUseTexCoord2(value:Bool):Void
	{
		_technique.setUseTexCoord2(value);
	}
	
	public function setTexture(value:TextureMapBase):Void
	{
		_technique.texture = value;
	}
	
	public function setLightmap(value:TextureMapBase):Void
	{
		_technique.lightmap = value;
	}
}