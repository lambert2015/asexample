// Manages OpenGL textures.
function GLTexture() {
	// Setup inherited members.
	Texture.call(this);

	// Gets or sets the type of this texture.
	this.mTextureType

	// Stores the texture.
	this.texture = null;

	// Gets or sets the sampler state for this texture.
	this.mSampler = null;

	// Gets or sets GL friendly texture format.
	this.mGlInternalFormat = 0;
	this.mGlFormat = 0;
	this.mGlType = 0;
}

// Prototypal Inheritance.
GLTexture.prototype = new Texture();
GLTexture.prototype.constructor = GLTexture;

// Enumeration of the possible texture types.
GLTexture.TextureType = {
	Texture2D : 0x0DE1,
	TextureCube : 0x8513
};

// Create a new blank texture.
// <param name="width">Width of the texture, in pixels.</param>
// <param name="height">Height of the texture, in pixels.</param>
// <param name="format">Format of the texture.</param>
// <param name="sampler">Sampler state of the texture.</param>
GLTexture.prototype.create = function(width, height, format, sampler) {
	// Cleanup
	this.release();

	// Assign
	this.mWidth = width;
	this.mHeight = height;
	this.mFormat = format;
	this.mSampler = sampler;

	// Generate texture
	this.texture = gl.createTexture();
	if (this.texture != null) {
		// First bind the texture location
		gl.bindTexture(this.mTextureType, this.texture);

		// Texture alignment
		gl.pixelStorei(gl.UNPACK_ALIGNMENT, 1);

		// Texture mode
		gl.texParameteri(this.mTextureType, gl.TEXTURE_WRAP_S, (sampler.addressU == SamplerState.TextureAddressMode.Clamp) ? gl.CLAMP_TO_EDGE : gl.REPEAT);
		gl.texParameteri(this.mTextureType, gl.TEXTURE_WRAP_T, (sampler.addressV == SamplerState.TextureAddressMode.Clamp) ? gl.CLAMP_TO_EDGE : gl.REPEAT);

		// Texture filter
		if (sampler.filter & SamplerState.TextureFilter.Linear) {
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, sampler.hasMipMap ? gl.LINEAR_MIPMAP_LINEAR : gl.LINEAR);
		} else if (sampler.filter & SamplerState.TextureFilter.Point) {
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, sampler.hasMipMap ? gl.NEAREST_MIPMAP_NEAREST : gl.NEAREST);
		} else if (sampler.filter & SamplerState.TextureFilter.LinearMipPoint) {
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
		} else if (sampler.filter & SamplerState.TextureFilter.PointMipLinear) {
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.NEAREST_MIPMAP_LINEAR);
		} else if (sampler.filter & SamplerState.TextureFilter.MinLinearMagPointMipLinear) {
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR);
		} else if (sampler.filter & SamplerState.TextureFilter.MinLinearMagPointMipPoint) {
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
		} else if (sampler.filter & SamplerState.TextureFilter.MinPointMagLinearMipLinear) {
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.NEAREST_MIPMAP_LINEAR);
		} else if (sampler.filter & SamplerState.TextureFilter.MinPointMagLinearMipPoint) {
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri(this.mTextureType, gl.TEXTURE_MIN_FILTER, gl.NEAREST_MIPMAP_NEAREST);
		}

		if (sampler.filter & SamplerState.TextureFilter.Anisotropic) {
			gl.texParameterf(this.mTextureType, gl.TEXTURE_MAX_ANISOTROPY_EXT, sampler.maxAnisotropy);
		}

		// Texture format
		this.mGlInternalFormat = gl.RGBA;
		this.mGlFormat = gl.RGBA;
		this.mGlType = gl.UNSIGNED_BYTE;

		if (format == Texture.Format.Rgba) {
		} else if (format == Texture.Format.Rgb) {
			this.mGlInternalFormat = gl.RGB;
			this.mGlFormat = gl.RGB;
		} else if (format == Texture.Format.Dxt1) {
			this.mGlInternalFormat = gl.COMPRESSED_RGBA_S3TC_DXT1_EXT;
		} else if (format == Texture.Format.Dxt3) {
			this.mGlInternalFormat = gl.COMPRESSED_RGBA_S3TC_DXT3_EXT;
		} else if (format == Texture.Format.Dxt5) {
			this.mGlInternalFormat = gl.COMPRESSED_RGBA_S3TC_DXT5_EXT;
		} else if (format == Texture.Format.Rg32) {
			this.mGlInternalFormat = gl.LUMINANCE_ALPHA;
			this.mGlFormat = gl.LUMINANCE_ALPHA;
			this.mGlType = gl.UNSIGNED_SHORT;
		} else if (format == Texture.Format.Rgba64) {
			this.mGlType = gl.SHORT;
		} else if (format == Texture.Format.Alpha8) {
			this.mGlInternalFormat = gl.LUMINANCE;
			this.mGlFormat = gl.LUMINANCE;
		} else if (format == Texture.Format.Single) {
			this.mGlInternalFormat = gl.LUMINANCE32F_ARB;
			this.mGlFormat = gl.LUMINANCE;
			this.mGlType = gl.FLOAT;
		} else if (format == Texture.Format.Vector2) {
			this.mGlInternalFormat = gl.LUMINANCE_ALPHA32F_ARB;
			this.mGlFormat = gl.LUMINANCE_ALPHA;
			this.mGlType = gl.FLOAT;
		} else if (format == Texture.Format.Vector4) {
			this.mGlInternalFormat = gl.RGBA32F_ARB;
			this.mGlType = gl.FLOAT;
		} else if (format == Texture.Format.Depth) {
			this.mGlInternalFormat = gl.DEPTH_COMPONENT;
			this.mGlFormat = gl.DEPTH_COMPONENT;
		} else if (format == Texture.Format.Depth16) {
			this.mGlInternalFormat = gl.DEPTH_COMPONENT16;
			this.mGlFormat = gl.DEPTH_COMPONENT;
		} else if (format == Texture.Format.Depth24) {
			this.mGlInternalFormat = gl.DEPTH_COMPONENT24;
			this.mGlFormat = gl.DEPTH_COMPONENT;
		} else if (format == Texture.Format.Depth32) {
			this.mGlInternalFormat = gl.DEPTH_COMPONENT32;
			this.mGlFormat = gl.DEPTH_COMPONENT;
		}
	}
}
// Creates a set of mipmaps for this texture.
GLTexture.prototype.createMipmaps = function() {
	gl.bindTexture(this.mTextureType, this.texture);
	gl.generateMipmap(this.mTextureType);
}
// Free up any used resources.
GLTexture.prototype.release = function() {
	if (this.texture != null) {
		gl.deleteTexture(this.texture);

		this.texture = null;
		this.mWidth = 0;
		this.mHeight = 0;

		this.mGlInternalFormat = 0;
		this.mGlFormat = 0;
		this.mGlType = 0;
	}
}
// Binds the texture for use.
GLTexture.prototype.bind = function() {
	gl.bindTexture(this.mTextureType, this.texture);
}
// Returns the texture type.
// <returns>The texture type.</returns>
GLTexture.prototype.getTextureType = function() {
	return this.mTextureType;
}
// Returns the texture id used by this object.
// <returns>The texture id used by this object.</returns>
GLTexture.prototype.getTextureId = function() {
	return this.texture;
}
// Returns the sampler state of the texture.
// <returns>The sampler state of the texture.</returns>
GLTexture.prototype.getSamplerState = function() {
	return this.mSampler;
}