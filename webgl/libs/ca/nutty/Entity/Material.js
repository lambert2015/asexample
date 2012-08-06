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
/// This class defines material properties.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function Material (material)
{
	/// <summary>
	/// Ambient constant (0.0, 1.0).
	/// </summary>
	this.Ka = (material != null) ? material.Ka : 1.0;


	/// <summary>
	/// Ambient colour (R, G, B).
	/// </summary>
	this.Ambient = (material != null) ? new Point(material.Ambient.x, material.Ambient.y, material.Ambient.z) : new Point();


	/// <summary>
	/// Diffuse constant (0.0, 1.0).
	/// </summary>
	this.Kd = (material != null) ? material.Kd : 1.0;


	/// <summary>
	/// Diffuse colour (R, G, B).
	/// </summary>
	this.Diffuse = (material != null) ? new Point(material.Diffuse.x, material.Diffuse.y, material.Diffuse.z) : new Point(0.8, 0.8, 0.8);


	/// <summary>
	/// Alpha constant (0.0, 1.0).
	/// </summary>
	this.Alpha = (material != null) ? material.Alpha : 1.0;


	/// <summary>
	/// Specular constant (0.0, 1.0).
	/// </summary>
	this.Ks = (material != null) ? material.Ks : 1.0;


	/// <summary>
	/// Specular colour (R, G, B).
	/// </summary>
	this.Specular = (material != null) ? new Point(material.Specular.x, material.Specular.y, material.Specular.z) : new Point();


	/// <summary>
	/// Shininess constant (0.0, infinity).
	/// </summary>
	this.Shininess = (material != null) ? material.Shininess : 1.0;


	/// <summary>
	/// Texture associated with this material.
	/// </summary>
	this.Texture = (material != null) ? material.Texture : null;
	
	
	/// <summary>
	/// Amount of offset to apply to the texture.
	/// </summary>
	this.TextureOffset = (material != null) ? new Point(material.TextureOffset.x, material.TextureOffset.y, material.TextureOffset.z, material.TextureOffset.w) : new Point();


	/// <summary>
	/// Amount of scaling to apply to the texture.
	/// < 1 = Tiling
	/// > 1 = Zooming
	/// </summary>
	this.TextureScale = (material != null) ? new Point(material.TextureScale.x, material.TextureScale.y, material.TextureScale.z, material.TextureScale.w) : new Point(1, 1, 1, 1);
}