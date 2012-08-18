// FramebufferObject represents a single buffer that is used to store rendered
// images.
// If a TextureObject is defined, the results will be written to the texture
// object.
// Otherwise the results will be saved to a renderbuffer object with the
// TextureFormat.
//
// If a texture object is provided, the application is resonsible for creating
// and releasing the texture resource.

// <param name="type">Specifies the type of buffer object.</type>
function FrameBufferObject(type) {
	// Gets or sets the type of buffer object.
	this.type = (type != null) ? type : FrameBufferObject.BufferType.Colour;

	// Id of the render buffer or texture buffer. This is automatically set
	// by the FBO.
	this.id = null;

	// Gets or sets the render buffer format. This is only required if the
	// texture object has not been set.
	this.renderBufferFormat = Texture.Format.Rgba;

	// If set, the render buffer will output the results
	// to this texture object instead of a render buffer.
	this.textureObject = null;
}

// Enumeration of the possible buffer types.
FrameBufferObject.BufferType = {
	Colour : 0,
	Depth : 1,
	Stencil : 2
};

// GLFrameBufferObject provides FBO access to render scenes off screen.
function GLFrameBufferObject() {
	// Identifier assigned to the frame buffer.
	this.mFrameBufferID = null;

	// Pixel dimensions of the frame buffer width.
	this.mFrameWidth = null;

	// Pixel dimensions of the frame buffer height.
	this.mFrameHeight = null;

	// Colour buffer object.
	this.mColourBuffer = null;

	// Depth buffer object.
	this.mDepthBuffer = null;

	// Stencil buffer object.
	this.mStencilBuffer = null;
}

// Create a new FBO rendering to a texture object.
// <param name="width">Width of the FBO, in pixels.</param>
// <param name="height">Height of the FBO, in pixels.</param>
// <returns>True if the FBO was created successfully.</returns>
GLFrameBufferObject.prototype.create = function(width, height) {
	// Cleanup
	this.release();

	// Set members
	this.mFrameWidth = width;
	this.mFrameHeight = height;

	// Create a frame buffer object
	this.mFrameBufferID = gl.createFramebuffer();
	return (this.mFrameBufferID != null);
}

GLFrameBufferObject.prototype.getFrameBufferObject = function(type) {
	switch(type) {
		case FrameBufferObject.BufferType.Colour:
			return this.mColourBuffer;
		case FrameBufferObject.BufferType.Depth:
			return this.mDepthBuffer;
		case FrameBufferObject.BufferType.Stencil:
			return this.mStencilBuffer;
	}
	return null;
}

GLFrameBufferObject.prototype.setFrameBufferObject = function(buffer) {
	switch(buffer.type) {
		case FrameBufferObject.BufferType.Colour:
			this.mColourBuffer = buffer;
		case FrameBufferObject.BufferType.Depth:
			this.mDepthBuffer = buffer;
		case FrameBufferObject.BufferType.Stencil:
			this.mStencilBuffer = buffer;
	}
}
// Attach a texture or render buffer object to the FBO.
// <param name="buffer">Buffer to attach to the FBO.</param>
// <returns>True if the buffer was attached successfully.</returns>
GLFrameBufferObject.prototype.attachBuffer = function(buffer) {
	if (this.mFrameBufferID != null) {
		var frameBufferObject = this.getFrameBufferObject(buffer.type);

		// Release any existing render buffer
		if ((frameBufferObject != null) && (frameBufferObject.id != null)) {
			if (frameBufferObject.textureObject == null)
				gl.deleteRenderbuffer(frameBufferObject.id);
			frameBufferObject.id = null;
		}

		// Assign
		frameBufferObject = buffer;

		// Attach buffer
		gl.bindFramebuffer(gl.FRAMEBUFFER, this.mFrameBufferID);
		if (frameBufferObject.textureObject != null) {
			// Ensure the texture has the same dimensions as the framebuffer
			if ((frameBufferObject.textureObject.getWidth() != this.mFrameWidth) && (frameBufferObject.textureObject.getHeight() != this.mFrameHeight)) {
				frameBufferObject.textureObject.create(this.mFrameWidth, this.mFrameHeight, frameBufferObject.textureObject.getFormat(), frameBufferObject.textureObject.getSamplerState());
			}

			frameBufferObject.id = frameBufferObject.textureObject.getTextureId();
			if (frameBufferObject.id == null)
				return false;

			var attachment = (buffer.type == FrameBufferObject.BufferType.Colour) ? gl.COLOR_ATTACHMENT0 : (buffer.type == FrameBufferObject.BufferType.Depth) ? gl.DEPTH_ATTACHMENT : gl.STENCIL_ATTACHMENT;

			// Attach buffer to FBO
			gl.framebufferTexture2D(gl.FRAMEBUFFER, attachment, (frameBufferObject.textureObject.getTextureType() == GLTexture.TextureType.TextureCube) ? gl.TEXTURE_CUBE_MAP_POSITIVE_X : gl.TEXTURE_2D, frameBufferObject.id, 0);
		} else {
			// Create render buffer
			frameBufferObject.id = gl.createRenderbuffer();
			if (frameBufferObject.id == null)
				return false;

			gl.bindRenderbuffer(gl.RENDERBUFFER, frameBufferObject.id);
			gl.renderbufferStorage(gl.RENDERBUFFER, (frameBufferObject.renderBufferFormat == Texture.Format.Rgba) ? gl.RGBA : (frameBufferObject.renderBufferFormat == Texture.Format.Rgb) ? gl.RGB : (frameBufferObject.renderBufferFormat == Texture.Format.Depth) ? gl.DEPTH_COMPONENT : (frameBufferObject.renderBufferFormat == Texture.Format.Depth16) ? gl.DEPTH_COMPONENT16 : (frameBufferObject.renderBufferFormat == Texture.Format.Depth24) ? gl.DEPTH_COMPONENT24 : (frameBufferObject.renderBufferFormat == Texture.Format.Depth32) ? gl.DEPTH_COMPONENT32 : (frameBufferObject.renderBufferFormat == Texture.Format.Alpha8) ? gl.LUMINANCE : gl.LUMINANCE_ALPHA, this.mFrameWidth, this.mFrameHeight);

			// Attach buffer to FBO
			gl.framebufferRenderbuffer(gl.FRAMEBUFFER, (buffer.type == FrameBufferObject.BufferType.Colour) ? gl.COLOR_ATTACHMENT0 : (buffer.type == FrameBufferObject.BufferType.Depth) ? gl.DEPTH_ATTACHMENT : gl.STENCIL_ATTACHMENT, gl.RENDERBUFFER, frameBufferObject.id);
			gl.bindRenderbuffer(gl.RENDERBUFFER, null);
		}

		// Unbind
		gl.bindFramebuffer(gl.FRAMEBUFFER, null);

		// Copy
		this.setFrameBufferObject(buffer);

		return true;
	}

	return false;
}
// Resize an existing FBO.
// <param name="width">Width of the FBO, in pixels.</param>
// <param name="height">Height of the FBO, in pixels.</param>
GLFrameBufferObject.prototype.resize = function(width, height) {
	if (this.mFrameBufferID != null) {
		// Set members
		this.mFrameWidth = width;
		this.mFrameHeight = height;

		// Update buffers
		if (this.mColourBuffer != null)
			this.attachBuffer(this.mColourBuffer);
		if (this.mDepthBuffer != null)
			this.attachBuffer(this.mDepthBuffer);
		if (this.mStencilBuffer != null)
			this.attachBuffer(this.mStencilBuffer);
	}
}
// Release resources used by the FBO.
GLFrameBufferObject.prototype.release = function() {
	// Clear colour buffer
	if (this.mColourBuffer != null) {
		if (this.mColourBuffer.textureObject == null)
			gl.deleteRenderbuffer(this.mColourBuffer.id);
		this.mColourBuffer = null;
	}

	// Clear depth buffer
	if (this.mDepthBuffer != null) {
		if (this.mDepthBuffer.textureObject == null)
			gl.deleteRenderbuffer(this.mDepthBuffer.id);
		this.mDepthBuffer = null;
	}

	// Clear stencil buffer
	if (this.mStencilBuffer != null) {
		if (this.mStencilBuffer.textureObject == null)
			gl.deleteRenderbuffer(this.mStencilBuffer.id);
		this.mStencilBuffer = null;
	}

	// Clear frame buffer
	if (this.mFrameBufferID != null) {
		gl.deleteFramebuffer(this.mFrameBufferID);
		this.mFrameBufferID = null;
	}

	// Reset members
	this.mFrameWidth = 0;
	this.mFrameHeight = 0;
}
// Enable FBO rendering.
GLFrameBufferObject.prototype.enable = function() {
	gl.bindFramebuffer(gl.FRAMEBUFFER, this.mFrameBufferID);
}
// Enable VBO with cubemap face to render to/from.
// <param name="face">Cubemap face to bind and render to/from.</param>
GLFrameBufferObject.prototype.enableCubemap = function(face) {
	gl.bindFramebuffer(gl.FRAMEBUFFER, this.mFrameBufferID);
	gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, face, this.mColourBuffer.id, 0);
}
// Disable FBO rendering.
GLFrameBufferObject.prototype.disable = function() {
	gl.bindFramebuffer(gl.FRAMEBUFFER, null);
}
// Returns the width of the FBO, in pixels.
// <returns>The width of the FBO, in pixels.</returns>
GLFrameBufferObject.prototype.getFrameWidth = function() {
	return this.mFrameWidth;
}
// Returns the height of the FBO, in pixels.
// <returns>The height of the FBO, in pixels.</returns>
GLFrameBufferObject.prototype.getFrameHeight = function() {
	return this.mFrameHeight;
}