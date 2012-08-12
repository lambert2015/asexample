// Represents a set of six 2D textures, one for each face of a cube.
function GLTextureCube ()
{
	// Setup inherited members.
	GLTexture.call(this);
	
	// Enumeration of a list of possible cube faces.
	this.CubeFace =
	{
		PositiveX : gl.TEXTURE_CUBE_MAP_POSITIVE_X,
		NegativeX : gl.TEXTURE_CUBE_MAP_NEGATIVE_X,
		PositiveY : gl.TEXTURE_CUBE_MAP_POSITIVE_Y,
		NegativeY : gl.TEXTURE_CUBE_MAP_NEGATIVE_Y,
		PositiveZ : gl.TEXTURE_CUBE_MAP_POSITIVE_Z,
		NegativeZ : gl.TEXTURE_CUBE_MAP_NEGATIVE_Z
	};
	
	// Set members
	this.mTextureType = GLTexture.TextureType.TextureCube;
}

// Prototypal Inheritance.
GLTextureCube.prototype = new GLTexture();
GLTextureCube.prototype.constructor = GLTextureCube;

// Implementation.
GLTextureCube.prototype.create = function (width, height, format, sampler)
{
	// Base
	GLTexture.prototype.create.call(this, width, height, format, sampler);

	if ( this.texture != null )
	{
		// Texture format
		for (var i = 0; i < 6; ++i)
			gl.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, this.mGlInternalFormat, width, height, 0, this.mGlFormat, this.mGlType, null);
			
		// Generate mipmaps
		if ( sampler.hasMipMap )
			gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
	}
}

// Copy image data to a face on the cubemap.
// <param name="face">Cueb face to copy image.</param>
// <param name="image">Image data.</param>
GLTextureCube.prototype.copy = function (face, image)
{
	this.copyTo(face, 0, 0, this.mWidth, this.mHeight, image);
}

// Copy image data to a face on the cubemap.
// <param name="face">Cueb face to copy image.</param>
// <param name="x">X-coordinate in texture to start copy at.</param>
// <param name="y">Y-coordinate in texture to start copy at.</param>
// <param name="width">Width of image to copy.</param>
// <param name="height">Height of image to copy.</param>
// <param name="image">Image data.</param>
GLTextureCube.prototype.copyTo = function (face, x, y, width, height, image)
{
	// First bind the texture location
	gl.bindTexture(gl.TEXTURE_CUBE_MAP, this.texture);
	
	// Copy to texture
	if ( image.width != null )
		gl.texSubImage2D(face, 0, x, y, this.mGlFormat, this.mGlType, image);
	else
		gl.texSubImage2D(face, 0, x, y, width, height, this.mGlFormat, this.mGlType, new Uint8Array(image));
}