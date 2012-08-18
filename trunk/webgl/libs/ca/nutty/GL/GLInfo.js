// This class stores information about the OpenGL context. It is used to
// determine what
// features and extensions are available on the target hardware.
function GLInfo() {
	// Stores the company responsible for this GL implementation. This name does not
	// change
	// from release to release.
	this.vendor = gl.getParameter(gl.VENDOR);

	// Returns the name of the renderer. This name is typically specific to a
	// particular
	// configuration of a hardware platform. It does not change from release to
	// release.
	this.renderer = gl.getParameter(gl.RENDERER);

	// Returns a version or release number.
	this.version = gl.getParameter(gl.VERSION);

	// Stores a list of extensions supported by this context.
	this.extension = gl.getSupportedExtensions();

	// The value gives a rough estimate of the largest cube-map texture that
	// the GL can handle. The value must be at least 16.
	this.maxCubeMapTextureSize = gl.getParameter(gl.MAX_CUBE_MAP_TEXTURE_SIZE);

	// The maximum number of individual floating-point, integer, or boolean values
	// that can be held
	// in uniform variable storage for a fragment shader. The value must be at least
	// 64.
	//this.MaxFragmentUniformComponents =
	// gl.getParameter(gl.MAX_FRAGMENT_UNIFORM_COMPONENTS);

	// The maximum number of four-element floating-point, integer, or boolean vectors
	// that can be held
	// in uniform variable storage for a fragment shader. The value must be at least
	// 16.
	this.maxFragmentUniformVectors = gl.getParameter(gl.MAX_FRAGMENT_UNIFORM_VECTORS);

	// The value indicates the largest renderbuffer width and height that the GL can
	// handle.
	// The value must be at least 1.
	this.maxRenderbufferSize = gl.getParameter(gl.MAX_RENDERBUFFER_SIZE);

	// The maximum supported texture image units that can be used to access texture
	// maps from the fragment shader. The value must be at least 2.
	this.maxTextureImageUnits = gl.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS);

	// The value gives a rough estimate of the largest texture that
	// the GL can handle. The value must be at least 64.
	this.maxTextureSize = gl.getParameter(gl.MAX_TEXTURE_SIZE);

	// The maximum number of 4-component generic vertex attributes accessible to a
	// vertex shader.
	// The value must be at least 16.
	this.maxVertexAttribs = gl.getParameter(gl.MAX_VERTEX_ATTRIBS);

	// The maximum supported texture image units that can be used to access texture
	// maps from
	// the vertex shader. The value may be 0.
	this.maxVertexTextureImageUnits = gl.getParameter(gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS);

	// The maximum number of individual floating-point, integer, or boolean values
	// that can be held
	// in uniform variable storage for a vertex shader. The value must be at least
	// 512.
	//this.MaxVertexUniformComponents =
	// gl.getParameter(gl.MAX_VERTEX_UNIFORM_COMPONENTS);

	// The maximum number of four-element floating-point, integer, or boolean vectors
	// that can be held
	// in uniform variable storage for a vertex shader. The value must be at least
	// 128.
	this.maxVertexUniformVectors = gl.getParameter(gl.MAX_VERTEX_UNIFORM_VECTORS);

	// The maximum number four-element floating-point vectors available for
	// interpolating varying variables used by
	// vertex and fragment shaders. Varying variables declared as matrices or arrays
	// will consume multiple
	// interpolators. The value must be at least 8.
	this.maxVertexVaryingVectors = gl.getParameter(gl.MAX_VARYING_VECTORS);

	// The maximum supported width and height of the viewport. These must be at least
	// as large as
	// the visible dimensions of the display being rendered to.
	this.maxViewportDimension = gl.getParameter(gl.MAX_VIEWPORT_DIMS);

	// A single integer value indicating the number of available compressed texture
	// formats.
	// The minimum value is 0.
	this.numCompressedTextureFormats = gl.getParameter(gl.NUM_COMPRESSED_TEXTURE_FORMATS);
}