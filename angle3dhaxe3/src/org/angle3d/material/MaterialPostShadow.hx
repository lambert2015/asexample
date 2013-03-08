package org.angle3d.material;

import org.angle3d.material.technique.TechniquePostShadow;
import org.angle3d.math.Matrix4f;
import org.angle3d.texture.TextureMap;
import org.angle3d.texture.TextureMapBase;

class MaterialPostShadow extends Material
{
	private var _postShadowTechnique:TechniquePostShadow;

	public function new()
	{
		super();

		_postShadowTechnique = new TechniquePostShadow();
		addTechnique(_postShadowTechnique);
	}

	public function setTexture(texture:TextureMap):Void
	{
		_postShadowTechnique.setTexture(texture);
	}

	public function setLightViewProjection(matrix:Matrix4f):Void
	{
		_postShadowTechnique.setLightViewProjection(matrix);
	}
}
