// This class defines material properties.

function Material (material)
{
	// Ambient constant (0.0, 1.0).
	this.ka = (material != null) ? material.ka : 1.0;

	// Ambient colour (R, G, B).
	this.ambient = (material != null) ? new Point(material.ambient.x, material.ambient.y, material.ambient.z) : new Point();

	
	// Diffuse constant (0.0, 1.0).
	this.kd = (material != null) ? material.kd : 1.0;


	// Diffuse colour (R, G, B).
	this.diffuse = (material != null) ? new Point(material.diffuse.x, material.diffuse.y, material.diffuse.z) : new Point(0.8, 0.8, 0.8);

	
	// Alpha constant (0.0, 1.0).
	this.alpha = (material != null) ? material.alpha : 1.0;

	
	// Specular constant (0.0, 1.0).
	this.ks = (material != null) ? material.ks : 1.0;

	// Specular colour (R, G, B).
	this.specular = (material != null) ? new Point(material.specular.x, material.specular.y, material.specular.z) : new Point();
	
	// Shininess constant (0.0, infinity).
	this.shininess = (material != null) ? material.shininess : 1.0;

	// Texture associated with this material.
	this.texture = (material != null) ? material.texture : null;
	
	// Amount of offset to apply to the texture.
	this.textureOffset = (material != null) ? new Point(material.textureOffset.x, material.textureOffset.y, material.textureOffset.z, material.textureOffset.w) : new Point();

	
	// Amount of scaling to apply to the texture.
	// < 1 = Tiling
	// > 1 = Zooming
	this.textureScale = (material != null) ? new Point(material.textureScale.x, material.textureScale.y, material.textureScale.z, material.textureScale.w) : new Point(1, 1, 1, 1);
}