// <summary>
// Texture is an abstract class that contains a specific graphics system
// implementation of an image object.
// </summary>


// <summary>
// Constructor.
// </summary>
function Texture ()
{
	// <summary>
	// Width of this texture.
	// <summary>
	this.mWidth = 0;


	// <summary>
	// Height of this texture.
	// <summary>
	this.mHeight = 0;
	
	
	// <summary>
	// Format of this texture.
	// <summary>
	this.mFormat = Texture.Rgba;
}


// <summary>
// Enumeration of the possible texture formats.
// <summary>
Texture.Format =
{
	// <summary>
	// (Unsigned format) 32-bit RGBA pixel format, using 8 bits per channel.
	// <summary>
	Rgba : 0,


	// <summary>
	// (Unsigned format) 24-bit RGB pixel format, using 8 bits per channel.
	// <summary>
	Rgb : 1,


	// <summary>
	// DXT1 compression texture format. Texture dimensions must be multiples of 4.
	// 1-bit Alpha / Opaque. 6:1 compression.
	// <summary>
	Dxt1 : 2,

	// <summary>
	// DXT3 compression texture format. Texture dimensions must be multiples of 4.
	// Explicit alpha. 4:1 compression.
	// <summary>
	Dxt3 : 3,

	// <summary>
	// DXT5 compression texture format. Texture dimensions must be multiples of 4.
	// Interpolated alpha. 4:1 compression.
	// <summary>
	Dxt5 : 4,

	// <summary>
	// (Unsigned format) 32-bit pixel format using 16 bits each for red and green.
	// <summary>
	Rg32 : 5,

	// <summary>
	// (Unsigned format) 64-bit RGBA pixel format using 16 bits for each component.
	// <summary>
	Rgba64 : 6,

	// <summary>
	// (Unsigned format) 8-bit alpha only.
	// <summary>
	Alpha8 : 7,

	// <summary>
	// (IEEE format) 32-bit float format using 32 bits for the red channel.
	// <summary>
	Single : 8,

	// <summary>
	// (IEEE format) 64-bit float format using 32 bits for the red channel and 32 bits for the green channel.
	// <summary>
	Vector2 : 9,

	// <summary>
	// (IEEE format) 128-bit float format using 32 bits for each channel (red, blue, green, alpha).
	// <summary>
	Vector4 : 10,

	// <summary>
	// Depth format.
	// <summary>
	Depth : 11,

	// <summary>
	// Depth format with 16 bits.
	// <summary>
	Depth16 : 12,

	// <summary>
	// Depth format with 24 bits.
	// <summary>
	Depth24 : 13,

	// <summary>
	// Depth format with 32 bits.
	// <summary>
	Depth32 : 14
};


// <summary>
// Returns the width of the texture.
// <summary>
// <returns>The width of the texture.</returns>
Texture.prototype.GetWidth = function ()
{
	return this.mWidth;
}


// <summary>
// Returns the height of the texture.
// <summary>
// <returns>The height of the texture.</returns>
Texture.prototype.GetHeight = function ()
{
	return this.mHeight;
}


// <summary>
// Returns the format of the texture.
// <summary>
// <returns>The format of the texture.</returns>
Texture.prototype.GetFormat = function ()
{
	return this.mFormat;
}


// <summary>
// Returns the texture colour at the specified (u,v) coordinate.
// </summary>
// <param name="u">U-coordinate of texture.</param>
// <param name="v">V-coordinate of texture.</param>
// <returns>The texture colour at the specified (u,v) coordinate.</returns>
Texture.prototype.GetColour = function (u, v)
{
	return new Point();
}
