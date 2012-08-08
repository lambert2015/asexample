
// Represents a 2D grid of texels.




// Constructor.

function GLTexture2D ()
{
	
	// Setup inherited members.
	
	GLTexture.call(this);
	
	
	// Set members
	this.mTextureType = GLTexture.TextureType.Texture2D;
}



// Prototypal Inheritance.

GLTexture2D.prototype = new GLTexture();
GLTexture2D.prototype.constructor = GLTexture2D;



// Creates a new texture with texel data assigned.

// <param name="width">Width of the texture, in pixels.</param>
// <param name="height">Height of the texture, in pixels.</param>
// <param name="format">Format of the texture.</param>
// <param name="sampler">Sampler state of the texture.</param>
// <param name="image">Image data to assign.</param>
GLTexture2D.prototype.Create = function (width, height, format, sampler, image)
{
	// Base
	GLTexture.prototype.Create.call(this, width, height, format, sampler);

	if ( this.Texture != null )
	{
		// Texture format
		if ( image == null )
			gl.texImage2D(gl.TEXTURE_2D, 0, this.mGlInternalFormat, width, height, 0, this.mGlFormat, this.mGlType, null);
		else
			gl.texImage2D(gl.TEXTURE_2D, 0, this.mGlInternalFormat, this.mGlFormat, this.mGlType, image);
		
		// Generate mipmaps
		if ( sampler.HasMipMap )
			gl.generateMipmap(gl.TEXTURE_2D);
	}
}



// Copy image data to the texture.

// <param name="image">Image data.</param>
GLTexture2D.prototype.Copy = function (image)
{
	this.CopyTo(0, 0, this.mWidth, this.mHeight, image);
}



// Copy image data to the texture.

// <param name="x">X-coordinate in texture to start copy at.</param>
// <param name="y">Y-coordinate in texture to start copy at.</param>
// <param name="width">Width of image to copy.</param>
// <param name="height">Height of image to copy.</param>
// <param name="image">Image data.</param>
GLTexture2D.prototype.CopyTo = function (x, y, width, height, image)
{
	// First bind the texture location
	gl.bindTexture(gl.TEXTURE_2D, this.Texture);
	
	// Copy to texture
	if ( image.width != null )
		gl.texSubImage2D(gl.TEXTURE_2D, 0, x, y, this.mGlFormat, this.mGlType, image);
	else
		gl.texSubImage2D(gl.TEXTURE_2D, 0, x, y, width, height, this.mGlFormat, this.mGlType, new Uint8Array(image));
}