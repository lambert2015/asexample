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
/// This class stores information about the OpenGL context. It is used to determine what
/// features and extensions are available on the target hardware.
/// </summary>


/// <summary>
/// Constructor.
/// <summary>
function GLInfo ()
{
	/// <summary>
	/// Stores the company responsible for this GL implementation. This name does not change
	/// from release to release.
	/// </summary>
	this.Vendor = gl.getParameter(gl.VENDOR);


	/// <summary>
	/// Returns the name of the renderer. This name is typically specific to a particular
	/// configuration of a hardware platform. It does not change from release to release.
	/// </summary>
	this.Renderer = gl.getParameter(gl.RENDERER);


	/// <summary>
	/// Returns a version or release number.
	/// </summary>
	this.Version = gl.getParameter(gl.VERSION);


	/// <summary>
	/// Stores a list of extensions supported by this context.
	/// </summary>
	this.Extension = gl.getSupportedExtensions();


	/// <summary>
	/// The value gives a rough estimate of the largest cube-map texture that
	/// the GL can handle. The value must be at least 16.
	/// </summary>
	this.MaxCubeMapTextureSize = gl.getParameter(gl.MAX_CUBE_MAP_TEXTURE_SIZE);


	/// <summary>
	/// The maximum number of individual floating-point, integer, or boolean values that can be held
	/// in uniform variable storage for a fragment shader. The value must be at least 64.
	/// </summary>
	//this.MaxFragmentUniformComponents = gl.getParameter(gl.MAX_FRAGMENT_UNIFORM_COMPONENTS);


	/// <summary>
	/// The maximum number of four-element floating-point, integer, or boolean vectors that can be held 
	/// in uniform variable storage for a fragment shader. The value must be at least 16.
	/// </summary>
	this.MaxFragmentUniformVectors = gl.getParameter(gl.MAX_FRAGMENT_UNIFORM_VECTORS);


	/// <summary>
	/// The value indicates the largest renderbuffer width and height that the GL can handle.
	/// The value must be at least 1.
	/// </summary>
	this.MaxRenderbufferSize = gl.getParameter(gl.MAX_RENDERBUFFER_SIZE);


	/// <summary>
	/// The maximum supported texture image units that can be used to access texture
	/// maps from the fragment shader. The value must be at least 2.
	/// </summary>
	this.MaxTextureImageUnits = gl.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS);


	/// <summary>
	/// The value gives a rough estimate of the largest texture that
	/// the GL can handle. The value must be at least 64.
	/// </summary>
	this.MaxTextureSize = gl.getParameter(gl.MAX_TEXTURE_SIZE);


	/// <summary>
	/// The maximum number of 4-component generic vertex attributes accessible to a vertex shader.
	/// The value must be at least 16.
	/// </summary>
	this.MaxVertexAttribs = gl.getParameter(gl.MAX_VERTEX_ATTRIBS);


	/// <summary>
	/// The maximum supported texture image units that can be used to access texture maps from
	/// the vertex shader. The value may be 0.
	/// </summary>
	this.MaxVertexTextureImageUnits = gl.getParameter(gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS);
	
	
	/// <summary>
	/// The maximum number of individual floating-point, integer, or boolean values that can be held 
	/// in uniform variable storage for a vertex shader. The value must be at least 512.
	/// </summary>
	//this.MaxVertexUniformComponents = gl.getParameter(gl.MAX_VERTEX_UNIFORM_COMPONENTS);


	/// <summary>
	/// The maximum number of four-element floating-point, integer, or boolean vectors that can be held
	/// in uniform variable storage for a vertex shader. The value must be at least 128.
	/// </summary>
	this.MaxVertexUniformVectors = gl.getParameter(gl.MAX_VERTEX_UNIFORM_VECTORS);


	/// <summary>
	/// The maximum number four-element floating-point vectors available for interpolating varying variables used by
	/// vertex and fragment shaders. Varying variables declared as matrices or arrays will consume multiple
	/// interpolators. The value must be at least 8.
	/// </summary>
	this.MaxVertexVaryingVectors = gl.getParameter(gl.MAX_VARYING_VECTORS);


	/// <summary>
	/// The maximum supported width and height of the viewport. These must be at least as large as
	/// the visible dimensions of the display being rendered to.
	/// </summary>
	this.MaxViewportDimension = gl.getParameter(gl.MAX_VIEWPORT_DIMS);


	/// <summary>
	/// A single integer value indicating the number of available compressed texture formats.
	/// The minimum value is 0.
	/// </summary>
	this.NumCompressedTextureFormats = gl.getParameter(gl.NUM_COMPRESSED_TEXTURE_FORMATS);
}