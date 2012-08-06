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
/// Represents a set of six 2D textures, one for each face of a cube.
/// <summary>


/// <summary>
/// Constructor.
/// <summary>
function GLTextureCube ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	GLTexture.call(this);
	
	
	/// <summary>
	/// Enumeration of a list of possible cube faces.
	/// <summary>
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


/// <summary>
/// Prototypal Inheritance.
/// </summary>
GLTextureCube.prototype = new GLTexture();
GLTextureCube.prototype.constructor = GLTextureCube;


/// <summary>
/// Implementation.
/// <summary>
GLTextureCube.prototype.Create = function (width, height, format, sampler)
{
	// Base
	GLTexture.prototype.Create.call(this, width, height, format, sampler);

	if ( this.Texture != null )
	{
		// Texture format
		for (var i = 0; i < 6; ++i)
			gl.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, this.mGlInternalFormat, width, height, 0, this.mGlFormat, this.mGlType, null);
			
		// Generate mipmaps
		if ( sampler.HasMipMap )
			gl.generateMipmap(gl.TEXTURE_CUBE_MAP);
	}
}


/// <summary>
/// Copy image data to a face on the cubemap.
/// <summary>
/// <param name="face">Cueb face to copy image.</param>
/// <param name="image">Image data.</param>
GLTextureCube.prototype.Copy = function (face, image)
{
	this.CopyTo(face, 0, 0, this.mWidth, this.mHeight, image);
}


/// <summary>
/// Copy image data to a face on the cubemap.
/// <summary>
/// <param name="face">Cueb face to copy image.</param>
/// <param name="x">X-coordinate in texture to start copy at.</param>
/// <param name="y">Y-coordinate in texture to start copy at.</param>
/// <param name="width">Width of image to copy.</param>
/// <param name="height">Height of image to copy.</param>
/// <param name="image">Image data.</param>
GLTextureCube.prototype.CopyTo = function (face, x, y, width, height, image)
{
	// First bind the texture location
	gl.bindTexture(gl.TEXTURE_CUBE_MAP, this.Texture);
	
	// Copy to texture
	if ( image.width != null )
		gl.texSubImage2D(face, 0, x, y, this.mGlFormat, this.mGlType, image);
	else
		gl.texSubImage2D(face, 0, x, y, width, height, this.mGlFormat, this.mGlType, new Uint8Array(image));
}