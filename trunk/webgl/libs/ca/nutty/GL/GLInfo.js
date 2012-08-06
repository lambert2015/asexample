// <summary>
// This class stores information about the OpenGL context. It is used to determine what
// features and extensions are available on the target hardware.
// </summary>


// <summary>
// Constructor.
// <summary>
function GLInfo ()
{
	// <summary>
	// Stores the company responsible for this GL implementation. This name does not change
	// from release to release.
	// </summary>
	this.Vendor = gl.getParameter(gl.VENDOR);


	// <summary>
	// Returns the name of the renderer. This name is typically specific to a particular
	// configuration of a hardware platform. It does not change from release to release.
	// </summary>
	this.Renderer = gl.getParameter(gl.RENDERER);


	// <summary>
	// Returns a version or release number.
	// </summary>
	this.Version = gl.getParameter(gl.VERSION);


	// <summary>
	// Stores a list of extensions supported by this context.
	// </summary>
	this.Extension = gl.getSupportedExtensions();


	// <summary>
	// The value gives a rough estimate of the largest cube-map texture that
	// the GL can handle. The value must be at least 16.
	// </summary>
	this.MaxCubeMapTextureSize = gl.getParameter(gl.MAX_CUBE_MAP_TEXTURE_SIZE);


	// <summary>
	// The maximum number of individual floating-point, integer, or boolean values that can be held
	// in uniform variable storage for a fragment shader. The value must be at least 64.
	// </summary>
	//this.MaxFragmentUniformComponents = gl.getParameter(gl.MAX_FRAGMENT_UNIFORM_COMPONENTS);


	// <summary>
	// The maximum number of four-element floating-point, integer, or boolean vectors that can be held 
	// in uniform variable storage for a fragment shader. The value must be at least 16.
	// </summary>
	this.MaxFragmentUniformVectors = gl.getParameter(gl.MAX_FRAGMENT_UNIFORM_VECTORS);


	// <summary>
	// The value indicates the largest renderbuffer width and height that the GL can handle.
	// The value must be at least 1.
	// </summary>
	this.MaxRenderbufferSize = gl.getParameter(gl.MAX_RENDERBUFFER_SIZE);


	// <summary>
	// The maximum supported texture image units that can be used to access texture
	// maps from the fragment shader. The value must be at least 2.
	// </summary>
	this.MaxTextureImageUnits = gl.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS);


	// <summary>
	// The value gives a rough estimate of the largest texture that
	// the GL can handle. The value must be at least 64.
	// </summary>
	this.MaxTextureSize = gl.getParameter(gl.MAX_TEXTURE_SIZE);


	// <summary>
	// The maximum number of 4-component generic vertex attributes accessible to a vertex shader.
	// The value must be at least 16.
	// </summary>
	this.MaxVertexAttribs = gl.getParameter(gl.MAX_VERTEX_ATTRIBS);


	// <summary>
	// The maximum supported texture image units that can be used to access texture maps from
	// the vertex shader. The value may be 0.
	// </summary>
	this.MaxVertexTextureImageUnits = gl.getParameter(gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS);
	
	
	// <summary>
	// The maximum number of individual floating-point, integer, or boolean values that can be held 
	// in uniform variable storage for a vertex shader. The value must be at least 512.
	// </summary>
	//this.MaxVertexUniformComponents = gl.getParameter(gl.MAX_VERTEX_UNIFORM_COMPONENTS);


	// <summary>
	// The maximum number of four-element floating-point, integer, or boolean vectors that can be held
	// in uniform variable storage for a vertex shader. The value must be at least 128.
	// </summary>
	this.MaxVertexUniformVectors = gl.getParameter(gl.MAX_VERTEX_UNIFORM_VECTORS);


	// <summary>
	// The maximum number four-element floating-point vectors available for interpolating varying variables used by
	// vertex and fragment shaders. Varying variables declared as matrices or arrays will consume multiple
	// interpolators. The value must be at least 8.
	// </summary>
	this.MaxVertexVaryingVectors = gl.getParameter(gl.MAX_VARYING_VECTORS);


	// <summary>
	// The maximum supported width and height of the viewport. These must be at least as large as
	// the visible dimensions of the display being rendered to.
	// </summary>
	this.MaxViewportDimension = gl.getParameter(gl.MAX_VIEWPORT_DIMS);


	// <summary>
	// A single integer value indicating the number of available compressed texture formats.
	// The minimum value is 0.
	// </summary>
	this.NumCompressedTextureFormats = gl.getParameter(gl.NUM_COMPRESSED_TEXTURE_FORMATS);
}