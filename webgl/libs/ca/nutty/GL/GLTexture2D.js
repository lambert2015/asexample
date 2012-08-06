/// <summary>
/// Nutty Software Open WebGL Framework
/// 
/// Copyright (C) 2012 Nathaniel Meyer
/// Nutty Software, http://www.nutty.ca
/// All Rights Reserved.
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy of
/// this software and associated documentation files (the "Software"), to deal in
/// the Software without restriction, including without limitation the rights to
/// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
/// of the Software, and to permit persons to whom the Software is furnished to do
/// so, subject to the following conditions:
///     1. The above copyright notice and this permission notice shall be included in all
///        copies or substantial portions of the Software.
///     2. Redistributions in binary or minimized form must reproduce the above copyright
///        notice and this list of conditions in the documentation and/or other materials
///        provided with the distribution.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
/// </summary>


/// <summary>
/// Represents a 2D grid of texels.
/// <summary>


/// <summary>
/// Constructor.
/// <summary>
function GLTexture2D ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	GLTexture.call(this);
	
	
	// Set members
	this.mTextureType = GLTexture.TextureType.Texture2D;
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
GLTexture2D.prototype = new GLTexture();
GLTexture2D.prototype.constructor = GLTexture2D;


/// <summary>
/// Creates a new texture with texel data assigned.
/// <summary>
/// <param name="width">Width of the texture, in pixels.</param>
/// <param name="height">Height of the texture, in pixels.</param>
/// <param name="format">Format of the texture.</param>
/// <param name="sampler">Sampler state of the texture.</param>
/// <param name="image">Image data to assign.</param>
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


/// <summary>
/// Copy image data to the texture.
/// <summary>
/// <param name="image">Image data.</param>
GLTexture2D.prototype.Copy = function (image)
{
	this.CopyTo(0, 0, this.mWidth, this.mHeight, image);
}


/// <summary>
/// Copy image data to the texture.
/// <summary>
/// <param name="x">X-coordinate in texture to start copy at.</param>
/// <param name="y">Y-coordinate in texture to start copy at.</param>
/// <param name="width">Width of image to copy.</param>
/// <param name="height">Height of image to copy.</param>
/// <param name="image">Image data.</param>
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