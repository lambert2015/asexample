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
/// This scene demonstrates how to render a depth of field effect. The process is as follows.
/// 1. Render the scene to a texture.
///
/// 2. Render the scene depth values to a texture. This is a separate process in OpenGL ES
///    because the depth texture format is not supported, but you could do it in a single pass
///    with normal OpenGL.
///
/// 3. Load both the scene colour and depth textures into the DOF blur shader. This shader will
///    blur the pixels based on their recorded depth values and using the DOF blur equation. The
///    further the depth value from the DOF region, the more the pixel is blurred, up to some maximum.
///
///    For improved performance and blurring quality, you should blur to a resolution smaller
///    then what you use for rendering the scene. 512 x 512 resolution produces a nice result.
///
/// 4. After rendering the blurred texture, blend the colour texture in step 1 with the blurred texture
///    produced in step 3. Pixels that are in focus will use the higher resolution texture whereas pixels
///    not in focus will sample from the lower resolution and blurred texture.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function DepthOfFieldScene ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	BaseScene.call(this);
	
	
	/// <summary>
	/// Stores the current inverse view matrix.
	/// </summary>
	this.mInvViewMatrix = null;
	
	
	/// <summary>
	/// The framebuffer object to store the colour buffer (ie: the result of the rendered scene).
	/// This will be fed into the blur shader.
	/// </summary>
	this.mFboColour = null;
	
	
	/// <summary>
	/// The framebuffer object to store the depth map. This will be fed into the
	/// blur shader.
	/// </summary>
	this.mFboDepth = null;
	
	
	/// <summary>
	/// The framebuffer object for performing the first pass [horizontal] blur using the
	/// separable blur algorithm. On the second pass, the final blurring will be stored
	/// into the mFboBlur2 colour target.
	/// </summary>
	this.mFboBlur = null;
	this.mFboBlur2 = null;
	
	
	/// <summary>
	/// Framebuffer objects.
	/// </summary>
	this.mFboColourColourBuffer = null;
	this.mFboColourDepthBuffer = null;
	
	this.mFboDepthColourBuffer = null;
	this.mFboDepthDepthBuffer = null;
	
	this.mFboBlurColourBuffer = null;

	
	/// <summary>
	/// Gets or sets the dimensions of the FBO, which may or may not be the same size
	/// as the window.
	/// </summary>
	this.mFboDimension = null;
	this.mFboDimensionBlur = null;
	
	
	/// <summary>
	/// The basic shader is responsible for rendering the scene as normal. It will produce
	/// the colour texture used in the blurring stage.
	/// </summary>
	this.mBasicShader = null;
	
	
	/// <summary>
	/// The depth shader is responsible for rendering the depth values. It will produce the
	/// depth texture used in the blurring stage.
	/// </summary>
	this.mDepthShader = null;
	
	
	/// <summary>
	/// The depth image shader is responsible for rendering the depth texture to screen. Useful for
	/// debugging or visualization purposes.
	/// </summary>
	this.mDepthImageShader = null;
	
	
	/// <summary>
	/// The shader to blur a texture. It uses the separable blur algorithm, which divides blurring
	/// into two passes. The first pass will render a horizontal blur. The second pass will render
	/// the vertical blur. This is much faster than using a traditional convolution filter algorithm.
	/// </summary>
	this.mDofBlurShader = null;
	
	
	/// <summary>
	/// The image shader will render the final post-processed texture to screen.
	/// </summary>
	this.mDofImageShader = null;
	
	
	/// <summary>
	/// Surface (rectangle) containing a texture to manipulate or view. Used for blurring and showing
	/// the final DOF result. It is designed to fit the size of the viewport.
	/// </summary>
	this.mSurface = null;
	
	
	/// <summary>
	/// Textures.
	/// </summary>
	this.mTexCheckerBoard = null;
	this.mTexRuler = null;
	
	
	/// <summary>
	/// Stores a reference to the canvas DOM element, which is used to reset the viewport
	/// back to its original size after rendering to the FBO, which uses a different
	/// dimension.
	/// </summary>
	this.mCanvas = null;
	
	
	/// <summary>
	/// UI members.
	/// </summary>
	this.mDivLoading = null;
	this.mTxtLoadingProgress = null;
	
	this.mFocalLengthSlider = null;
	this.mFocalLengthSliderTxt = null;
	
	this.mFocusDistanceSlider = null;
	this.mFocusDistanceSliderTxt = null;
	
	this.mFStopSlider = null;
	this.mFStopSliderTxt = null;
	
	this.mCboxViewState = null;
	
	this.mViewState = 0;
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
DepthOfFieldScene.prototype = new BaseScene();
DepthOfFieldScene.prototype.constructor = DepthOfFieldScene;


/// <summary>
/// Implementation.
/// </summary>
DepthOfFieldScene.prototype.Start = function ()
{
	// Setup members and default values
	this.mShader = new Array();
	this.mCanvas = document.getElementById("Canvas");
	this.mFboDimension = new Point(this.mCanvas.width, this.mCanvas.height);
	this.mFboDimensionBlur = new Point(512, 512);
	
	// Construct FBO for rendering the colour buffer
	var sampler = new SamplerState(SamplerState.LinearClamp);
	this.mFboColourColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboColourColourBuffer.TextureObject = new GLTexture2D();
	this.mFboColourColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	
	this.mFboColourDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboColourDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboColour = new GLFrameBufferObject();
	this.mFboColour.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboColour.AttachBuffer(this.mFboColourColourBuffer);
	this.mFboColour.AttachBuffer(this.mFboColourDepthBuffer);
	
	// Construct FBO for rendering the depth buffer
	this.mFboDepthColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboDepthColourBuffer.TextureObject = new GLTexture2D();
	this.mFboDepthColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	
	this.mFboDepthDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboDepthDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboDepth = new GLFrameBufferObject();
	this.mFboDepth.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboDepth.AttachBuffer(this.mFboDepthColourBuffer);
	this.mFboDepth.AttachBuffer(this.mFboDepthDepthBuffer);
	
	// Construct FBO for rendering the horizontal blur
	this.mFboBlurColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboBlurColourBuffer.TextureObject = new GLTexture2D();
	this.mFboBlurColourBuffer.TextureObject.Create(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y, Texture.Format.Rgba, sampler);
	
	this.mFboBlur = new GLFrameBufferObject();
	this.mFboBlur.Create(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y);
	this.mFboBlur.AttachBuffer(this.mFboBlurColourBuffer);
	
	// Construct FBO for rendering the vertical blur
	this.mFboBlur2ColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboBlur2ColourBuffer.TextureObject = new GLTexture2D();
	this.mFboBlur2ColourBuffer.TextureObject.Create(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y, Texture.Format.Rgba, sampler);
	
	this.mFboBlur2 = new GLFrameBufferObject();
	this.mFboBlur2.Create(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y);
	this.mFboBlur2.AttachBuffer(this.mFboBlur2ColourBuffer);

	// Construct the scene to be rendered
	this.mEntity = DepthOfFieldSceneGen.Create();
	
	// Construct the surface used to perform the blurring and viewing the post-processed result.
	// It will fit to the dimensions of the viewport.
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.Create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.ObjectEntity = rectVbo;
	this.mSurface.ObjectMatrix.Translate(0.0, 0.0, 1.0);
	this.mSurface.ObjectMaterial.Texture = new Array();
	this.mSurface.ObjectMaterial.Texture.push(null); // First texture = colour buffer, assigned later
	this.mSurface.ObjectMaterial.Texture.push(null); // Second texture = depth buffer, assigned later
	//this.mSurface.ObjectMaterial.Texture.push(null); // Third texture = blurred texture, assigned later

	// Prepare resources to download
	// The basic shader is responsible for rendering the scene with lights, colours, and textures
	this.mResource.Add(new ResourceItem("basic.vs", null, "./shaders/basic.vs"));
	this.mResource.Add(new ResourceItem("basic.fs", null, "./shaders/basic.fs"));
	
	// The depth shader is responsible for rendering the depth values to texture
	this.mResource.Add(new ResourceItem("depth.vs", null, "./shaders/depth.vs"));
	this.mResource.Add(new ResourceItem("depth.fs", null, "./shaders/depth.fs"));
	
	// The following are image or post-processing shaders used in the DOF process.
	// image.vs is shared by all fragment shaders here
	this.mResource.Add(new ResourceItem("image.vs", null, "./shaders/image.vs"));
	this.mResource.Add(new ResourceItem("depth_image.fs", null, "./shaders/depth_image.fs"));
	this.mResource.Add(new ResourceItem("dof_blur.fs", null, "./shaders/dof_blur.fs"));
	this.mResource.Add(new ResourceItem("dof_image.fs", null, "./shaders/dof_image.fs"));

	// Textures used in the scene
	this.mResource.Add(new ResourceItem("checker_board.png", null, "./images/checker_board.png"));
	this.mResource.Add(new ResourceItem("ruler.png", null, "./images/ruler.png"));
	
	// Setup user interface
	this.mDivLoading = $("#DivLoading");
	this.mTxtLoadingProgress = $("#TxtLoadingProgress");
	
	this.mFocalLengthSlider = $("#FocalLengthSlider");
	this.mFocalLengthSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		step: 1.0,
		min: 10.0,
		max: 200,
		value: 100
	});
	this.mFocalLengthSlider.on("slide", {owner : this}, this.OnFocalLengthValueChanged);
	this.mFocalLengthSlider.on("slidechange", {owner : this}, this.OnFocalLengthValueChanged);
	this.mFocalLengthSliderTxt = $("#FocalLengthSliderTxt");
	this.mFocalLengthSliderTxt.text(this.mFocalLengthSlider.slider("value"));
	
	this.mFocusDistanceSlider = $("#FocusDistanceSlider");
	this.mFocusDistanceSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		step: 0.1,
		min: 1.0,
		max: 20.0,
		value: 10.0
	});
	this.mFocusDistanceSlider.on("slide", {owner : this}, this.OnFocusDistanceValueChanged);
	this.mFocusDistanceSlider.on("slidechange", {owner : this}, this.OnFocusDistanceValueChanged);
	this.mFocusDistanceSliderTxt = $("#FocusDistanceSliderTxt");
	this.mFocusDistanceSliderTxt.text(this.mFocusDistanceSlider.slider("value"));
	
	this.mFStopSlider = $("#FStopSlider");
	this.mFStopSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		step: 0.1,
		min: 1.4,
		max: 16.0,
		value: 1.4
	});
	this.mFStopSlider.on("slide", {owner : this}, this.OnFStopValueChanged);
	this.mFStopSlider.on("slidechange", {owner : this}, this.OnFStopValueChanged);
	this.mFStopSliderTxt = $("#FStopSliderTxt");
	this.mFStopSliderTxt.text(this.mFStopSlider.slider("value"));

	this.mCboxViewState = document.getElementById("CboxViewState");
	this.mCboxViewState.selectedIndex = 0;
	this.mCboxViewState.onchange = this.OnViewStateValueChanged.bind(this);
	
	// Start downloading resources
	BaseScene.prototype.Start.call(this);
}


/// <summary>
/// Method called when the focal length slider has changed.
/// </summary>
DepthOfFieldScene.prototype.OnFocalLengthValueChanged = function (event, ui)
{
	event.data.owner.mDofBlurShader.FocalLength = ui.value;
	event.data.owner.mDofBlurShader.UpdateBlurCoefficient();
	
	event.data.owner.mDofImageShader.FocalLength = ui.value;
	event.data.owner.mDofImageShader.UpdateBlurCoefficient();
	
	event.data.owner.mFocalLengthSliderTxt.text(ui.value);
}


/// <summary>
/// Method called when the focus distance slider has changed.
/// </summary>
DepthOfFieldScene.prototype.OnFocusDistanceValueChanged = function (event, ui)
{
	event.data.owner.mDofBlurShader.FocusDistance = ui.value;
	event.data.owner.mDofBlurShader.UpdateBlurCoefficient();
	
	event.data.owner.mDofImageShader.FocusDistance = ui.value;
	event.data.owner.mDofImageShader.UpdateBlurCoefficient();
	
	event.data.owner.mFocusDistanceSliderTxt.text(ui.value);
}


/// <summary>
/// Method called when the f-stop slider has changed.
/// </summary>
DepthOfFieldScene.prototype.OnFStopValueChanged = function (event, ui)
{
	event.data.owner.mDofBlurShader.FStop = ui.value;
	event.data.owner.mDofBlurShader.UpdateBlurCoefficient();
	
	event.data.owner.mDofImageShader.FStop = ui.value;
	event.data.owner.mDofImageShader.UpdateBlurCoefficient();
	
	event.data.owner.mFStopSliderTxt.text(ui.value);
}


/// <summary>
/// Method called when the view state combo box value has changed.
/// </summary>
DepthOfFieldScene.prototype.OnViewStateValueChanged = function (event)
{
	this.mViewState = this.mCboxViewState.selectedIndex;
}


/// <summary>
/// Implementation.
/// </summary>
DepthOfFieldScene.prototype.Update = function ()
{
	BaseScene.prototype.Update.call(this);
	
	// Draw only when all resources have been loaded
	if ( this.mLoadComplete )
	{
		//
		// Step 1: Render the scene as normal to texture
		//	
		this.mBasicShader.Enable();
			this.mFboColour.Enable();
				gl.viewport(0, 0, this.mFboColour.GetFrameWidth(), this.mFboColour.GetFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
					
				for (var i = 0; i < this.mEntity.length; ++i)
					this.mBasicShader.Draw(this.mEntity[i]);
			this.mFboColour.Disable();
		this.mBasicShader.Disable();
	
	
		//
		// Step 2: Render the scene's depth values to texture
		//	
		this.mDepthShader.Enable();
			this.mFboDepth.Enable();
				gl.viewport(0, 0, this.mFboDepth.GetFrameWidth(), this.mFboDepth.GetFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
					
				for (var i = 0; i < this.mEntity.length; ++i)
					this.mDepthShader.Draw(this.mEntity[i]);
			this.mFboDepth.Disable();
		this.mDepthShader.Disable();
		
		
		//
		// Step 3: DOF blur the colour in the horizontal and vertical axis using the
		// colour and depth textures prepared in step 1 and 2.
		//
		this.mDofBlurShader.Enable();
			gl.viewport(0, 0, this.mFboBlur.GetFrameWidth(), this.mFboBlur.GetFrameHeight());
		
			// Render horizontal blur
			this.mFboBlur.Enable();
				this.mSurface.ObjectMaterial.Texture[0] = this.mFboColourColourBuffer.TextureObject;
				this.mSurface.ObjectMaterial.Texture[1] = this.mFboDepthColourBuffer.TextureObject;
				
				this.mDofBlurShader.Draw(this.mSurface, 0);
		
			// Render vertical blur 
			this.mFboBlur2.Enable();
				gl.clear(gl.DEPTH_BUFFER_BIT);
				
				this.mSurface.ObjectMaterial.Texture[0] = this.mFboBlurColourBuffer.TextureObject;
				this.mDofBlurShader.Draw(this.mSurface, 1);
			this.mFboBlur2.Disable();
		this.mDofBlurShader.Disable();
		
		
		// Restore viewport
		gl.viewport(0, 0, this.mCanvas.width, this.mCanvas.height);
		
		
		//
		// Step 4: Render the final result to screen.
		//
		if ( this.mViewState == 0 )
		{
			// Post-process final image
			this.mDofImageShader.Enable();
				this.mSurface.ObjectMaterial.Texture[0] = this.mFboColourColourBuffer.TextureObject;
				this.mSurface.ObjectMaterial.Texture[2] = this.mFboBlur2ColourBuffer.TextureObject;
				this.mDofImageShader.Draw(this.mSurface);
			this.mDofImageShader.Disable();
		}
		else
		{
			// Visualize depth map
			this.mDepthImageShader.Enable();
				this.mSurface.ObjectMaterial.Texture[0] = this.mFboDepthColourBuffer.TextureObject;
				this.mDepthImageShader.Draw(this.mSurface);
			this.mDepthImageShader.Disable();
		}
	}
}


/// <summary>
/// Implementation.
/// </summary>
DepthOfFieldScene.prototype.End = function ()
{
	BaseScene.prototype.End.call(this);

	// Cleanup
	if ( this.mFboColour != null )
		this.mFboColour.Release();
	
	if ( this.mFboColourColourBuffer != null )
		this.mFboColourColourBuffer.TextureObject.Release();
		
	if ( this.mFboDepth != null )
		this.mFboDepth.Release();
		
	if ( this.mFboDepthColourBuffer != null )
		this.mFboDepthColourBuffer.TextureObject.Release();
		
	if ( this.mFboBlur != null )
		this.mFboBlur.Release();
	
	if ( this.mFboBlurColourBuffer != null )
		this.mFboBlurColourBuffer.TextureObject.Release();
	
	if ( this.mSurface != null )
		this.mSurface.ObjectEntity.Release();
		
	if ( this.mBasicShader )
		this.mBasicShader.Release();
		
	if ( this.mDepthShader )
		this.mDepthShader.Release();
		
	if ( this.mDofBlurShader )
		this.mDofBlurShader.Release();
	
	if ( this.mDofImageShader )
		this.mDofImageShader.Release();
	
	if ( this.mDepthImageShader )
		this.mDepthImageShader.Release();
		
	if ( this.mTexCheckerBoard )
		this.mTexCheckerBoard.Release();
		
	if ( this.mTexRuler )
		this.mTexRuler.Release();
}


/// <summary>
/// This method is called when an item for the scene has downloaded. it
/// will increment the resource counter and dispatch an OnLoadComplete
/// event once all items have been downloaded.
/// </summary>
DepthOfFieldScene.prototype.OnItemLoaded = function (sender, response)
{
	BaseScene.prototype.OnItemLoaded.call(this, sender, response);
	
	if ( this.mTxtLoadingProgress != null )
		this.mTxtLoadingProgress.html(Math.floor((this.mResourceCount / (this.mResource.Item.length * 2.0 + 6.0)) * 100.0));
}


/// <summary>
/// This method is called to compile a bunch of shaders. The browser will be
/// blocked while the GPU compiles, so we need to give the browser a chance
/// to refresh its view and take user input while this happens (good ui practice).
/// </summary>
DepthOfFieldScene.prototype.CompileShaders = function (index, list)
{
	var shaderItem = list[index];
	if ( shaderItem != null )
	{
		// Compile vertex shader
		var shader = new GLShader();
		if ( !shader.Create((shaderItem.Name.lastIndexOf(".vs") != -1) ? shader.ShaderType.Vertex : shader.ShaderType.Fragment, shaderItem.Item) )
		{
			// Report error
			var log = shader.GetLog();
			alert("Error compiling " + shaderItem.Name + ".\n\n" + log);
			return;
		}
		else
			this.mShader.push(shader);	
	}
	else
	{
		// Resources missing?
		alert("Missing resources");
		return;
	}
	
	// Update loading progress
	++index;
	if ( this.mTxtLoadingProgress != null )
		this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount + index) / (this.mResource.Item.length * 2.0 + 4.0)) * 100.0));

	if ( index < list.length )
	{
		// Move on to next shader
		var parent = this;
		setTimeout(function () { parent.CompileShaders(index, list) }, 1);
	}
	else if ( index == list.length )
	{
		// Now start loading in the shaders
		this.LoadShaders(0);
	}
}


/// <summary>
/// This method is called to load a bunch of shaders. The browser will be
/// blocked while the GPU loads, so we need to give the browser a chance
/// to refresh its view and take user input while this happens (good ui practice).
/// </summary>
DepthOfFieldScene.prototype.LoadShaders = function (index)
{
	if ( index == 0 )
	{
		// Create basic shader program
		this.mBasicShader = new BasicShader();
		this.mBasicShader.Projection = this.mProjectionMatrix;
		this.mBasicShader.View = this.mInvViewMatrix;
		this.mBasicShader.Create();
		this.mBasicShader.AddShader(this.mShader[0]);
		this.mBasicShader.AddShader(this.mShader[1]);
		this.mBasicShader.Link();
		this.mBasicShader.Init();
		
		// Add light sources
		var light1 = new Light();
		light1.LightType = Light.LightSourceType.Point;
		light1.Position = new Point(-4.0, 0.0, -4.0);
		light1.Attenuation.z = 0.02;
		this.mBasicShader.LightObject.push(light1);
		
		var light2 = new Light();
		light2.LightType = Light.LightSourceType.Point;
		light2.Position = new Point(4.0, 0.0, 4.0);
		light2.Attenuation.z = 0.02;
		this.mBasicShader.LightObject.push(light2);
	}
	else if ( index == 1 )
	{
		// Create depth map shader program
		this.mDepthShader = new DepthShader();
		this.mDepthShader.Projection = this.mProjectionMatrix;
		this.mDepthShader.View = this.mInvViewMatrix;
		this.mDepthShader.Create();
		this.mDepthShader.AddShader(this.mShader[2]);
		this.mDepthShader.AddShader(this.mShader[3]);
		this.mDepthShader.Link();
		this.mDepthShader.Init();
		this.mDepthShader.Near = 1.0;
		this.mDepthShader.Far = 25.0;
	}
	else if ( index == 2 )
	{
		// Create depth image shader program
		this.mDepthImageShader = new ImageShader();
		this.mDepthImageShader.Projection = this.mOrthographicMatrix;
		this.mDepthImageShader.View = new Matrix(4, 4);
		this.mDepthImageShader.Create();
		this.mDepthImageShader.AddShader(this.mShader[4]);
		this.mDepthImageShader.AddShader(this.mShader[5]);
		this.mDepthImageShader.Link();
		this.mDepthImageShader.Init();
		this.mDepthImageShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
	}
	else if ( index == 3 )
	{
		// Create DOF blur shader program
		this.mDofBlurShader = new DofBlurShader();
		this.mDofBlurShader.Projection = this.mOrthographicMatrix;
		this.mDofBlurShader.View = new Matrix(4, 4);
		this.mDofBlurShader.Create();
		this.mDofBlurShader.AddShader(this.mShader[4]);
		this.mDofBlurShader.AddShader(this.mShader[6]);
		this.mDofBlurShader.Link();
		this.mDofBlurShader.Init();
		this.mDofBlurShader.SetSize(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y);

		this.mDofBlurShader.Near = 1.0;
		this.mDofBlurShader.Far = 25.0;
		this.mDofBlurShader.FocalLength = this.mFocalLengthSlider.slider("value");
		this.mDofBlurShader.FocusDistance = this.mFocusDistanceSlider.slider("value");
		this.mDofBlurShader.FStop = this.mFStopSlider.slider("value");
		this.mDofBlurShader.UpdateBlurCoefficient();
	}
	else if ( index == 4 )
	{
		// Create DOF image shader program
		this.mDofImageShader = new DofImageShader();
		this.mDofImageShader.Projection = this.mOrthographicMatrix;
		this.mDofImageShader.View = new Matrix(4, 4);
		this.mDofImageShader.Create();
		this.mDofImageShader.AddShader(this.mShader[4]);
		this.mDofImageShader.AddShader(this.mShader[7]);
		this.mDofImageShader.Link();
		this.mDofImageShader.Init();
		this.mDofImageShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
		
		this.mDofImageShader.Near = this.mDofBlurShader.Near;
		this.mDofImageShader.Far = this.mDofBlurShader.Far;
		this.mDofImageShader.FocalLength = this.mDofBlurShader.FocalLength;
		this.mDofImageShader.FocusDistance = this.mDofBlurShader.FocusDistance;
		this.mDofImageShader.FStop = this.mDofBlurShader.FStop;
		this.mDofImageShader.UpdateBlurCoefficient();
		
		// Hide loading screen
		if ( this.mDivLoading != null )
			this.mDivLoading.hide();
		
		this.mLoadComplete = true;
	}
	
	if ( index < 4 )
	{
		// Update loading progress
		++index;
		if ( this.mTxtLoadingProgress != null )
			this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount * 2.0 + index) / (this.mResource.Item.length * 2.0 + 4.0)) * 100.0));
	
		// Move on
		var parent = this;
		setTimeout(function () { parent.LoadShaders(index) }, 1);
	}
}


/// <summary>
/// Implementation.
/// </summary>
DepthOfFieldScene.prototype.OnLoadComplete = function ()
{
	// Process shaders
	var shaderResource = new Array();
	shaderResource.push(this.mResource.Find("basic.vs"));
	shaderResource.push(this.mResource.Find("basic.fs"));
	shaderResource.push(this.mResource.Find("depth.vs"));
	shaderResource.push(this.mResource.Find("depth.fs"));
	shaderResource.push(this.mResource.Find("image.vs"));
	shaderResource.push(this.mResource.Find("depth_image.fs"));
	shaderResource.push(this.mResource.Find("dof_blur.fs"));
	shaderResource.push(this.mResource.Find("dof_image.fs"));
	
	// Process textures
	var sampler = new SamplerState(SamplerState.LinearClamp);
	sampler.HasMipMap = true;
	var imgCheckerBoard = this.mResource.Find("checker_board.png");
	if ( imgCheckerBoard != null )
	{
		this.mTexCheckerBoard = new GLTexture2D();
		this.mTexCheckerBoard.Create(imgCheckerBoard.Item.width, imgCheckerBoard.Item.height, Texture.Format.Alpha8, sampler, imgCheckerBoard.Item);
		
		this.mEntity[1].ObjectMaterial.Texture = new Array();
		this.mEntity[1].ObjectMaterial.Texture.push(this.mTexCheckerBoard);
	}
	
	var imgRuler = this.mResource.Find("ruler.png");
	if ( imgRuler != null )
	{
		this.mTexRuler = new GLTexture2D();
		this.mTexRuler.Create(imgRuler.Item.width, imgRuler.Item.height, Texture.Format.Alpha8, sampler, imgRuler.Item);
		
		this.mEntity[0].ObjectMaterial.Texture = new Array();
		this.mEntity[0].ObjectMaterial.Texture.push(this.mTexRuler);
	}
	
	// Setup camera matrices
	this.mProjectionMatrix = ViewMatrix.Perspective(60.0, 1.333, 1.0, 30.0);
	this.mViewMatrix.PointAt(new Point(0.0, -1.0, 9.9),
							 new Point());
	this.mInvViewMatrix = this.mViewMatrix.Inverse();
	
	// Compile shaders
	this.CompileShaders(0, shaderResource);
}