// This scene demonstrates the screen space ambient occlusion algorithm (SSAO). The algorithm
// is divided into several steps.
//
// 1. Render the scene with normal transform and lighting to a colour buffer (texture).
//
// 2. Render the geometry's 3d view-space positions to an RGBA floating point buffer.
//	   The alpha channel will include the linear depth value, which is used to determine the
//	   sampling radius in the SSAO shader.
//
// 3. Render the geometry's 3d view-space normal vectors to an RGB floating point buffer.
//	   Since WebGL (or OpenGL ES 2.0) does not support multiple colour attachments to an FBO,
//	   this process must require another render pass.
//
// 4. Pass the position buffer, normal buffer, and normalmap texture to the SSAO shader.
//	   The result is stored into a floating point luminance texture.
//
// 5. Subtract the AO map from the colour buffer to produce the final image.
function SSAOScene ()
{
	// Setup inherited members.
	BaseScene.call(this);
	
	// This framebuffer object stores the rendered scene to an RGB texture. It will be
	// blended with the AO map calculated later.
	this.mFboColour = null;
	this.mFboColourColourBuffer = null;
	this.mFboColourDepthBuffer = null;
	

	// This framebuffer object stores the view space position (vertices) to texture.
	// It uses an RGBA floating point texture to store the results. The alpha channel
	// stores the linear depth values, which is used to compute the AO sampling radius.
	this.mFboDeferredPosition = null;
	this.mFboDeferredPositionColourBuffer = null;
	this.mFboDeferredPositionDepthBuffer = null;
	
	// This framebuffer object stores the view space normal vectors to texture.
	// It uses an RGB floating point texture to store the results.
	this.mFboDeferredNormals = null;
	this.mFboDeferredNormalsColourBuffer = null;
	this.mFboDeferredNormalsDepthBuffer = null;
	
	// This framebuffer object stores the calculated ambient occlusion values.
	// It uses a luminance floating point texture to store the results.
	this.mFboSSAO = null;
	this.mFboSSAOColourBuffer = null;
	
	// Gets or sets the dimensions of the FBO, which may or may not be the same size
	// as the window.
	this.mFboDimension = null;
	
	// The basic shader renders the scene using standard transform and lighting.
	this.mBasicShader = null;
	
	// The deferred shader output's geometry data to a floating point texture for
	// later processing.
	this.mDeferredPositionShader = null;
	this.mDeferredNormalsShader = null;
	
	// Shader for calculating the ambient occlusion values.
	this.mSSAOShader = null;
	
	// Shader for blending and rendering the scene and AO map textures.
	this.mSSAOBlendShader = null;
	
	// Shader for correcting the brightness, contrast, and gamma prior to output.
	this.mBrightnessShader = null;
	
	// Surface (rectangle) to perform post-processing effects.
	// It is designed to fit the size of the viewport.
	this.mSurface = null;
	
	// Stores the textures used by this scene.
	this.mTexture = [];
	
	// Stores a reference to the canvas DOM element, which is used to reset the viewport
	// back to its original size after rendering to the FBO, which uses a different
	// dimension.
	this.mCanvas = null;
	
	// Gets or sets whether SSAO is rendered or not.
	this.mEnableSSAO = true;
	
	// Mouse controls for camera position and zoom.
	this.mMouseDown = false;
	this.mMouseStartPos = new Point();
	this.mCameraRot = 0.0;
	this.mCameraZoom = 3.9;
	this.mCameraHeight = 2.0;
	this.mCameraStartRot = 0.0;
	this.mCameraStartZoom = 0.0;
	this.mCameraTargetPos = new Point(0.0, 0.4, 0.0);
	
	// UI members.
	this.mDivLoading = null;
	this.mTxtLoadingProgress = null;
	this.mControls = null;
	this.mBtnEnableSSAO = null;

	this.mNumResources = 0;
}

// Prototypal Inheritance.
SSAOScene.prototype = new BaseScene();
SSAOScene.prototype.constructor = SSAOScene;

// Called when the mouse button is pressed.
SSAOScene.prototype.onMouseDown = function (key)
{
	// Record the current mouse position
	var owner = this.owner;
	owner.mMouseDown = true;
	owner.mMouseStartPos.x = key.pageX - this.offsetLeft;
	owner.mMouseStartPos.y = key.pageY - this.offsetTop;
	owner.mCameraStartRot = owner.mCameraRot;
	owner.mCameraStartZoom = owner.mCameraZoom;
}



// Called when there is mouse movement. Apply rotation and zoom
// only when the mouse button is held down.

SSAOScene.prototype.onMouseMove = function (key)
{
	// Process mouse movement only when the mouse button is held down
	var owner = this.owner;
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
		
		owner.mViewMatrix.pointAt(new Point(Math.sin(owner.mCameraRot) * owner.mCameraZoom, owner.mCameraHeight, Math.cos(owner.mCameraRot) * owner.mCameraZoom),
								  owner.mCameraTargetPos);
		owner.mInvViewMatrix = owner.mViewMatrix.Inverse();
		
		owner.mBasicShader.view = owner.mInvViewMatrix;
		owner.mDeferredPositionShader.view = owner.mInvViewMatrix;
		owner.mDeferredNormalsShader.view = owner.mInvViewMatrix;
	}
}

// Called when the mouse button is released.
SSAOScene.prototype.onMouseUp = function (key)
{
	var owner = this.owner;
	owner.mMouseDown = false;
}

// Implementation.
SSAOScene.prototype.start = function ()
{
	// Setup members and default values
	this.mShader = [];
	this.mCanvas = document.getElementById("webgl_canvas");
	
	// Specify the FBO dimensions
	this.mFboDimension = new Point(this.mCanvas.width, this.mCanvas.height);
	
	
	// Construct FBO for rendering the scene to an RGB texture
	this.mFboColourColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboColourColourBuffer.textureObject = new GLTexture2D();
	this.mFboColourColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgb, SamplerState.LinearClamp);
	
	this.mFboColourDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboColourDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboColour = new GLFrameBufferObject();
	this.mFboColour.create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboColour.AttachBuffer(this.mFboColourColourBuffer);
	this.mFboColour.AttachBuffer(this.mFboColourDepthBuffer);
	
	
	// Construct FBO for rendering the view space positions for ambient occlusion calculations
	this.mFboDeferredPositionColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboDeferredPositionColourBuffer.textureObject = new GLTexture2D();
	this.mFboDeferredPositionColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Vector4, SamplerState.PointClamp);
	
	this.mFboDeferredPositionDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboDeferredPositionDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboDeferredPosition = new GLFrameBufferObject();
	this.mFboDeferredPosition.create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboDeferredPosition.AttachBuffer(this.mFboDeferredPositionColourBuffer);
	this.mFboDeferredPosition.AttachBuffer(this.mFboDeferredPositionDepthBuffer);
	
	
	// Construct FBO for rendering the view space normals for ambient occlusion calculations
	this.mFboDeferredNormalsColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboDeferredNormalsColourBuffer.textureObject = new GLTexture2D();
	this.mFboDeferredNormalsColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Vector3, SamplerState.PointClamp);
	
	this.mFboDeferredNormalsDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboDeferredNormalsDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboDeferredNormals = new GLFrameBufferObject();
	this.mFboDeferredNormals.create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboDeferredNormals.AttachBuffer(this.mFboDeferredNormalsColourBuffer);
	this.mFboDeferredNormals.AttachBuffer(this.mFboDeferredNormalsDepthBuffer);
	
	
	// Construct FBO for rendering the SSAO values
	// Floating point luminance textures don't appear to work on AMD driver 12.6, so falling back to (wasteful)
	// RGB space.
	this.mFboSSAOColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboSSAOColourBuffer.textureObject = new GLTexture2D();
	this.mFboSSAOColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Vector3/*Single*/, SamplerState.LinearClamp);
	
	this.mFboSSAO = new GLFrameBufferObject();
	this.mFboSSAO.create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboSSAO.AttachBuffer(this.mFboSSAOColourBuffer);
	
	
	// Construct the surface used to for post-processing images
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.objectEntity = rectVbo;
	this.mSurface.objectMatrix = new Matrix(4, 4);
	this.mSurface.objectMaterial.Texture = [];
	this.mSurface.objectMaterial.Texture.push(null);	// SSAO view space position data
	this.mSurface.objectMaterial.Texture.push(null);	// SSAO view space normal vectors data
	this.mSurface.objectMaterial.Texture.push(null);	// SSAO normalmap / randomizer
	
	
	// Construct the scene to be rendered
	this.mEntity = SSAOSceneGen.create();

	
	// Prepare resources to download
	
	// Basic transform and lighting shader
	this.mResource.add(new ResourceItem("basic.vs", null, "./shaders/basic.vs"));
	this.mResource.add(new ResourceItem("basic.fs", null, "./shaders/basic.fs"));
	
	// Deferred rendering shaders
	this.mResource.add(new ResourceItem("deferred.vs", null, "./shaders/deferred.vs"));
	this.mResource.add(new ResourceItem("deferred_position.fs", null, "./shaders/deferred_position.fs"));
	this.mResource.add(new ResourceItem("deferred_normals.fs", null, "./shaders/deferred_normals.fs"));
	
	// Post-processing shaders
	this.mResource.add(new ResourceItem("image.vs", null, "./shaders/image.vs"));
	this.mResource.add(new ResourceItem("ssao.fs", null, "./shaders/ssao.fs"));
	this.mResource.add(new ResourceItem("ssao_blend.fs", null, "./shaders/ssao_blend.fs"));
	this.mResource.add(new ResourceItem("brightness.fs", null, "./shaders/brightness.fs"));
	
	
	// Textures used in the scene
	this.mResource.add(new ResourceItem("normalmap.png", null, "./images/normalmap.png"));
	
	// Number of resource to load (including time taken to compile and load shader programs)
	// 9 shaders to compile
	// 5 shader programs to load
	this.mNumResources = this.mResource.item.length + 9 + 5;
	
	
	// Listen for mouse activity
	this.mCanvas.owner = this;
	this.mCanvas.onmousedown = this.onMouseDown;
	this.mCanvas.onmouseup = this.onMouseUp;
	this.mCanvas.onmousemove = this.onMouseMove;
	
	
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
	
	this.mControls = [];
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
	this.mBtnEnableSSAO.on("change", this, this.onEnableSSAOClicked);
	
	
	// Start downloading resources
	BaseScene.prototype.start.call(this);
}



// Method called when the occluder bias slider has changed.

SSAOScene.prototype.OnOccluderBiasValueChanged = function (event, ui)
{
	event.data.owner.mSSAOShader.occluderBias = ui.value;
	event.data.owner.mControls[1].text(ui.value);
}



// Method called when the sampling radius slider has changed.

SSAOScene.prototype.OnSamplingRadiusValueChanged = function (event, ui)
{
	event.data.owner.mSSAOShader.samplingRadius = ui.value;
	event.data.owner.mControls[3].text(ui.value);
}



// Method called when the constant attenuation slider has changed.

SSAOScene.prototype.OnConstantAttenuationValueChanged = function (event, ui)
{
	event.data.owner.mSSAOShader.attenuation.x = ui.value;
	event.data.owner.mControls[5].text(ui.value);
}



// Method called when the linear attenuation slider has changed.

SSAOScene.prototype.OnLinearAttenuationValueChanged = function (event, ui)
{
	event.data.owner.mSSAOShader.attenuation.y = ui.value;
	event.data.owner.mControls[7].text(ui.value);
}



// Method called when the view mode combo box has changed.

SSAOScene.prototype.onEnableSSAOClicked = function (event)
{
	event.data.mEnableSSAO = event.currentTarget.checked;
}



// Implementation.

SSAOScene.prototype.update = function ()
{
	BaseScene.prototype.update.call(this);
	
	// Draw only when all resources have been loaded
	if ( this.mLoadComplete )
	{
		//
		// Step 1: Render the scene to texture using a standard T&L shader
		//
		this.mBasicShader.enable();
			this.mFboColour.enable();
				// Set and clear viewport
				gl.viewport(0, 0, this.mFboColour.getFrameWidth(), this.mFboColour.getFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
				
				// Render
				for (var i = 0; i < this.mEntity.length; ++i)
					this.mBasicShader.draw(this.mEntity[i]);
			this.mFboColour.disable();
		this.mBasicShader.disable();
		
		
		//
		// Step 2: Render the scene's view space positions (vertices) to texture
		//
		this.mDeferredPositionShader.enable();
			this.mFboDeferredPosition.enable();
				// Set and clear viewport
				gl.viewport(0, 0, this.mFboDeferredPosition.getFrameWidth(), this.mFboDeferredPosition.getFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
				
				// Render
				for (var i = 0; i < this.mEntity.length; ++i)
					this.mDeferredPositionShader.draw(this.mEntity[i]);
			this.mFboDeferredPosition.disable();
		this.mDeferredPositionShader.disable();
		
		
		//
		// Step 3: Render the scene's view space normal vectors to texture.
		//		   Normally this would be done in a single pass with the positional data rendered in
		//		   step 2; however WebGL / OpenGL ES 2.0 only supports one colour attachment to the FBO,
		//		   so we need to do it in another pass.
		//
		this.mDeferredNormalsShader.enable();
			this.mFboDeferredNormals.enable();
				// Set and clear viewport
				gl.viewport(0, 0, this.mFboDeferredNormals.getFrameWidth(), this.mFboDeferredNormals.getFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
				
				// Render
				for (var i = 0; i < this.mEntity.length; ++i)
					this.mDeferredNormalsShader.draw(this.mEntity[i]);
			this.mFboDeferredNormals.disable();
		this.mDeferredNormalsShader.disable();
		
		
		//
		// Step 4: Calculate the ambient occlusion values.
		//
		this.mSSAOShader.enable();
			this.mFboSSAO.enable();
				// Set textures
				this.mSurface.objectMaterial.texture[0] = this.mFboDeferredPositionColourBuffer.textureObject;	// From step 2
				this.mSurface.objectMaterial.texture[1] = this.mFboDeferredNormalsColourBuffer.textureObject;	// From step 3
				this.mSurface.objectMaterial.texture[2] = this.mTexture[0];										// normalmap.png
				
				// Render
				this.mSSAOShader.draw(this.mSurface);
			this.mFboSSAO.disable();
		this.mSSAOShader.disable();
				
		
		// Restore viewport
		gl.viewport(0, 0, this.mCanvas.width, this.mCanvas.height);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		
		if ( this.mEnableSSAO )
		{
			//
			// Step 5: Blend the ambient occlusion map with the rendered scene and apply and final post-processing
			//		   operations.
			//
			this.mSSAOBlendShader.enable();
				// Set textures
				this.mSurface.objectMaterial.texture[0] = this.mFboColourColourBuffer.textureObject;
				this.mSurface.objectMaterial.texture[1] = this.mFboSSAOColourBuffer.textureObject;
				
				// Render
				this.mSSAOBlendShader.draw(this.mSurface);
			this.mSSAOBlendShader.disable();
		}
		else
		{
			//
			// SSAO disabled, just show normal scene with gamma correction
			//
			this.mBrightnessShader.enable();
				// Set textures
				this.mSurface.objectMaterial.texture[0] = this.mFboColourColourBuffer.textureObject;
				
				// Render
				this.mBrightnessShader.draw(this.mSurface);
			this.mBrightnessShader.disable();
		}
	}
}



// Implementation.

SSAOScene.prototype.end = function ()
{
	BaseScene.prototype.end.call(this);

	// Cleanup
	
	// Release FBOs
	if ( this.mFboColour != null )
	{
		this.mFboColour.release();
		this.mFboColourColourBuffer.textureObject.release();
	}
	
	if ( this.mFboDeferredPosition != null )
	{
		this.mFboDeferredPosition.release();
		this.mFboDeferredPositionColourBuffer.textureObject.release();
	}
	
	if ( this.mFboDeferredNormals != null )
	{
		this.mFboDeferredNormals.release();
		this.mFboDeferredNormalsColourBuffer.textureObject.release();
	}
	
	if ( this.mFboSSAO != null )
	{
		this.mFboSSAO.release();
		this.mFboSSAOColourBuffer.textureObject.release();
	}
	
	// Release VBOs
	if ( this.mSurface != null )
		this.mSurface.objectEntity.release();
		
	// Release textures
	if ( this.mTexture != null )
	{
		for (var i = 0; i < this.mTexture.length; ++i)
			this.mTexture[i].release();
	}
	
	// Release controls
	this.mDivLoading = null;
	this.mTxtLoadingProgress = null;
	this.mControls = null;
	this.mBtnEnableSSAO = null;
}



// This method will update the displayed loading progress.

// <param name="increment">
// Set to true to increment the resource counter by one. Normally hanadled by BaseScene.
// </param>
SSAOScene.prototype.updateProgress = function (increment)
{
	if ( increment != null )
		++this.mResourceCount;
		
	if ( this.mTxtLoadingProgress != null )
		this.mTxtLoadingProgress.html(((this.mResourceCount / this.mNumResources) * 100.0).toFixed(2));
}



// Implementation.

SSAOScene.prototype.onItemLoaded = function (sender, response)
{
	BaseScene.prototype.onItemLoaded.call(this, sender, response);
	this.updateProgress();
}



// This method is called to compile a bunch of shaders. The browser will be
// blocked while the GPU compiles, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).

SSAOScene.prototype.compileShaders = function (index, list)
{
	var shaderItem = list[index];
	if ( shaderItem != null )
	{
		// Compile vertex shader
		var shader = new GLShader();
		if ( !shader.create((shaderItem.name.lastIndexOf(".vs") != -1) ? GLShader.ShaderType.Vertex : GLShader.ShaderType.Fragment, shaderItem.Item) )
		{
			// Report error
			var log = shader.getLog();
			alert("Error compiling " + shaderItem.name + ".\n\n" + log);
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
	this.updateProgress(true);

	if ( index < list.length )
	{
		// Move on to next shader
		var parent = this;
		setTimeout(function () { parent.compileShaders(index, list) }, 1);
	}
	else if ( index == list.length )
	{
		// Now start loading in the shaders
		this.loadShaders(0);
	}
}



// This method is called to load a bunch of shaders. The browser will be
// blocked while the GPU loads, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).

SSAOScene.prototype.loadShaders = function (index, blendModes)
{
	if ( index == 0 )
	{
		// Create basic T&L program
		this.mBasicShader = new BasicShader();
		this.mBasicShader.projection = this.mProjectionMatrix;
		this.mBasicShader.view = this.mInvViewMatrix;
		this.mBasicShader.create();
		this.mBasicShader.addShader(this.mShader[0]);	// basic.vs
		this.mBasicShader.addShader(this.mShader[1]);	// basic.fs
		this.mBasicShader.link();
		this.mBasicShader.init();
		
		// Add light sources
		var light1 = new Light();
		light1.LightType = Light.LightSourceType.Point;
		light1.Position = new Point(0.0, 4.0, 0.0);
		this.mBasicShader.lightObject.push(light1);
		
		this.mShader.push(this.mBasicShader);
	}
	else if ( index == 1 )
	{
		// Create deferred position shader program
		this.mDeferredPositionShader = new DeferredShader();
		this.mDeferredPositionShader.projection = this.mProjectionMatrix;
		this.mDeferredPositionShader.view = this.mInvViewMatrix;
		this.mDeferredPositionShader.create();
		this.mDeferredPositionShader.addShader(this.mShader[2]);	// deferred.vs
		this.mDeferredPositionShader.addShader(this.mShader[3]);	// deferred_position.fs
		this.mDeferredPositionShader.link();
		this.mDeferredPositionShader.init();
		
		// Setup parameters
		this.mDeferredPositionShader.LinearDepth = 20.0 - 0.1;
		
		this.mShader.push(this.mDeferredPositionShader);
	}
	else if ( index == 2 )
	{
		// Create deferred normals program
		this.mDeferredNormalsShader = new DeferredShader();
		this.mDeferredNormalsShader.projection = this.mProjectionMatrix;
		this.mDeferredNormalsShader.view = this.mInvViewMatrix;
		this.mDeferredNormalsShader.create();
		this.mDeferredNormalsShader.addShader(this.mShader[2]);	// deferred.vs
		this.mDeferredNormalsShader.addShader(this.mShader[4]);	// deferred_normals.fs
		this.mDeferredNormalsShader.link();
		this.mDeferredNormalsShader.init();
		
		this.mShader.push(this.mDeferredNormalsShader);
	}
	else if ( index == 3 )
	{
		// Create SSAO shader program for performing the ambient-occlusion calculations
		this.mSSAOShader = new SSAOShader();
		this.mSSAOShader.create();
		this.mSSAOShader.addShader(this.mShader[5]);	// image.vs
		this.mSSAOShader.addShader(this.mShader[6]);	// ssao.fs
		this.mSSAOShader.link();
		this.mSSAOShader.init();
		this.mSSAOShader.setSize(this.mFboDimension.x, this.mFboDimension.y);
		
		// Setup parameters
		this.mSSAOShader.occluderBias = this.mControls[0].slider("value");
		this.mSSAOShader.samplingRadius = this.mControls[2].slider("value");
		this.mSSAOShader.attenuation.setPoint(this.mControls[4].slider("value"),
											  this.mControls[6].slider("value"));
		
		this.mShader.push(this.mSSAOShader);
	}
	else if ( index == 4 )
	{
		// Create SSAO blend shader program for blending the rendered scene with the AO map
		this.mSSAOBlendShader = new ImageShader();
		this.mSSAOBlendShader.projection = new Matrix(4, 4);	// Not used
		this.mSSAOBlendShader.view = new Matrix(4, 4);
		this.mSSAOBlendShader.create();
		this.mSSAOBlendShader.addShader(this.mShader[5]);	// image.vs
		this.mSSAOBlendShader.addShader(this.mShader[7]);	// ssao_blend.fs
		this.mSSAOBlendShader.link();
		this.mSSAOBlendShader.init();
		
		this.mShader.push(this.mSSAOBlendShader);
	}
	else if ( index == 5 )
	{
		// Create brightness shader to correct brightness, contrast, and gamma
		this.mBrightnessShader = new BrightnessShader();
		this.mBrightnessShader.create();
		this.mBrightnessShader.addShader(this.mShader[5]);	// image.vs
		this.mBrightnessShader.addShader(this.mShader[8]);	// brightness.fs
		this.mBrightnessShader.link();
		this.mBrightnessShader.init();
		
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
		this.updateProgress(true);
	
		// Move on
		var parent = this;
		setTimeout(function () { parent.loadShaders(index) }, 1);
	}
}



// Implementation.

SSAOScene.prototype.onLoadComplete = function ()
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
	
	var shaderResource = [];
	for (var i = 0; i < shaderList.length; ++i)
	{
		var resource = this.mResource.find(shaderList[i]);
		if ( resource == null )
		{
			alert("Missing resource file: " + shaderList[i]);
			return;
		}
		shaderResource.push(resource);
	}
	
	// Process textures
	this.mTexture = [];
	this.mTexture.push(this.mResource.find("normalmap.png"));
	
	for (var i = 0; i < this.mTexture.length; ++i)
	{
		var resource = this.mTexture[i];
		if ( resource != null )
		{
			this.mTexture[i] = new GLTexture2D();
			this.mTexture[i].create(resource.item.width, resource.item.height, Texture.Format.Rgb, SamplerState.LinearClamp, resource.item);
		}
	}
	
	// Setup camera matrices
	this.mProjectionMatrix = ViewMatrix.perspective(60.0, 1.333, 0.1, 20.0);
	this.mViewMatrix.pointAt(new Point(0.0, this.mCameraHeight, this.mCameraZoom),
							 this.mCameraTargetPos);
	this.mInvViewMatrix = this.mViewMatrix.inverse();
	
	// Compile shaders
	this.compileShaders(0, shaderResource);
}