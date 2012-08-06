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
/// This scene demonstrates the screen space ambient occlusion algorithm (SSAO). The algorithm
/// is divided into several steps.
///
/// 1. Render the scene with normal transform and lighting to a colour buffer (texture).
///
/// 2. Render the geometry's 3d view-space positions to an RGBA floating point buffer.
///	   The alpha channel will include the linear depth value, which is used to determine the
///	   sampling radius in the SSAO shader.
///
/// 3. Render the geometry's 3d view-space normal vectors to an RGB floating point buffer.
///	   Since WebGL (or OpenGL ES 2.0) does not support multiple colour attachments to an FBO,
///	   this process must require another render pass.
///
/// 4. Pass the position buffer, normal buffer, and normalmap texture to the SSAO shader.
///	   The result is stored into a floating point luminance texture.
///
/// 5. Subtract the AO map from the colour buffer to produce the final image.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function SSAOScene ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	BaseScene.call(this);
	
	
	/// <summary>
	/// This framebuffer object stores the rendered scene to an RGB texture. It will be
	/// blended with the AO map calculated later.
	/// </summary>
	this.mFboColour = null;
	this.mFboColourColourBuffer = null;
	this.mFboColourDepthBuffer = null;
	
	
	/// <summary>
	/// This framebuffer object stores the view space position (vertices) to texture.
	/// It uses an RGBA floating point texture to store the results. The alpha channel
	/// stores the linear depth values, which is used to compute the AO sampling radius.
	/// </summary>
	this.mFboDeferredPosition = null;
	this.mFboDeferredPositionColourBuffer = null;
	this.mFboDeferredPositionDepthBuffer = null;
	
	
	/// <summary>
	/// This framebuffer object stores the view space normal vectors to texture.
	/// It uses an RGB floating point texture to store the results.
	/// </summary>
	this.mFboDeferredNormals = null;
	this.mFboDeferredNormalsColourBuffer = null;
	this.mFboDeferredNormalsDepthBuffer = null;
	
	
	/// <summary>
	/// This framebuffer object stores the calculated ambient occlusion values.
	/// It uses a luminance floating point texture to store the results.
	/// </summary>
	this.mFboSSAO = null;
	this.mFboSSAOColourBuffer = null;
	
	
	/// <summary>
	/// Gets or sets the dimensions of the FBO, which may or may not be the same size
	/// as the window.
	/// </summary>
	this.mFboDimension = null;
	
	
	/// <summary>
	/// The basic shader renders the scene using standard transform and lighting.
	/// </summary>
	this.mBasicShader = null;
	
	
	/// <summary>
	/// The deferred shader output's geometry data to a floating point texture for
	/// later processing.
	/// </summary>
	this.mDeferredPositionShader = null;
	this.mDeferredNormalsShader = null;
	
	
	/// <summary>
	/// Shader for calculating the ambient occlusion values.
	/// </summary>
	this.mSSAOShader = null;
	
	
	/// <summary>
	/// Shader for blending and rendering the scene and AO map textures.
	/// </summary>
	this.mSSAOBlendShader = null;
	
	
	/// <summary>
	/// Shader for correcting the brightness, contrast, and gamma prior to output.
	/// </summary>
	this.mBrightnessShader = null;
	
	
	/// <summary>
	/// Surface (rectangle) to perform post-processing effects.
	/// It is designed to fit the size of the viewport.
	/// </summary>
	this.mSurface = null;
	
	
	/// <summary>
	/// Stores the textures used by this scene.
	/// </summary>
	this.mTexture = new Array();
	
	
	/// <summary>
	/// Stores a reference to the canvas DOM element, which is used to reset the viewport
	/// back to its original size after rendering to the FBO, which uses a different
	/// dimension.
	/// </summary>
	this.mCanvas = null;
	
	
	/// <summary>
	/// Gets or sets whether SSAO is rendered or not.
	/// </summary>
	this.mEnableSSAO = true;
	
	
	/// <summary>
	/// Mouse controls for camera position and zoom.
	/// </summary>
	this.mMouseDown = false;
	this.mMouseStartPos = new Point();
	this.mCameraRot = 0.0;
	this.mCameraZoom = 3.9;
	this.mCameraHeight = 2.0;
	this.mCameraStartRot = 0.0;
	this.mCameraStartZoom = 0.0;
	this.mCameraTargetPos = new Point(0.0, 0.4, 0.0);
	
	
	/// <summary>
	/// UI members.
	/// </summary>
	this.mDivLoading = null;
	this.mTxtLoadingProgress = null;
	this.mControls = null;
	this.mBtnEnableSSAO = null;

	this.mNumResources = 0;
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
SSAOScene.prototype = new BaseScene();
SSAOScene.prototype.constructor = SSAOScene;


/// <summary>
/// Called when the mouse button is pressed.
/// </summary>
SSAOScene.prototype.OnMouseDown = function (key)
{
	// Record the current mouse position
	var owner = this.Owner;
	owner.mMouseDown = true;
	owner.mMouseStartPos.x = key.pageX - this.offsetLeft;
	owner.mMouseStartPos.y = key.pageY - this.offsetTop;
	owner.mCameraStartRot = owner.mCameraRot;
	owner.mCameraStartZoom = owner.mCameraZoom;
}


/// <summary>
/// Called when there is mouse movement. Apply rotation and zoom
/// only when the mouse button is held down.
/// </summary>
SSAOScene.prototype.OnMouseMove = function (key)
{
	// Process mouse movement only when the mouse button is held down
	var owner = this.Owner;
	if ( owner.mMouseDown )
	{
		// Rotate and zoom camera about centre
		// Calculate delta position
		var x = (owner.mMouseStartPos.x - (key.pageX - this.offsetLeft)) * 0.01;
		var y = (owner.mMouseStartPos.y - (key.pageY - this.offsetTop)) * 0.07;
		
		owner.mCameraRot = owner.mCameraStartRot + x;
		owner.mCameraZoom = owner.mCameraStartZoom + y;
		
		// Impose limits on zoom
		if ( owner.mCameraZoom < 2.0 )
			owner.mCameraZoom = 2.0;
		else if ( owner.mCameraZoom > 3.9 )
			owner.mCameraZoom = 3.9;
		
		owner.mViewMatrix.PointAt(new Point(Math.sin(owner.mCameraRot) * owner.mCameraZoom, owner.mCameraHeight, Math.cos(owner.mCameraRot) * owner.mCameraZoom),
								  owner.mCameraTargetPos);
		owner.mInvViewMatrix = owner.mViewMatrix.Inverse();
		
		owner.mBasicShader.View = owner.mInvViewMatrix;
		owner.mDeferredPositionShader.View = owner.mInvViewMatrix;
		owner.mDeferredNormalsShader.View = owner.mInvViewMatrix;
	}
}


/// <summary>
/// Called when the mouse button is released.
/// </summary>
SSAOScene.prototype.OnMouseUp = function (key)
{
	var owner = this.Owner;
	owner.mMouseDown = false;
}


/// <summary>
/// Implementation.
/// </summary>
SSAOScene.prototype.Start = function ()
{
	// Setup members and default values
	this.mShader = new Array();
	this.mCanvas = document.getElementById("Canvas");
	
	// Specify the FBO dimensions
	this.mFboDimension = new Point(this.mCanvas.width, this.mCanvas.height);
	
	
	// Construct FBO for rendering the scene to an RGB texture
	this.mFboColourColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboColourColourBuffer.TextureObject = new GLTexture2D();
	this.mFboColourColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgb, SamplerState.LinearClamp);
	
	this.mFboColourDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboColourDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboColour = new GLFrameBufferObject();
	this.mFboColour.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboColour.AttachBuffer(this.mFboColourColourBuffer);
	this.mFboColour.AttachBuffer(this.mFboColourDepthBuffer);
	
	
	// Construct FBO for rendering the view space positions for ambient occlusion calculations
	this.mFboDeferredPositionColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboDeferredPositionColourBuffer.TextureObject = new GLTexture2D();
	this.mFboDeferredPositionColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Vector4, SamplerState.PointClamp);
	
	this.mFboDeferredPositionDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboDeferredPositionDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboDeferredPosition = new GLFrameBufferObject();
	this.mFboDeferredPosition.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboDeferredPosition.AttachBuffer(this.mFboDeferredPositionColourBuffer);
	this.mFboDeferredPosition.AttachBuffer(this.mFboDeferredPositionDepthBuffer);
	
	
	// Construct FBO for rendering the view space normals for ambient occlusion calculations
	this.mFboDeferredNormalsColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboDeferredNormalsColourBuffer.TextureObject = new GLTexture2D();
	this.mFboDeferredNormalsColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Vector3, SamplerState.PointClamp);
	
	this.mFboDeferredNormalsDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboDeferredNormalsDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboDeferredNormals = new GLFrameBufferObject();
	this.mFboDeferredNormals.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboDeferredNormals.AttachBuffer(this.mFboDeferredNormalsColourBuffer);
	this.mFboDeferredNormals.AttachBuffer(this.mFboDeferredNormalsDepthBuffer);
	
	
	// Construct FBO for rendering the SSAO values
	// Floating point luminance textures don't appear to work on AMD driver 12.6, so falling back to (wasteful)
	// RGB space.
	this.mFboSSAOColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboSSAOColourBuffer.TextureObject = new GLTexture2D();
	this.mFboSSAOColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Vector3/*Single*/, SamplerState.LinearClamp);
	
	this.mFboSSAO = new GLFrameBufferObject();
	this.mFboSSAO.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboSSAO.AttachBuffer(this.mFboSSAOColourBuffer);
	
	
	// Construct the surface used to for post-processing images
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.Create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.ObjectEntity = rectVbo;
	this.mSurface.ObjectMatrix = new Matrix(4, 4);
	this.mSurface.ObjectMaterial.Texture = new Array();
	this.mSurface.ObjectMaterial.Texture.push(null);	// SSAO view space position data
	this.mSurface.ObjectMaterial.Texture.push(null);	// SSAO view space normal vectors data
	this.mSurface.ObjectMaterial.Texture.push(null);	// SSAO normalmap / randomizer
	
	
	// Construct the scene to be rendered
	this.mEntity = SSAOSceneGen.Create();

	
	// Prepare resources to download
	
	// Basic transform and lighting shader
	this.mResource.Add(new ResourceItem("basic.vs", null, "./shaders/basic.vs"));
	this.mResource.Add(new ResourceItem("basic.fs", null, "./shaders/basic.fs"));
	
	// Deferred rendering shaders
	this.mResource.Add(new ResourceItem("deferred.vs", null, "./shaders/deferred.vs"));
	this.mResource.Add(new ResourceItem("deferred_position.fs", null, "./shaders/deferred_position.fs"));
	this.mResource.Add(new ResourceItem("deferred_normals.fs", null, "./shaders/deferred_normals.fs"));
	
	// Post-processing shaders
	this.mResource.Add(new ResourceItem("image.vs", null, "./shaders/image.vs"));
	this.mResource.Add(new ResourceItem("ssao.fs", null, "./shaders/ssao.fs"));
	this.mResource.Add(new ResourceItem("ssao_blend.fs", null, "./shaders/ssao_blend.fs"));
	this.mResource.Add(new ResourceItem("brightness.fs", null, "./shaders/brightness.fs"));
	
	
	// Textures used in the scene
	this.mResource.Add(new ResourceItem("normalmap.png", null, "./images/normalmap.png"));
	
	// Number of resource to load (including time taken to compile and load shader programs)
	// 9 shaders to compile
	// 5 shader programs to load
	this.mNumResources = this.mResource.Item.length + 9 + 5;
	
	
	// Listen for mouse activity
	this.mCanvas.Owner = this;
	this.mCanvas.onmousedown = this.OnMouseDown;
	this.mCanvas.onmouseup = this.OnMouseUp;
	this.mCanvas.onmousemove = this.OnMouseMove;
	
	
	// Setup user interface
	this.mDivLoading = $("#DivLoading");
	this.mTxtLoadingProgress = $("#TxtLoadingProgress");
	
	// Sliders
	// Array format: DOM ID, Step, Min, Max, Initial Value, Callback Function
	var sliders =
	[
		["#OccluderBiasSlider", 0.01, 0.0, 0.2, 0.05, this.OnOccluderBiasValueChanged],
		["#SamplingRadiusSlider", 1.0, 0.0, 40.0, 20.0, this.OnSamplingRadiusValueChanged],
		["#AttConstantSlider", 0.1, 0.0, 2.0, 1.0, this.OnConstantAttenuationValueChanged],
		["#AttLinearSlider", 0.1, 0.0, 10.0, 5.0, this.OnLinearAttenuationValueChanged]
	];
	
	this.mControls = new Array();
	for (var i = 0; i < sliders.length; ++i)
	{
		var item = sliders[i];
	
		var slider = $(item[0]);
		slider.slider(
		{
			animate: true,
			orientation: "horizontal",
			step: item[1],
			min: item[2],
			max: item[3],
			value: item[4]
		});
		slider.on("slide", {owner : this}, item[5]);
		slider.on("slidechange", {owner : this}, item[5]);
		var sliderTxt = $(item[0] + "Txt");
		sliderTxt.text(slider.slider("value"));
		
		this.mControls.push(slider);
		this.mControls.push(sliderTxt);
	}
	
	// View options
	this.mBtnEnableSSAO = $("#BtnEnableSSAO");
	this.mBtnEnableSSAO.on("change", this, this.OnEnableSSAOClicked);
	
	
	// Start downloading resources
	BaseScene.prototype.Start.call(this);
}


/// <summary>
/// Method called when the occluder bias slider has changed.
/// </summary>
SSAOScene.prototype.OnOccluderBiasValueChanged = function (event, ui)
{
	event.data.owner.mSSAOShader.OccluderBias = ui.value;
	event.data.owner.mControls[1].text(ui.value);
}


/// <summary>
/// Method called when the sampling radius slider has changed.
/// </summary>
SSAOScene.prototype.OnSamplingRadiusValueChanged = function (event, ui)
{
	event.data.owner.mSSAOShader.SamplingRadius = ui.value;
	event.data.owner.mControls[3].text(ui.value);
}


/// <summary>
/// Method called when the constant attenuation slider has changed.
/// </summary>
SSAOScene.prototype.OnConstantAttenuationValueChanged = function (event, ui)
{
	event.data.owner.mSSAOShader.Attenuation.x = ui.value;
	event.data.owner.mControls[5].text(ui.value);
}


/// <summary>
/// Method called when the linear attenuation slider has changed.
/// </summary>
SSAOScene.prototype.OnLinearAttenuationValueChanged = function (event, ui)
{
	event.data.owner.mSSAOShader.Attenuation.y = ui.value;
	event.data.owner.mControls[7].text(ui.value);
}


/// <summary>
/// Method called when the view mode combo box has changed.
/// </summary>
SSAOScene.prototype.OnEnableSSAOClicked = function (event)
{
	event.data.mEnableSSAO = event.currentTarget.checked;
}


/// <summary>
/// Implementation.
/// </summary>
SSAOScene.prototype.Update = function ()
{
	BaseScene.prototype.Update.call(this);
	
	// Draw only when all resources have been loaded
	if ( this.mLoadComplete )
	{
		//
		// Step 1: Render the scene to texture using a standard T&L shader
		//
		this.mBasicShader.Enable();
			this.mFboColour.Enable();
				// Set and clear viewport
				gl.viewport(0, 0, this.mFboColour.GetFrameWidth(), this.mFboColour.GetFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
				
				// Render
				for (var i = 0; i < this.mEntity.length; ++i)
					this.mBasicShader.Draw(this.mEntity[i]);
			this.mFboColour.Disable();
		this.mBasicShader.Disable();
		
		
		//
		// Step 2: Render the scene's view space positions (vertices) to texture
		//
		this.mDeferredPositionShader.Enable();
			this.mFboDeferredPosition.Enable();
				// Set and clear viewport
				gl.viewport(0, 0, this.mFboDeferredPosition.GetFrameWidth(), this.mFboDeferredPosition.GetFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
				
				// Render
				for (var i = 0; i < this.mEntity.length; ++i)
					this.mDeferredPositionShader.Draw(this.mEntity[i]);
			this.mFboDeferredPosition.Disable();
		this.mDeferredPositionShader.Disable();
		
		
		//
		// Step 3: Render the scene's view space normal vectors to texture.
		//		   Normally this would be done in a single pass with the positional data rendered in
		//		   step 2; however WebGL / OpenGL ES 2.0 only supports one colour attachment to the FBO,
		//		   so we need to do it in another pass.
		//
		this.mDeferredNormalsShader.Enable();
			this.mFboDeferredNormals.Enable();
				// Set and clear viewport
				gl.viewport(0, 0, this.mFboDeferredNormals.GetFrameWidth(), this.mFboDeferredNormals.GetFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
				
				// Render
				for (var i = 0; i < this.mEntity.length; ++i)
					this.mDeferredNormalsShader.Draw(this.mEntity[i]);
			this.mFboDeferredNormals.Disable();
		this.mDeferredNormalsShader.Disable();
		
		
		//
		// Step 4: Calculate the ambient occlusion values.
		//
		this.mSSAOShader.Enable();
			this.mFboSSAO.Enable();
				// Set textures
				this.mSurface.ObjectMaterial.Texture[0] = this.mFboDeferredPositionColourBuffer.TextureObject;	// From step 2
				this.mSurface.ObjectMaterial.Texture[1] = this.mFboDeferredNormalsColourBuffer.TextureObject;	// From step 3
				this.mSurface.ObjectMaterial.Texture[2] = this.mTexture[0];										// normalmap.png
				
				// Render
				this.mSSAOShader.Draw(this.mSurface);
			this.mFboSSAO.Disable();
		this.mSSAOShader.Disable();
				
		
		// Restore viewport
		gl.viewport(0, 0, this.mCanvas.width, this.mCanvas.height);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		
		if ( this.mEnableSSAO )
		{
			//
			// Step 5: Blend the ambient occlusion map with the rendered scene and apply and final post-processing
			//		   operations.
			//
			this.mSSAOBlendShader.Enable();
				// Set textures
				this.mSurface.ObjectMaterial.Texture[0] = this.mFboColourColourBuffer.TextureObject;
				this.mSurface.ObjectMaterial.Texture[1] = this.mFboSSAOColourBuffer.TextureObject;
				
				// Render
				this.mSSAOBlendShader.Draw(this.mSurface);
			this.mSSAOBlendShader.Disable();
		}
		else
		{
			//
			// SSAO disabled, just show normal scene with gamma correction
			//
			this.mBrightnessShader.Enable();
				// Set textures
				this.mSurface.ObjectMaterial.Texture[0] = this.mFboColourColourBuffer.TextureObject;
				
				// Render
				this.mBrightnessShader.Draw(this.mSurface);
			this.mBrightnessShader.Disable();
		}
	}
}


/// <summary>
/// Implementation.
/// </summary>
SSAOScene.prototype.End = function ()
{
	BaseScene.prototype.End.call(this);

	// Cleanup
	
	// Release FBOs
	if ( this.mFboColour != null )
	{
		this.mFboColour.Release();
		this.mFboColourColourBuffer.TextureObject.Release();
	}
	
	if ( this.mFboDeferredPosition != null )
	{
		this.mFboDeferredPosition.Release();
		this.mFboDeferredPositionColourBuffer.TextureObject.Release();
	}
	
	if ( this.mFboDeferredNormals != null )
	{
		this.mFboDeferredNormals.Release();
		this.mFboDeferredNormalsColourBuffer.TextureObject.Release();
	}
	
	if ( this.mFboSSAO != null )
	{
		this.mFboSSAO.Release();
		this.mFboSSAOColourBuffer.TextureObject.Release();
	}
	
	// Release VBOs
	if ( this.mSurface != null )
		this.mSurface.ObjectEntity.Release();
		
	// Release textures
	if ( this.mTexture != null )
	{
		for (var i = 0; i < this.mTexture.length; ++i)
			this.mTexture[i].Release();
	}
	
	// Release controls
	this.mDivLoading = null;
	this.mTxtLoadingProgress = null;
	this.mControls = null;
	this.mBtnEnableSSAO = null;
}


/// <summary>
/// This method will update the displayed loading progress.
/// </summary>
/// <param name="increment">
/// Set to true to increment the resource counter by one. Normally hanadled by BaseScene.
/// </param>
SSAOScene.prototype.UpdateProgress = function (increment)
{
	if ( increment != null )
		++this.mResourceCount;
		
	if ( this.mTxtLoadingProgress != null )
		this.mTxtLoadingProgress.html(((this.mResourceCount / this.mNumResources) * 100.0).toFixed(2));
}


/// <summary>
/// Implementation.
/// </summary>
SSAOScene.prototype.OnItemLoaded = function (sender, response)
{
	BaseScene.prototype.OnItemLoaded.call(this, sender, response);
	this.UpdateProgress();
}


/// <summary>
/// This method is called to compile a bunch of shaders. The browser will be
/// blocked while the GPU compiles, so we need to give the browser a chance
/// to refresh its view and take user input while this happens (good ui practice).
/// </summary>
SSAOScene.prototype.CompileShaders = function (index, list)
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
	this.UpdateProgress(true);

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
SSAOScene.prototype.LoadShaders = function (index, blendModes)
{
	if ( index == 0 )
	{
		// Create basic T&L program
		this.mBasicShader = new BasicShader();
		this.mBasicShader.Projection = this.mProjectionMatrix;
		this.mBasicShader.View = this.mInvViewMatrix;
		this.mBasicShader.Create();
		this.mBasicShader.AddShader(this.mShader[0]);	// basic.vs
		this.mBasicShader.AddShader(this.mShader[1]);	// basic.fs
		this.mBasicShader.Link();
		this.mBasicShader.Init();
		
		// Add light sources
		var light1 = new Light();
		light1.LightType = Light.LightSourceType.Point;
		light1.Position = new Point(0.0, 4.0, 0.0);
		this.mBasicShader.LightObject.push(light1);
		
		this.mShader.push(this.mBasicShader);
	}
	else if ( index == 1 )
	{
		// Create deferred position shader program
		this.mDeferredPositionShader = new DeferredShader();
		this.mDeferredPositionShader.Projection = this.mProjectionMatrix;
		this.mDeferredPositionShader.View = this.mInvViewMatrix;
		this.mDeferredPositionShader.Create();
		this.mDeferredPositionShader.AddShader(this.mShader[2]);	// deferred.vs
		this.mDeferredPositionShader.AddShader(this.mShader[3]);	// deferred_position.fs
		this.mDeferredPositionShader.Link();
		this.mDeferredPositionShader.Init();
		
		// Setup parameters
		this.mDeferredPositionShader.LinearDepth = 20.0 - 0.1;
		
		this.mShader.push(this.mDeferredPositionShader);
	}
	else if ( index == 2 )
	{
		// Create deferred normals program
		this.mDeferredNormalsShader = new DeferredShader();
		this.mDeferredNormalsShader.Projection = this.mProjectionMatrix;
		this.mDeferredNormalsShader.View = this.mInvViewMatrix;
		this.mDeferredNormalsShader.Create();
		this.mDeferredNormalsShader.AddShader(this.mShader[2]);	// deferred.vs
		this.mDeferredNormalsShader.AddShader(this.mShader[4]);	// deferred_normals.fs
		this.mDeferredNormalsShader.Link();
		this.mDeferredNormalsShader.Init();
		
		this.mShader.push(this.mDeferredNormalsShader);
	}
	else if ( index == 3 )
	{
		// Create SSAO shader program for performing the ambient-occlusion calculations
		this.mSSAOShader = new SSAOShader();
		this.mSSAOShader.Create();
		this.mSSAOShader.AddShader(this.mShader[5]);	// image.vs
		this.mSSAOShader.AddShader(this.mShader[6]);	// ssao.fs
		this.mSSAOShader.Link();
		this.mSSAOShader.Init();
		this.mSSAOShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
		
		// Setup parameters
		this.mSSAOShader.OccluderBias = this.mControls[0].slider("value");
		this.mSSAOShader.SamplingRadius = this.mControls[2].slider("value");
		this.mSSAOShader.Attenuation.SetPoint(this.mControls[4].slider("value"),
											  this.mControls[6].slider("value"));
		
		this.mShader.push(this.mSSAOShader);
	}
	else if ( index == 4 )
	{
		// Create SSAO blend shader program for blending the rendered scene with the AO map
		this.mSSAOBlendShader = new ImageShader();
		this.mSSAOBlendShader.Projection = new Matrix(4, 4);	// Not used
		this.mSSAOBlendShader.View = new Matrix(4, 4);
		this.mSSAOBlendShader.Create();
		this.mSSAOBlendShader.AddShader(this.mShader[5]);	// image.vs
		this.mSSAOBlendShader.AddShader(this.mShader[7]);	// ssao_blend.fs
		this.mSSAOBlendShader.Link();
		this.mSSAOBlendShader.Init();
		
		this.mShader.push(this.mSSAOBlendShader);
	}
	else if ( index == 5 )
	{
		// Create brightness shader to correct brightness, contrast, and gamma
		this.mBrightnessShader = new BrightnessShader();
		this.mBrightnessShader.Create();
		this.mBrightnessShader.AddShader(this.mShader[5]);	// image.vs
		this.mBrightnessShader.AddShader(this.mShader[8]);	// brightness.fs
		this.mBrightnessShader.Link();
		this.mBrightnessShader.Init();
		
		this.mShader.push(this.mBrightnessShader);
		
		// Hide loading screen
		if ( this.mDivLoading != null )
			this.mDivLoading.hide();
		
		this.mLoadComplete = true;
	}
	
	if ( !this.mLoadComplete )
	{
		// Update loading progress
		++index;
		this.UpdateProgress(true);
	
		// Move on
		var parent = this;
		setTimeout(function () { parent.LoadShaders(index) }, 1);
	}
}


/// <summary>
/// Implementation.
/// </summary>
SSAOScene.prototype.OnLoadComplete = function ()
{
	// Process shaders
	var shaderList =
	[
		"basic.vs",
		"basic.fs",
		"deferred.vs",
		"deferred_position.fs",
		"deferred_normals.fs",
		"image.vs",
		"ssao.fs",
		"ssao_blend.fs",
		"brightness.fs"
	];
	
	var shaderResource = new Array();
	for (var i = 0; i < shaderList.length; ++i)
	{
		var resource = this.mResource.Find(shaderList[i]);
		if ( resource == null )
		{
			alert("Missing resource file: " + shaderList[i]);
			return;
		}
		shaderResource.push(resource);
	}
	
	// Process textures
	this.mTexture = new Array();
	this.mTexture.push(this.mResource.Find("normalmap.png"));
	
	for (var i = 0; i < this.mTexture.length; ++i)
	{
		var resource = this.mTexture[i];
		if ( resource != null )
		{
			this.mTexture[i] = new GLTexture2D();
			this.mTexture[i].Create(resource.Item.width, resource.Item.height, Texture.Format.Rgb, SamplerState.LinearClamp, resource.Item);
		}
	}
	
	// Setup camera matrices
	this.mProjectionMatrix = ViewMatrix.Perspective(60.0, 1.333, 0.1, 20.0);
	this.mViewMatrix.PointAt(new Point(0.0, this.mCameraHeight, this.mCameraZoom),
							 this.mCameraTargetPos);
	this.mInvViewMatrix = this.mViewMatrix.Inverse();
	
	// Compile shaders
	this.CompileShaders(0, shaderResource);
}