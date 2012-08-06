// <summary>
// This class defines material properties.
// </summary>


// <summary>
// Constructor.
// </summary>
function Material (material)
{
	// <summary>
	// Ambient constant (0.0, 1.0).
	// </summary>
	this.Ka = (material != null) ? material.Ka : 1.0;


	// <summary>
	// Ambient colour (R, G, B).
	// </summary>
	this.Ambient = (material != null) ? new Point(material.Ambient.x, material.Ambient.y, material.Ambient.z) : new Point();


	// <summary>
	// Diffuse constant (0.0, 1.0).
	// </summary>
	this.Kd = (material != null) ? material.Kd : 1.0;


	// <summary>
	// Diffuse colour (R, G, B).
	// </summary>
	this.Diffuse = (material != null) ? new Point(material.Diffuse.x, material.Diffuse.y, material.Diffuse.z) : new Point(0.8, 0.8, 0.8);


	// <summary>
	// Alpha constant (0.0, 1.0).
	// </summary>
	this.Alpha = (material != null) ? material.Alpha : 1.0;


	// <summary>
	// Specular constant (0.0, 1.0).
	// </summary>
	this.Ks = (material != null) ? material.Ks : 1.0;


	// <summary>
	// Specular colour (R, G, B).
	// </summary>
	this.Specular = (material != null) ? new Point(material.Specular.x, material.Specular.y, material.Specular.z) : new Point();


	// <summary>
	// Shininess constant (0.0, infinity).
	// </summary>
	this.Shininess = (material != null) ? material.Shininess : 1.0;


	// <summary>
	// Texture associated with this material.
	// </summary>
	this.Texture = (material != null) ? material.Texture : null;
	
	
	// <summary>
	// Amount of offset to apply to the texture.
	// </summary>
	this.TextureOffset = (material != null) ? new Point(material.TextureOffset.x, material.TextureOffset.y, material.TextureOffset.z, material.TextureOffset.w) : new Point();


	// <summary>
	// Amount of scaling to apply to the texture.
	// < 1 = Tiling
	// > 1 = Zooming
	// </summary>
	this.TextureScale = (material != null) ? new Point(material.TextureScale.x, material.TextureScale.y, material.TextureScale.z, material.TextureScale.w) : new Point(1, 1, 1, 1);
}