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
/// Contains sampler state, which determines how to sample texture data.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function SamplerState (sampler)
{
	/// <summary>
	/// Gets or sets the texture-address mode for the u-coordinate.
	/// </summary>
	this.AddressU = (sampler != null) ? sampler.AddressU : SamplerState.TextureAddressMode.Repeat;


	/// <summary>
	/// Gets or sets the texture-address mode for the v-coordinate.
	/// </summary>
	this.AddressV = (sampler != null) ? sampler.AddressV : SamplerState.TextureAddressMode.Repeat;


	/// <summary>
	/// Gets or sets the texture-address mode for the w-coordinate.
	/// </summary>
	this.AddressW = (sampler != null) ? sampler.AddressW : SamplerState.TextureAddressMode.Repeat;


	/// <summary>
	/// Gets or sets the type of filtering during sampling.
	/// </summary>
	this.Filter = (sampler != null) ? sampler.Filter : SamplerState.TextureFilter.Linear;


	/// <summary>
	/// Gets or sets whether the texture has mip maps.
	/// </summary>
	this.HasMipMap = (sampler != null) ? sampler.HasMipMap : false;

	
	/// <summary>
	/// Gets or sets the maximum anisotropy. The default value is 4.
	/// </summary>
	this.MaxAnisotropy = (sampler != null) ? sampler.MaxAnisotropy : 4;


	/// <summary>
	/// Gets or sets the level of detail (LOD) index of the largest map to use.
	/// </summary>
	this.MaxMipLevel = (sampler != null) ? sampler.MaxMipLevel : 0;
};


/// <summary>
/// Enumeration of the possible texture modes for each address.
/// </summary>
SamplerState.TextureAddressMode =
{
	/// <summary>
	/// Texture coordinates outside the range [0.0, 1.0] are set to
	/// the texture color at 0.0 or 1.0, respectively.
	/// </summary>
	Clamp : 0,

	/// <summary>
	/// Tile the texture at every integer junction. For example, for u
	/// values between 0 and 3, the texture is repeated three times.
	/// </summary>
	Repeat : 1
};


/// <summary>
/// Enumeration of the possible texture filters.
/// </summary>
SamplerState.TextureFilter =
{
	/// <summary>
	/// Use linear filtering.
	/// </summary>
	Linear : 1,

	/// <summary>
	/// Use point filtering.
	/// </summary>
	Point : 2,

	/// <summary>
	/// Use anisotropic filtering.
	/// </summary>
	Anisotropic : 4,

	/// <summary>
	/// Use linear filtering to shrink or expand, and point filtering
	/// between mipmap levels (mip).
	/// </summary>
	LinearMipPoint : 8,

	/// <summary>
	/// Use point filtering to shrink (minify) or expand (magnify), and
	/// linear filtering between mipmap levels.
	/// </summary>
	PointMipLinear : 16,

	/// <summary>
	/// Use linear filtering to shrink, point filtering to expand, and
	/// linear filtering between mipmap levels.
	/// </summary>
	MinLinearMagPointMipLinear : 32,

	/// <summary>
	/// Use linear filtering to shrink, point filtering to expand, and
	/// point filtering between mipmap levels.
	/// </summary>
	MinLinearMagPointMipPoint : 64,

	/// <summary>
	/// Use point filtering to shrink, linear filtering to expand, and
	/// linear filtering between mipmap levels.
	/// </summary>
	MinPointMagLinearMipLinear : 128,

	/// <summary>
	/// Use point filtering to shrink, linear filtering to expand, and
	/// point filtering between mipmap levels.
	/// </summary>
	MinPointMagLinearMipPoint : 256
};


/// <summary>
/// Contains default state for linear filtering and texture coordinate clamping.
/// </summary>
SamplerState.LinearClamp = new SamplerState();
SamplerState.LinearClamp.AddressU = SamplerState.TextureAddressMode.Clamp;
SamplerState.LinearClamp.AddressV = SamplerState.TextureAddressMode.Clamp;
SamplerState.LinearClamp.AddressW = SamplerState.TextureAddressMode.Clamp;
SamplerState.LinearClamp.Filter = SamplerState.TextureFilter.Linear;


/// <summary>
/// Contains default state for linear filtering and texture coordinate repeat.
/// </summary>
SamplerState.LinearRepeat = new SamplerState();
SamplerState.LinearRepeat.AddressU = SamplerState.TextureAddressMode.Repeat;
SamplerState.LinearRepeat.AddressV = SamplerState.TextureAddressMode.Repeat;
SamplerState.LinearRepeat.AddressW = SamplerState.TextureAddressMode.Repeat;
SamplerState.LinearRepeat.Filter = SamplerState.TextureFilter.Linear;


/// <summary>
/// Contains default state for point filtering and texture coordinate clamping.
/// </summary>
SamplerState.PointClamp = new SamplerState();
SamplerState.PointClamp.AddressU = SamplerState.TextureAddressMode.Clamp;
SamplerState.PointClamp.AddressV = SamplerState.TextureAddressMode.Clamp;
SamplerState.PointClamp.AddressW = SamplerState.TextureAddressMode.Clamp;
SamplerState.PointClamp.Filter = SamplerState.TextureFilter.Point;


/// <summary>
/// Contains default state for point filtering and texture coordinate repeat.
/// </summary>
SamplerState.PointRepeat = new SamplerState();
SamplerState.PointRepeat.AddressU = SamplerState.TextureAddressMode.Repeat;
SamplerState.PointRepeat.AddressV = SamplerState.TextureAddressMode.Repeat;
SamplerState.PointRepeat.AddressW = SamplerState.TextureAddressMode.Repeat;
SamplerState.PointRepeat.Filter = SamplerState.TextureFilter.Point;