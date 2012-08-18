// Texture is an abstract class that contains a specific graphics system
// implementation of an image object.
function Texture() {
	// Width of this texture.
	this.mWidth = 0;

	// Height of this texture.
	this.mHeight = 0;

	// Format of this texture.
	this.mFormat = Texture.Rgba;
}

// Enumeration of the possible texture formats.
Texture.Format = {
	// (Unsigned format) 32-bit RGBA pixel format, using 8 bits per channel.
	Rgba : 0,

	// (Unsigned format) 24-bit RGB pixel format, using 8 bits per channel.
	Rgb : 1,

	// DXT1 compression texture format. Texture dimensions must be multiples of 4.
	// 1-bit Alpha / Opaque. 6:1 compression.
	Dxt1 : 2,

	// DXT3 compression texture format. Texture dimensions must be multiples of 4.
	// Explicit alpha. 4:1 compression.
	Dxt3 : 3,

	// DXT5 compression texture format. Texture dimensions must be multiples of 4.
	// Interpolated alpha. 4:1 compression.
	Dxt5 : 4,

	// (Unsigned format) 32-bit pixel format using 16 bits each for red and green.
	Rg32 : 5,

	// (Unsigned format) 64-bit RGBA pixel format using 16 bits for each component.
	Rgba64 : 6,

	// (Unsigned format) 8-bit alpha only.
	Alpha8 : 7,

	// (IEEE format) 32-bit float format using 32 bits for the red channel.
	Single : 8,

	// (IEEE format) 64-bit float format using 32 bits for the red channel and 32
	// bits for the green channel.
	Vector2 : 9,

	// (IEEE format) 128-bit float format using 32 bits for each channel (red, blue,
	// green, alpha).
	Vector4 : 10,

	// Depth format.
	Depth : 11,

	// Depth format with 16 bits.
	Depth16 : 12,

	// Depth format with 24 bits.
	Depth24 : 13,

	// Depth format with 32 bits.
	Depth32 : 14
};

// Returns the width of the texture.
// <returns>The width of the texture.</returns>
Texture.prototype.getWidth = function() {
	return this.mWidth;
}
// Returns the height of the texture.
// <returns>The height of the texture.</returns>
Texture.prototype.getHeight = function() {
	return this.mHeight;
}
// Returns the format of the texture.
// <returns>The format of the texture.</returns>
Texture.prototype.getFormat = function() {
	return this.mFormat;
}
