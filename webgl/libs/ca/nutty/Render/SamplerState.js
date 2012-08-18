// Contains sampler state, which determines how to sample texture data.
function SamplerState(sampler) {
	// Gets or sets the texture-address mode for the u-coordinate.
	this.addressU = (sampler != null) ? sampler.addressU : SamplerState.TextureAddressMode.Repeat;

	// Gets or sets the texture-address mode for the v-coordinate.
	this.addressV = (sampler != null) ? sampler.addressV : SamplerState.TextureAddressMode.Repeat;

	// Gets or sets the texture-address mode for the w-coordinate.
	this.addressW = (sampler != null) ? sampler.addressW : SamplerState.TextureAddressMode.Repeat;

	// Gets or sets the type of filtering during sampling.
	this.filter = (sampler != null) ? sampler.filter : SamplerState.TextureFilter.Linear;

	// Gets or sets whether the texture has mip maps.
	this.hasMipMap = (sampler != null) ? sampler.hasMipMap : false;

	// Gets or sets the maximum anisotropy. The default value is 4.
	this.maxAnisotropy = (sampler != null) ? sampler.maxAnisotropy : 4;

	// Gets or sets the level of detail (LOD) index of the largest map to use.
	this.maxMipLevel = (sampler != null) ? sampler.maxMipLevel : 0;
};

// Enumeration of the possible texture modes for each address.
SamplerState.TextureAddressMode = {
	// Texture coordinates outside the range [0.0, 1.0] are set to
	// the texture color at 0.0 or 1.0, respectively.
	Clamp : 0,

	// Tile the texture at every integer junction. For example, for u
	// values between 0 and 3, the texture is repeated three times.
	Repeat : 1
};

// Enumeration of the possible texture filters.
SamplerState.TextureFilter = {
	// Use linear filtering.
	Linear : 1,

	// Use point filtering.
	Point : 2,

	// Use anisotropic filtering.
	Anisotropic : 4,

	// Use linear filtering to shrink or expand, and point filtering
	// between mipmap levels (mip).
	LinearMipPoint : 8,

	// Use point filtering to shrink (minify) or expand (magnify), and
	// linear filtering between mipmap levels.
	PointMipLinear : 16,

	// Use linear filtering to shrink, point filtering to expand, and
	// linear filtering between mipmap levels.
	MinLinearMagPointMipLinear : 32,

	// Use linear filtering to shrink, point filtering to expand, and
	// point filtering between mipmap levels.
	MinLinearMagPointMipPoint : 64,

	// Use point filtering to shrink, linear filtering to expand, and
	// linear filtering between mipmap levels.
	MinPointMagLinearMipLinear : 128,

	// Use point filtering to shrink, linear filtering to expand, and
	// point filtering between mipmap levels.
	MinPointMagLinearMipPoint : 256
};

// Contains default state for linear filtering and texture coordinate clamping.
SamplerState.LinearClamp = new SamplerState();
SamplerState.LinearClamp.addressU = SamplerState.TextureAddressMode.Clamp;
SamplerState.LinearClamp.addressV = SamplerState.TextureAddressMode.Clamp;
SamplerState.LinearClamp.addressW = SamplerState.TextureAddressMode.Clamp;
SamplerState.LinearClamp.filter = SamplerState.TextureFilter.Linear;

// Contains default state for linear filtering and texture coordinate repeat.
SamplerState.LinearRepeat = new SamplerState();
SamplerState.LinearRepeat.addressU = SamplerState.TextureAddressMode.Repeat;
SamplerState.LinearRepeat.addressV = SamplerState.TextureAddressMode.Repeat;
SamplerState.LinearRepeat.addressW = SamplerState.TextureAddressMode.Repeat;
SamplerState.LinearRepeat.filter = SamplerState.TextureFilter.Linear;

// Contains default state for point filtering and texture coordinate clamping.
SamplerState.PointClamp = new SamplerState();
SamplerState.PointClamp.addressU = SamplerState.TextureAddressMode.Clamp;
SamplerState.PointClamp.addressV = SamplerState.TextureAddressMode.Clamp;
SamplerState.PointClamp.addressW = SamplerState.TextureAddressMode.Clamp;
SamplerState.PointClamp.filter = SamplerState.TextureFilter.Point;

// Contains default state for point filtering and texture coordinate repeat.
SamplerState.PointRepeat = new SamplerState();
SamplerState.PointRepeat.addressU = SamplerState.TextureAddressMode.Repeat;
SamplerState.PointRepeat.addressV = SamplerState.TextureAddressMode.Repeat;
SamplerState.PointRepeat.addressW = SamplerState.TextureAddressMode.Repeat;
SamplerState.PointRepeat.filter = SamplerState.TextureFilter.Point; 