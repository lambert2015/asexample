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
/// FramebufferObject represents a single buffer that is used to store rendered images.
/// If a TextureObject is defined, the results will be written to the texture object.
/// Otherwise the results will be saved to a renderbuffer object with the TextureFormat.
///
/// If a texture object is provided, the application is resonsible for creating
/// and releasing the texture resource.
/// <summary>


/// <summary>
/// Constructor.
/// </summary>
/// <param name="type">Specifies the type of buffer object.</type>
function FrameBufferObject (type)
{
	/// <summary>
	/// Gets or sets the type of buffer object.
	/// </summary>
	this.Type = (type != null) ? type : FrameBufferObject.BufferType.Colour;


	/// <summary>
	/// Id of the render buffer or texture buffer. This is automatically set
	/// by the FBO.
	/// </summary>
	this.Id = null;


	/// <summary>
	/// Gets or sets the render buffer format. This is only required if the
	/// texture object has not been set.
	/// </summary>
	this.RenderBufferFormat = Texture.Format.Rgba;
	
	
	/// <summary>
	/// If set, the render buffer will output the results
	/// to this texture object instead of a render buffer.
	/// <summary>
	this.TextureObject = null;
}


/// <summary>
/// Enumeration of the possible buffer types.
/// <summary>
FrameBufferObject.BufferType = 
{
	Colour : 0,
	Depth : 1,
	Stencil : 2
};


/// <summary>
/// GLFrameBufferObject provides FBO access to render scenes off screen.
/// <summary>


/// <summary>
/// Constructor.
/// <summary>
function GLFrameBufferObject ()
{
	/// <summary>
	/// Identifier assigned to the frame buffer.
	/// <summary>
	this.mFrameBufferID = null;


	/// <summary>
	/// Pixel dimensions of the frame buffer width.
	/// <summary>
	this.mFrameWidth = null;


	/// <summary>
	/// Pixel dimensions of the frame buffer height.
	/// <summary>
	this.mFrameHeight = null;


	/// <summary>
	/// Colour buffer object.
	/// <summary>
	this.mColourBuffer = null;


	/// <summary>
	/// Depth buffer object.
	/// <summary>
	this.mDepthBuffer = null;


	/// <summary>
	/// Stencil buffer object.
	/// <summary>
	this.mStencilBuffer = null;
}


/// <summary>
/// Create a new FBO rendering to a texture object.
/// <summary>
/// <param name="width">Width of the FBO, in pixels.</param>
/// <param name="height">Height of the FBO, in pixels.</param>
/// <returns>True if the FBO was created successfully.</returns>
GLFrameBufferObject.prototype.Create = function (width, height)
{
	// Cleanup
	this.Release();

	// Set members
	this.mFrameWidth = width;
	this.mFrameHeight = height;
	
	// Create a frame buffer object
	this.mFrameBufferID = gl.createFramebuffer();
	return (this.mFrameBufferID != null);
}


/// <summary>
/// Attach a texture or render buffer object to the FBO.
/// <summary>
/// <param name="buffer">Buffer to attach to the FBO.</param>
/// <returns>True if the buffer was attached successfully.</returns>
GLFrameBufferObject.prototype.AttachBuffer = function (buffer)
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


/// <summary>
/// Resize an existing FBO.
/// <summary>
/// <param name="width">Width of the FBO, in pixels.</param>
/// <param name="height">Height of the FBO, in pixels.</param>
GLFrameBufferObject.prototype.Resize = function (width, height)
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


/// <summary>
/// Release resources used by the FBO.
/// <summary>
GLFrameBufferObject.prototype.Release = function ()
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


/// <summary>
/// Enable FBO rendering.
/// <summary>
GLFrameBufferObject.prototype.Enable = function ()
{
	gl.bindFramebuffer(gl.FRAMEBUFFER, this.mFrameBufferID);
}


/// <summary>
/// Enable VBO with cubemap face to render to/from.
/// <summary>
/// <param name="face">Cubemap face to bind and render to/from.</param>
GLFrameBufferObject.prototype.EnableCubemap = function (face)
{
	gl.bindFramebuffer(gl.FRAMEBUFFER, this.mFrameBufferID);
	gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, face, this.mColourBuffer.Id, 0);
}


/// <summary>
/// Disable FBO rendering.
/// <summary>
GLFrameBufferObject.prototype.Disable = function ()
{
	gl.bindFramebuffer(gl.FRAMEBUFFER, null);
}


/// <summary>
/// Returns the width of the FBO, in pixels.
/// <summary>
/// <returns>The width of the FBO, in pixels.</returns>
GLFrameBufferObject.prototype.GetFrameWidth = function ()
{
	return this.mFrameWidth;
}


/// <summary>
/// Returns the height of the FBO, in pixels.
/// <summary>
/// <returns>The height of the FBO, in pixels.</returns>
GLFrameBufferObject.prototype.GetFrameHeight = function ()
{
	return this.mFrameHeight;
}