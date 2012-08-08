
// This class defines material properties.




// Constructor.

function Material (material)
{
	
	// Ambient constant (0.0, 1.0).
	
	this.Ka = (material != null) ? material.Ka : 1.0;


	
	// Ambient colour (R, G, B).
	
	this.Ambient = (material != null) ? new Point(material.Ambient.x, material.Ambient.y, material.Ambient.z) : new Point();


	
	// Diffuse constant (0.0, 1.0).
	
	this.Kd = (material != null) ? material.Kd : 1.0;


	
	// Diffuse colour (R, G, B).
	
	this.Diffuse = (material != null) ? new Point(material.Diffuse.x, material.Diffuse.y, material.Diffuse.z) : new Point(0.8, 0.8, 0.8);


	
	// Alpha constant (0.0, 1.0).
	
	this.Alpha = (material != null) ? material.Alpha : 1.0;


	
	// Specular constant (0.0, 1.0).
	
	this.Ks = (material != null) ? material.Ks : 1.0;


	
	// Specular colour (R, G, B).
	
	this.Specular = (material != null) ? new Point(material.Specular.x, material.Specular.y, material.Specular.z) : new Point();


	
	// Shininess constant (0.0, infinity).
	
	this.Shininess = (material != null) ? material.Shininess : 1.0;


	
	// Texture associated with this material.
	
	this.Texture = (material != null) ? material.Texture : null;
	
	
	
	// Amount of offset to apply to the texture.
	
	this.TextureOffset = (material != null) ? new Point(material.TextureOffset.x, material.TextureOffset.y, material.TextureOffset.z, material.TextureOffset.w) : new Point();


	
	// Amount of scaling to apply to the texture.
	// < 1 = Tiling
	// > 1 = Zooming
	
	this.TextureScale = (material != null) ? new Point(material.TextureScale.x, material.TextureScale.y, material.TextureScale.z, material.TextureScale.w) : new Point(1, 1, 1, 1);
}