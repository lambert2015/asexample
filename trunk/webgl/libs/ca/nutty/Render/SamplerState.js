
// Contains sampler state, which determines how to sample texture data.




// Constructor.

function SamplerState (sampler)
{
	
	// Gets or sets the texture-address mode for the u-coordinate.
	
	this.AddressU = (sampler != null) ? sampler.AddressU : SamplerState.TextureAddressMode.Repeat;


	
	// Gets or sets the texture-address mode for the v-coordinate.
	
	this.AddressV = (sampler != null) ? sampler.AddressV : SamplerState.TextureAddressMode.Repeat;


	
	// Gets or sets the texture-address mode for the w-coordinate.
	
	this.AddressW = (sampler != null) ? sampler.AddressW : SamplerState.TextureAddressMode.Repeat;


	
	// Gets or sets the type of filtering during sampling.
	
	this.Filter = (sampler != null) ? sampler.Filter : SamplerState.TextureFilter.Linear;


	
	// Gets or sets whether the texture has mip maps.
	
	this.HasMipMap = (sampler != null) ? sampler.HasMipMap : false;

	
	
	// Gets or sets the maximum anisotropy. The default value is 4.
	
	this.MaxAnisotropy = (sampler != null) ? sampler.MaxAnisotropy : 4;


	
	// Gets or sets the level of detail (LOD) index of the largest map to use.
	
	this.MaxMipLevel = (sampler != null) ? sampler.MaxMipLevel : 0;
};



// Enumeration of the possible texture modes for each address.

SamplerState.TextureAddressMode =
{
	
	// Texture coordinates outside the range [0.0, 1.0] are set to
	// the texture color at 0.0 or 1.0, respectively.
	
	Clamp : 0,

	
	// Tile the texture at every integer junction. For example, for u
	// values between 0 and 3, the texture is repeated three times.
	
	Repeat : 1
};



// Enumeration of the possible texture filters.

SamplerState.TextureFilter =
{
	
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
SamplerState.LinearClamp.AddressU = SamplerState.TextureAddressMode.Clamp;
SamplerState.LinearClamp.AddressV = SamplerState.TextureAddressMode.Clamp;
SamplerState.LinearClamp.AddressW = SamplerState.TextureAddressMode.Clamp;
SamplerState.LinearClamp.Filter = SamplerState.TextureFilter.Linear;



// Contains default state for linear filtering and texture coordinate repeat.

SamplerState.LinearRepeat = new SamplerState();
SamplerState.LinearRepeat.AddressU = SamplerState.TextureAddressMode.Repeat;
SamplerState.LinearRepeat.AddressV = SamplerState.TextureAddressMode.Repeat;
SamplerState.LinearRepeat.AddressW = SamplerState.TextureAddressMode.Repeat;
SamplerState.LinearRepeat.Filter = SamplerState.TextureFilter.Linear;



// Contains default state for point filtering and texture coordinate clamping.

SamplerState.PointClamp = new SamplerState();
SamplerState.PointClamp.AddressU = SamplerState.TextureAddressMode.Clamp;
SamplerState.PointClamp.AddressV = SamplerState.TextureAddressMode.Clamp;
SamplerState.PointClamp.AddressW = SamplerState.TextureAddressMode.Clamp;
SamplerState.PointClamp.Filter = SamplerState.TextureFilter.Point;



// Contains default state for point filtering and texture coordinate repeat.

SamplerState.PointRepeat = new SamplerState();
SamplerState.PointRepeat.AddressU = SamplerState.TextureAddressMode.Repeat;
SamplerState.PointRepeat.AddressV = SamplerState.TextureAddressMode.Repeat;
SamplerState.PointRepeat.AddressW = SamplerState.TextureAddressMode.Repeat;
SamplerState.PointRepeat.Filter = SamplerState.TextureFilter.Point;