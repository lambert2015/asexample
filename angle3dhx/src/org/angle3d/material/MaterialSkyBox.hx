package org.angle3d.material;
import flash.display3D.textures.CubeTexture;
import flash.display3D.textures.TextureBase;
import org.angle3d.material.technique.TechniqueSkyBox;
import org.angle3d.texture.CubeTextureMap;

/**
 * ...
 * @author andy
 */

class MaterialSkyBox extends Material
{
	private var _technique:TechniqueSkyBox;

	public function new(cubeTexture:CubeTextureMap) 
	{
		super();
		
		_technique = new TechniqueSkyBox(cubeTexture);
		
		addTechnique(_technique);
	}
	
}