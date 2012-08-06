// <summary>
// Manages OpenGL textures.
// <summary>


// <summary>
// Constructor.
// <summary>
function GLTexture ()
{
	// <summary>
	// Setup inherited members.
	// </summary>
	Texture.call(this);
	
	
	// <summary>
	// Gets or sets the type of this texture.
	// <summary>
	this.mTextureType;


	// <summary>
	// Stores the texture.
	// <summary>
	this.Texture = null;
	
	
	// <summary>
	// Gets or sets the sampler state for this texture.
	// <summary>
	this.mSampler = null;


	// <summary>
	// Gets or sets GL friendly texture format.
	// <summary>
	this.mGlInternalFormat = 0;
	this.mGlFormat = 0;
	this.mGlType = 0;
}


// <summary>
// Prototypal Inheritance.
// </summary>
GLTexture.prototype = new Texture();
GLTexture.prototype.constructor = GLTexture;


// <summary>
// Enumeration of the possible texture types.
// <summary>
GLTexture.TextureType =
{
	Texture2D : 0x0DE1,
	TextureCube : 0x8513
};


// <summary>
// Create a new blank texture.
// <summary>
// <param name="width">Width of the texture, in pixels.</param>
// <param name="height">Height of the texture, in pixels.</param>
// <param name="format">Format of the texture.</param>
// <param name="sampler">Sampler state of the texture.</param>
GLTexture.prototype.Create = function (width, height, format, sampler)
{
	// Cleanup
	this.Release();

	// Assign
	this.mWidth = width;
	this.mHeight = height;
	this.mFormat = format;
	this.mSampler = sampler;

	// Generate texture
	this.Texture = gl.createTexture();
	if ( this.Texture != null )
	{
		// First bind the texture location
		gl.bindTexture(this.mTextureType, this.Texture);

		// Texture alignment
		gl.pixelStorei(gl.UNPACK_ALIGNMENT, 1);

		// Texture mode
		gl.texParameteri(this.mTextureType, gl.TEXTURE_WRAP_S, (sampler.AddressU == SamplerState.TextureAddressMode.Clamp) ? gl.CLAMP_TO_EDGE : gl.REPEAT);
		gl.texParameteri(this.mTextureType, gl.TEXTURE_WRAP_T, (sampler.AddressV == SamplerState.TextureAddressMode.Clamp) ? gl.CLAMP_TO_EDGE : gl.REPEAT);

		// Texture filter
		if ( sampler.Filter & SamplerState.TextureFilter.Linear )
		{
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, sampler.HasMipMap ? gl.LINEAR_MIPMAP_LINEAR : gl.LINEAR);
		}
		else if ( sampler.Filter & SamplerState.TextureFilter.Point )
		{
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, sampler.HasMipMap ? gl.NEAREST_MIPMAP_NEAREST : gl.NEAREST);
		}
		else if ( sampler.Filter & SamplerState.TextureFilter.LinearMipPoint )
		{
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
		}
		else if ( sampler.Filter & SamplerState.TextureFilter.PointMipLinear )
		{
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.NEAREST_MIPMAP_LINEAR);
		}
		else if ( sampler.Filter & SamplerState.TextureFilter.MinLinearMagPointMipLinear )
		{
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR);
		}
		else if ( sampler.Filter & SamplerState.TextureFilter.MinLinearMagPointMipPoint )
		{
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
		}
		else if ( sampler.Filter & SamplerState.TextureFilter.MinPointMagLinearMipLinear )
		{
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.NEAREST_MIPMAP_LINEAR);
		}
		else if ( sampler.Filter & SamplerState.TextureFilter.MinPointMagLinearMipPoint )
		{
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.NEAREST_MIPMAP_NEAREST);
		}

		if ( sampler.Filter & SamplerState.TextureFilter.Anisotropic )
		{
			gl.texParameterf(this.mTextureType, gl.TEXTURE_MAX_ANISOTROPY_EXT, sampler.MaxAnisotropy);
		}

		// Texture format
		this.mGlInternalFormat = gl.RGBA;
		this.mGlFormat = gl.RGBA;
		this.mGlType = gl.UNSIGNED_BYTE;

		if ( format == Texture.Format.Rgba )
		{}
		else if ( format == Texture.Format.Rgb )
		{
			this.mGlInternalFormat = gl.RGB;
			this.mGlFormat = gl.RGB;
		}
		else if ( format == Texture.Format.Dxt1 )
		{
			this.mGlInternalFormat = gl.COMPRESSED_RGBA_S3TC_DXT1_EXT;
		}
		else if ( format == Texture.Format.Dxt3 )
		{
			this.mGlInternalFormat = gl.COMPRESSED_RGBA_S3TC_DXT3_EXT;
		}
		else if ( format == Texture.Format.Dxt5 )
		{
			this.mGlInternalFormat = gl.COMPRESSED_RGBA_S3TC_DXT5_EXT;
		}
		else if ( format == Texture.Format.Rg32 )
		{
			this.mGlInternalFormat = gl.LUMINANCE_ALPHA;
			this.mGlFormat = gl.LUMINANCE_ALPHA;
			this.mGlType = gl.UNSIGNED_SHORT;
		}
		else if ( format == Texture.Format.Rgba64 )
		{
			this.mGlType = gl.SHORT;
		}
		else if ( format == Texture.Format.Alpha8 )
		{
			this.mGlInternalFormat = gl.LUMINANCE;
			this.mGlFormat = gl.LUMINANCE;
		}
		else if ( format == Texture.Format.Single )
		{
			this.mGlInternalFormat = gl.LUMINANCE32F_ARB;
			this.mGlFormat = gl.LUMINANCE;
			this.mGlType = gl.FLOAT;
		}
		else if ( format == Texture.Format.Vector2 )
		{
			this.mGlInternalFormat = gl.LUMINANCE_ALPHA32F_ARB;
			this.mGlFormat = gl.LUMINANCE_ALPHA;
			this.mGlType = gl.FLOAT;
		}
		else if ( format == Texture.Format.Vector4 )
		{
			this.mGlInternalFormat = gl.RGBA32F_ARB;
			this.mGlType = gl.FLOAT;
		}
		else if ( format == Texture.Format.Depth )
		{
			this.mGlInternalFormat = gl.DEPTH_COMPONENT;
			this.mGlFormat = gl.DEPTH_COMPONENT;
		}
		else if ( format == Texture.Format.Depth16 )
		{
			this.mGlInternalFormat = gl.DEPTH_COMPONENT16;
			this.mGlFormat = gl.DEPTH_COMPONENT;
		}
		else if ( format == Texture.Format.Depth24 )
		{
			this.mGlInternalFormat = gl.DEPTH_COMPONENT24;
			this.mGlFormat = gl.DEPTH_COMPONENT;
		}
		else if ( format == Texture.Format.Depth32 )
		{
			this.mGlInternalFormat = gl.DEPTH_COMPONENT32;
			this.mGlFormat = gl.DEPTH_COMPONENT;
		}
	}
}


// <summary>
// Creates a set of mipmaps for this texture.
// <summary>
GLTexture.prototype.CreateMipmaps = function ()
{
	gl.bindTexture(this.mTextureType, this.Texture);
	gl.generateMipmap(this.mTextureType);
}


// <summary>
// Free up any used resources.
// </summary>
GLTexture.prototype.Release = function ()
{
	if ( this.Texture != null )
	{
		gl.deleteTexture(this.Texture);
		
		this.Texture = null;
		this.mWidth = 0;
		this.mHeight = 0;
		
		this.mGlInternalFormat = 0;
		this.mGlFormat = 0;
		this.mGlType = 0;
	}
}


// <summary>
// Binds the texture for use.
// </summary>
GLTexture.prototype.Bind = function ()
{
	gl.bindTexture(this.mTextureType, this.Texture);
}


// <summary>
// Returns the texture type.
// <summary>
// <returns>The texture type.</returns>
GLTexture.prototype.GetTextureType = function ()
{
	return this.mTextureType;
}


// <summary>
// Returns the texture id used by this object.
// <summary>
// <returns>The texture id used by this object.</returns>
GLTexture.prototype.GetTextureId = function ()
{
	return this.Texture;
}


// <summary>
// Returns the sampler state of the texture.
// <summary>
// <returns>The sampler state of the texture.</returns>
GLTexture.prototype.GetSamplerState = function ()
{
	return this.mSampler;
}