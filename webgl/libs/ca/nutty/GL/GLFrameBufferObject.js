// FramebufferObject represents a single buffer that is used to store rendered images.
// If a TextureObject is defined, the results will be written to the texture object.
// Otherwise the results will be saved to a renderbuffer object with the TextureFormat.
//
// If a texture object is provided, the application is resonsible for creating
// and releasing the texture resource.

// <param name="type">Specifies the type of buffer object.</type>
function FrameBufferObject (type)
{
	
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

FrameBufferObject.BufferType = 
{
	Colour : 0,
	Depth : 1,
	Stencil : 2
};



// GLFrameBufferObject provides FBO access to render scenes off screen.




// Constructor.

function GLFrameBufferObject ()
{
	
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
GLFrameBufferObject.prototype.create = function (width, height)
{
	// Cleanup
	this.release();

	// Set members
	this.mFrameWidth = width;
	this.mFrameHeight = height;
	
	// Create a frame buffer object
	this.mFrameBufferID = gl.createFramebuffer();
	return (this.mFrameBufferID != null);
}



// Attach a texture or render buffer object to the FBO.

// <param name="buffer">Buffer to attach to the FBO.</param>
// <returns>True if the buffer was attached successfully.</returns>
GLFrameBufferObject.prototype.attachBuffer = function (buffer)
{
	if ( this.mFrameBufferID != null )
	{
		var frameBufferObject = (buffer.Type == FrameBufferObject.BufferType.Colour) ? this.mColourBuffer :
								(buffer.Type == FrameBufferObject.BufferType.Depth) ? this.mDepthBuffer :
								this.mStencilBuffer;


		// Release any existing render buffer
		if ( (frameBufferObject != null) && (frameBufferObject.Id != null) )
		{
			if ( frameBufferObject.TextureObject == null )
				gl.deleteRenderbuffer(frameBufferObject.Id);
			frameBufferObject.Id = null;
		}


		// Assign
		frameBufferObject = buffer;
		

		// Attach buffer
		gl.bindFramebuffer(gl.FRAMEBUFFER, this.mFrameBufferID);
		if ( frameBufferObject.TextureObject != null )
		{
			// Ensure the texture has the same dimensions as the framebuffer
			if ( (frameBufferObject.TextureObject.GetWidth() != this.mFrameWidth) &&
				 (frameBufferObject.TextureObject.GetHeight() != this.mFrameHeight) )
			{
				frameBufferObject.TextureObject.Create(this.mFrameWidth,
													   this.mFrameHeight,
													   frameBufferObject.TextureObject.GetFormat(),
													   frameBufferObject.TextureObject.GetSamplerState());
			}

			frameBufferObject.Id = frameBufferObject.TextureObject.GetTextureId();
			if ( frameBufferObject.Id == null )
				return false;

			// Attach buffer to FBO
			gl.framebufferTexture2D(gl.FRAMEBUFFER,
									(buffer.Type == FrameBufferObject.BufferType.Colour) ? gl.COLOR_ATTACHMENT0 :
									(buffer.Type == FrameBufferObject.BufferType.Depth) ? gl.DEPTH_ATTACHMENT :
									gl.STENCIL_ATTACHMENT,
									(frameBufferObject.TextureObject.GetTextureType() == GLTexture.TextureType.TextureCube) ? gl.TEXTURE_CUBE_MAP_POSITIVE_X : gl.TEXTURE_2D,
									frameBufferObject.Id,
									0);
		}
		else
		{
			// Create render buffer
			frameBufferObject.Id = gl.createRenderbuffer();
			if ( frameBufferObject.Id == null )
				return false;

			gl.bindRenderbuffer(gl.RENDERBUFFER, frameBufferObject.Id);
			gl.renderbufferStorage(gl.RENDERBUFFER,
								   (frameBufferObject.RenderBufferFormat == Texture.Format.Rgba) ? gl.RGBA :
								   (frameBufferObject.RenderBufferFormat == Texture.Format.Rgb) ? gl.RGB :
								   (frameBufferObject.RenderBufferFormat == Texture.Format.Depth) ? gl.DEPTH_COMPONENT :
								   (frameBufferObject.RenderBufferFormat == Texture.Format.Depth16) ? gl.DEPTH_COMPONENT16 :
								   (frameBufferObject.RenderBufferFormat == Texture.Format.Depth24) ? gl.DEPTH_COMPONENT24 :
								   (frameBufferObject.RenderBufferFormat == Texture.Format.Depth32) ? gl.DEPTH_COMPONENT32 :
								   (frameBufferObject.RenderBufferFormat == Texture.Format.Alpha8) ? gl.LUMINANCE :
								   gl.LUMINANCE_ALPHA,
								   this.mFrameWidth,
								   this.mFrameHeight);

			// Attach buffer to FBO
			gl.framebufferRenderbuffer(gl.FRAMEBUFFER,
									   (buffer.Type == FrameBufferObject.BufferType.Colour) ? gl.COLOR_ATTACHMENT0 :
									   (buffer.Type == FrameBufferObject.BufferType.Depth) ? gl.DEPTH_ATTACHMENT :
									   gl.STENCIL_ATTACHMENT,
									   gl.RENDERBUFFER,
									   frameBufferObject.Id);
			gl.bindRenderbuffer(gl.RENDERBUFFER, null);
		}

		// Unbind
		gl.bindFramebuffer(gl.FRAMEBUFFER, null);
		
		// Copy
		if ( buffer.Type == FrameBufferObject.BufferType.Colour )
			this.mColourBuffer = frameBufferObject;
		else if ( buffer.Type == FrameBufferObject.BufferType.Depth )
			this.mDepthBuffer = frameBufferObject;
		else
			this.mStencilBuffer = frameBufferObject;

		return true;
	}

	return false;
}



// Resize an existing FBO.

// <param name="width">Width of the FBO, in pixels.</param>
// <param name="height">Height of the FBO, in pixels.</param>
GLFrameBufferObject.prototype.resize = function (width, height)
{
	if ( this.mFrameBufferID != null )
	{
		// Set members
		this.mFrameWidth = width;
		this.mFrameHeight = height;
		
		// Update buffers
		if ( this.mColourBuffer != null )
			this.AttachBuffer(this.mColourBuffer);
		if ( this.mDepthBuffer != null )
			this.AttachBuffer(this.mDepthBuffer);
		if ( this.mStencilBuffer != null )
			this.AttachBuffer(this.mStencilBuffer);
	}
}



// Release resources used by the FBO.

GLFrameBufferObject.prototype.release = function ()
{
	// Clear colour buffer
	if ( this.mColourBuffer != null )
	{
		if ( this.mColourBuffer.TextureObject == null )
			gl.deleteRenderbuffer(this.mColourBuffer.Id);
		this.mColourBuffer = null;
	}

	// Clear depth buffer
	if ( this.mDepthBuffer != null )
	{
		if ( this.mDepthBuffer.TextureObject == null )
			gl.deleteRenderbuffer(this.mDepthBuffer.Id);
		this.mDepthBuffer = null;
	}

	// Clear stencil buffer
	if ( this.mStencilBuffer != null )
	{
		if ( this.mStencilBuffer.TextureObject == null )
			gl.deleteRenderbuffer(this.mStencilBuffer.Id);
		this.mStencilBuffer = null;
	}

	// Clear frame buffer
	if ( this.mFrameBufferID != null )
	{
		gl.deleteFramebuffer(this.mFrameBufferID);
		this.mFrameBufferID = null;
	}

	// Reset members
	this.mFrameWidth = 0;
	this.mFrameHeight = 0;
}



// Enable FBO rendering.

GLFrameBufferObject.prototype.enable = function ()
{
	gl.bindFramebuffer(gl.FRAMEBUFFER, this.mFrameBufferID);
}



// Enable VBO with cubemap face to render to/from.

// <param name="face">Cubemap face to bind and render to/from.</param>
GLFrameBufferObject.prototype.enableCubemap = function (face)
{
	gl.bindFramebuffer(gl.FRAMEBUFFER, this.mFrameBufferID);
	gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, face, this.mColourBuffer.Id, 0);
}



// Disable FBO rendering.

GLFrameBufferObject.prototype.disable = function ()
{
	gl.bindFramebuffer(gl.FRAMEBUFFER, null);
}



// Returns the width of the FBO, in pixels.

// <returns>The width of the FBO, in pixels.</returns>
GLFrameBufferObject.prototype.getFrameWidth = function ()
{
	return this.mFrameWidth;
}



// Returns the height of the FBO, in pixels.

// <returns>The height of the FBO, in pixels.</returns>
GLFrameBufferObject.prototype.getFrameHeight = function ()
{
	return this.mFrameHeight;
}