// <summary>
// Nutty Software Open WebGL Framework
// 
// Copyright (C) 2012 Nathaniel Meyer
// Nutty Software, http://www.nutty.ca
// All Rights Reserved.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//     1. The above copyright notice and this permission notice shall be included in all
//        copies or substantial portions of the Software.
//     2. Redistributions in binary or minimized form must reproduce the above copyright
//        notice and this list of conditions in the documentation and/or other materials
//        provided with the distribution.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// </summary>


// <summary>
// This scene demonstrates how to render refraction.
//
// To render the effect, follow these steps.
// 1. Create an RGBA FBO.
// 2. Render the scene to the FBO.
// 3. Render the refracted surfaces to the alpha channel.
// 4. In the refraction shader, refract only the pixels with their alpha channel set.
// </summary>


// <summary>
// Constructor.
// </summary>
function RefractionScene ()
{
	// <summary>
	// Setup inherited members.
	// </summary>
	BaseScene.call(this);
	
	
	// <summary>
	// Stores the current inverse view matrix.
	// </summary>
	this.mInvViewMatrix = null;
	
	
	// <summary>
	// The framebuffer object to store the colour buffer (ie: the result of the rendered scene).
	// This will be fed into the refraction shader.
	// </summary>
	this.mFboColour = null;
	this.mFboColourColourBuffer = null;
	this.mFboColourDepthBuffer = null;
	
	
	// <summary>
	// The framebuffer object to store the refraction results.
	// </summary>
	this.mFboRefraction = null;
	this.mFboRefractionColourBuffer = null;

	
	// <summary>
	// Gets or sets the dimensions of the FBO, which may or may not be the same size
	// as the window.
	// </summary>
	this.mFboDimension = null;
	
	
	// <summary>
	// Stores a list of shaders loaded and compiled by this scene.
	// </summary>
	this.mShader = null;
	
	
	// <summary>
	// The basic shader is responsible for rendering the scene as normal.
	// </summary>
	this.mBasicShader = null;
	
	
	// <summary>
	// Shader for tagging pixels that will be affected by the refraction shader.
	// </summary>
	this.mPixelTagShader = null;
	
	
	// <summary>
	// Shader for refracting pixels.
	// </summary>
	this.mRefractionShader = null;
	
	
	// <summary>
	// Brightness shader for performing the final brightness, contrast, and gamma correction
	// to the rendered image.
	// </summary>
	this.mBrightnessShader = null;
	
	
	// <summary>
	// Shader for rendering a cubemapped skybox
	// </summary>
	this.mSkyboxShader = null;
	
	
	// <summary>
	// Surface (rectangle) containing a texture to manipulate or view. Used during
	// the gamma correction process. It is designed to fit the size of the viewport.
	// </summary>
	this.mSurface = null;
	
	
	// <summary>
	// Stores the textures used by this scene.
	// </summary>
	this.mTexture = new Array();
	
	
	// <summary>
	// Stores a reference to the canvas DOM element, which is used to reset the viewport
	// back to its original size after rendering to the FBO, which may use a different
	// dimension.
	// </summary>
	this.mCanvas = null;
	
	
	// <summary>
	// Mouse controls for camera position and zoom.
	// </summary>
	this.mMouseDown = false;
	this.mMouseStartPos = new Point();
	this.mCameraRot = 0.0;
	this.mCameraZoom = 15.0;
	this.mCameraHeight = 1.0;
	this.mCameraStartRot = 0.0;
	this.mCameraStartZoom = 0.0;
	
	
	// <summary>
	// UI members.
	// </summary>
	this.mDivLoading = null;
	this.mTxtLoadingProgress = null;
	
	this.mAmplitudeSlider = null;
	this.mAmplitudeSliderTxt = null;
	
	this.mFrequencySlider = null;
	this.mFrequencySliderTxt = null;
	
	this.mPeriodSlider = null;
	this.mPeriodSliderTxt = null;
	
	this.mCBoxPreset = null;
}


// <summary>
// Prototypal Inheritance.
// </summary>
RefractionScene.prototype = new BaseScene();
RefractionScene.prototype.constructor = RefractionScene;


// <summary>
// Called when the mouse button is pressed.
// </summary>
RefractionScene.prototype.OnMouseDown = function (key)
{
	var owner = this.Owner;
	owner.mMouseDown = true;
	owner.mMouseStartPos.x = key.pageX - this.offsetLeft;
	owner.mMouseStartPos.y = key.pageY - this.offsetTop;
	owner.mCameraStartRot = owner.mCameraRot;
	owner.mCameraStartZoom = owner.mCameraZoom;
}


// <summary>
// Called when there is mouse movement. Apply rotation and zoom
// only when the mouse button is held down.
// </summary>
RefractionScene.prototype.OnMouseMove = function (key)
{
	// Process mouse movement only when the mouse button is held down
	var owner = this.Owner;
	if ( owner.mMouseDown )
	{
		// Rotate and zoom camera about centre
		// Calculate delta position
		var x = (owner.mMouseStartPos.x - (key.pageX - this.offsetLeft)) * 0.01;
		var y = (owner.mMouseStartPos.y - (key.pageY - this.offsetTop)) * 0.1;
		
		owner.mCameraRot = owner.mCameraStartRot + x;
		owner.mCameraZoom = owner.mCameraStartZoom + y;
		
		// Impose limits on zoom
		if ( owner.mCameraZoom < 5.0 )
			owner.mCameraZoom = 5.0;
		else if ( owner.mCameraZoom > 15.0 )
			owner.mCameraZoom = 15.0;
		
		owner.mViewMatrix.PointAt(new Point(Math.sin(owner.mCameraRot) * owner.mCameraZoom, owner.mCameraHeight, Math.cos(owner.mCameraRot) * owner.mCameraZoom),
								  new Point());
		owner.mInvViewMatrix = owner.mViewMatrix.Inverse();
		
		owner.mBasicShader.View = owner.mInvViewMatrix;
		owner.mPixelTagShader.View = owner.mInvViewMatrix;
		owner.mSkyboxShader.View = owner.mInvViewMatrix;
	}
}


// <summary>
// Called when the mouse button is released.
// </summary>
RefractionScene.prototype.OnMouseUp = function (key)
{
	var owner = this.Owner;
	owner.mMouseDown = false;
}


// <summary>
// Implementation.
// </summary>
RefractionScene.prototype.Start = function ()
{
	// Setup members and default values
	this.mShader = new Array();
	this.mCanvas = document.getElementById("Canvas");
	
	// Set the FBO dimensions to match with the window
	this.mFboDimension = new Point(this.mCanvas.width, this.mCanvas.height);
	
	
	// Construct FBO for rendering the colour buffer
	this.mFboColourColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboColourColourBuffer.TextureObject = new GLTexture2D();
	this.mFboColourColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, SamplerState.LinearClamp);
	
	this.mFboColourDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboColourDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboColour = new GLFrameBufferObject();
	this.mFboColour.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboColour.AttachBuffer(this.mFboColourColourBuffer);
	this.mFboColour.AttachBuffer(this.mFboColourDepthBuffer);
	
	
	// Construct FBO for rendering refraction
	this.mFboRefractionColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboRefractionColourBuffer.TextureObject = new GLTexture2D();
	this.mFboRefractionColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, SamplerState.LinearClamp);

	this.mFboRefraction = new GLFrameBufferObject();
	this.mFboRefraction.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboRefraction.AttachBuffer(this.mFboRefractionColourBuffer);
	
	
	// Construct the scene to be rendered
	this.mEntity = RefractionSceneGen.Create();
	
	// Construct the surface used to for post-processing images
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.Create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.ObjectEntity = rectVbo;
	this.mSurface.ObjectMaterial.Texture = new Array();
	this.mSurface.ObjectMaterial.Texture.push(this.mFboColourColourBuffer.TextureObject);

	
	// Prepare resources to download
	// The basic shader is responsible for rendering the scene with lights, colours, and textures
	this.mResource.Add(new ResourceItem("basic.vs", null, "./shaders/basic.vs"));
	this.mResource.Add(new ResourceItem("basic.fs", null, "./shaders/basic.fs"));
	
	// The shader to tag pixels that will be affected by refraction.
	this.mResource.Add(new ResourceItem("pixel_tag.fs", null, "./shaders/pixel_tag.fs"));
	
	// The image shader is responsible for rendering textures onto the screen.
	this.mResource.Add(new ResourceItem("image.vs", null, "./shaders/image.vs"));
	
	// Shader to compute the refrction on a specific area in a rendered image.
	this.mResource.Add(new ResourceItem("refraction.fs", null, "./shaders/refraction.fs"));
	
	// The skybox shader for handling a cubemap based skybox texture
	this.mResource.Add(new ResourceItem("skybox.vs", null, "./shaders/skybox.vs"));
	this.mResource.Add(new ResourceItem("skybox.fs", null, "./shaders/skybox.fs"));
	
	// Brightness shader for adjusting the brightness, contrast, and gamma correction for the final
	// rendered image.
	this.mResource.Add(new ResourceItem("brightness.fs", null, "./shaders/brightness.fs"));
	
	
	// Textures used in the scene
	this.mResource.Add(new ResourceItem("white.png", null, "./images/white.png"));
	this.mResource.Add(new ResourceItem("sand.jpg", null, "./images/sand.jpg"));
	this.mResource.Add(new ResourceItem("sky_positive_x.jpg", null, "./images/sky_positive_x.jpg"));
	this.mResource.Add(new ResourceItem("sky_negative_x.jpg", null, "./images/sky_negative_x.jpg"));
	this.mResource.Add(new ResourceItem("sky_positive_y.jpg", null, "./images/sky_positive_y.jpg"));
	this.mResource.Add(new ResourceItem("sky_positive_z.jpg", null, "./images/sky_positive_z.jpg"));
	this.mResource.Add(new ResourceItem("sky_negative_z.jpg", null, "./images/sky_negative_z.jpg"));
	
	
	// Listen for mouse activity
	this.mCanvas.Owner = this;
	this.mCanvas.onmousedown = this.OnMouseDown;
	this.mCanvas.onmouseup = this.OnMouseUp;
	this.mCanvas.onmousemove = this.OnMouseMove;
	
	
	// Setup user interface
	this.mDivLoading = $("#DivLoading");
	this.mTxtLoadingProgress = $("#TxtLoadingProgress");
	
	// Amplitude slider
	this.mAmplitudeSlider = $("#AmplitudeSlider");
	this.mAmplitudeSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.01,
		min: 0.0,
		max: 1.0,
		value: 0.03
	});
	this.mAmplitudeSlider.on("slide", this, this.OnAmplitudeChanged);
	this.mAmplitudeSlider.on("slidechange", this, this.OnAmplitudeChanged);
	this.mAmplitudeSliderTxt = $("#AmplitudeSliderTxt");
	this.mAmplitudeSliderTxt.text(this.mAmplitudeSlider.slider("value"));
	
	// Frequency slider
	this.mFrequencySlider = $("#FrequencySlider");
	this.mFrequencySlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 1.0,
		min: 0.0,
		max: 256.0,
		value: 30.0
	});
	this.mFrequencySlider.on("slide", this, this.OnFrequencyChanged);
	this.mFrequencySlider.on("slidechange", this, this.OnFrequencyChanged);
	this.mFrequencySliderTxt = $("#FrequencySliderTxt");
	this.mFrequencySliderTxt.text(this.mFrequencySlider.slider("value"));
	
	// Period slider
	this.mPeriodSlider = $("#PeriodSlider");
	this.mPeriodSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 1.0,
		min: 0.0,
		max: 64.0,
		value: 3.0
	});
	this.mPeriodSlider.on("slide", this, this.OnPeriodChanged);
	this.mPeriodSlider.on("slidechange", this, this.OnPeriodChanged);
	this.mPeriodSliderTxt = $("#PeriodSliderTxt");
	this.mPeriodSliderTxt.text(this.mPeriodSlider.slider("value"));
	
	// Presets
	this.mCBoxPreset = $("#CBoxPreset");
	this.mCBoxPreset.on("change", this, this.OnPresetChanged);
		
	
	// Start downloading resources
	BaseScene.prototype.Start.call(this);
}


// <summary>
// Method called when the amplitude slider has changed.
// </summary>
RefractionScene.prototype.OnAmplitudeChanged = function (event, ui)
{
	event.data.mRefractionShader.Amplitude = ui.value;
	event.data.mAmplitudeSliderTxt.text(ui.value);
}


// <summary>
// Method called when the frequency slider has changed.
// </summary>
RefractionScene.prototype.OnFrequencyChanged = function (event, ui)
{
	event.data.mRefractionShader.Frequency = ui.value;
	event.data.mFrequencySliderTxt.text(ui.value);
}


// <summary>
// Method called when the period slider has changed.
// </summary>
RefractionScene.prototype.OnPeriodChanged = function (event, ui)
{
	event.data.mRefractionShader.Period = ui.value;
	event.data.mPeriodSliderTxt.text(ui.value);
}


// <summary>
// Method called when the preset combo box has changed.
// </summary>
RefractionScene.prototype.OnPresetChanged = function (event)
{
	var selectedIndex = event.currentTarget.selectedIndex;
	switch ( selectedIndex )
	{
		case 0:
			// Desert Heat
			event.data.mRefractionShader.Amplitude = 0.03;
			event.data.mRefractionShader.Frequency = 30;
			event.data.mRefractionShader.Period = 3;
		break;
		
		case 1:
			// Jet engine heat
			event.data.mRefractionShader.Amplitude = 0.1;
			event.data.mRefractionShader.Frequency = 110;
			event.data.mRefractionShader.Period = 50;
		break;
		
		case 2:
			// Military jet engine heat
			event.data.mRefractionShader.Amplitude = 0.2;
			event.data.mRefractionShader.Frequency = 256;
			event.data.mRefractionShader.Period = 64;
		break;
		
		case 3:
			// Water
			event.data.mRefractionShader.Amplitude = 0.5;
			event.data.mRefractionShader.Frequency = 20;
			event.data.mRefractionShader.Period = 2;
		break;
	}
	
	// Update sliders
	event.data.mAmplitudeSlider.slider("value", event.data.mRefractionShader.Amplitude);
	event.data.mFrequencySlider.slider("value", event.data.mRefractionShader.Frequency);
	event.data.mPeriodSlider.slider("value", event.data.mRefractionShader.Period);
}


// <summary>
// Implementation.
// </summary>
RefractionScene.prototype.Update = function ()
{
	BaseScene.prototype.Update.call(this);
	
	// Draw only when all resources have been loaded
	if ( this.mLoadComplete )
	{
		//
		// Step 1: Render the scene as normal to texture
		//
		this.mFboColour.Enable();
		gl.viewport(0, 0, this.mFboColour.GetFrameWidth(), this.mFboColour.GetFrameHeight());
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		// Draw props (ground, spheres, etc.)
		this.mBasicShader.Enable();
			for (var i = 0; i < (this.mEntity.length - 2); ++i)
				this.mBasicShader.Draw(this.mEntity[i]);
		this.mBasicShader.Disable();		
		
		// Draw skybox
		this.mSkyboxShader.Enable();
			this.mSkyboxShader.Draw(this.mEntity[this.mEntity.length - 1]);
		this.mSkyboxShader.Disable();
		
		
		//
		// Step 2: Draw geometry affected by refraction. This will not be visible in the rendered image,
		//		   but it will alter the alpha channel of the fragment, which is used as an indicator to the
		//		   refraction shader to alter only those pixels.
		this.mPixelTagShader.Enable();
			for (var i = 1; i < (this.mEntity.length - 1); ++i)
				this.mPixelTagShader.Draw(this.mEntity[i]);
		this.mPixelTagShader.Disable();

		// Stop rendering to texture
		this.mFboColour.Disable();
		
		
		//
		// Step 3: Refract pixels.
		//
		this.mSurface.ObjectMaterial.Texture[0] = this.mFboColourColourBuffer.TextureObject;
		
		// Increase the random number linearly to produce a smooth animation.
		this.mRefractionShader.RandomNumber += 0.01;
			
		this.mRefractionShader.Enable();		
			// Draw
			this.mFboRefraction.Enable();
			this.mRefractionShader.Draw(this.mSurface);
			this.mFboRefraction.Disable();
		this.mRefractionShader.Disable();
		this.mSurface.ObjectMaterial.Texture[0] = this.mFboRefractionColourBuffer.TextureObject;
		
		// Restore viewport
		gl.viewport(0, 0, this.mCanvas.width, this.mCanvas.height);

		
		//
		// Step 4: Render the FBO
		// Apply brightness, contrast, and gamma correction to the final render.
		//	
		this.mBrightnessShader.Enable();
			gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
				
			// Render flat surface
			this.mBrightnessShader.Draw(this.mSurface);
		this.mBrightnessShader.Disable();
	}
}


// <summary>
// Implementation.
// </summary>
RefractionScene.prototype.End = function ()
{
	BaseScene.prototype.End.call(this);

	// Cleanup
	if ( this.mFboColour != null )
	{
		this.mFboColourColourBuffer.TextureObject.Release();
		this.mFboColour.Release();
	}	
	
	if ( this.mFboRefraction != null )
	{
		this.mFboRefractionColourBuffer.TextureObject.Release();
		this.mFboRefraction.Release();
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
}


// <summary>
// Implementation.
// </summary>
RefractionScene.prototype.OnItemLoaded = function (sender, response)
{
	BaseScene.prototype.OnItemLoaded.call(this, sender, response);
	
	if ( this.mTxtLoadingProgress != null )
		this.mTxtLoadingProgress.html(Math.floor((this.mResourceCount / (this.mResource.Item.length + 5.0)) * 100.0));
}


// <summary>
// This method is called to compile a bunch of shaders. The browser will be
// blocked while the GPU compiles, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).
// </summary>
RefractionScene.prototype.CompileShaders = function (index, list)
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


// <summary>
// This method is called to load a bunch of shaders. The browser will be
// blocked while the GPU loads, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).
// </summary>
RefractionScene.prototype.LoadShaders = function (index)
{
	if ( index == 0 )
	{
		// Create basic shader program
		this.mBasicShader = new BasicShader();
		this.mBasicShader.Projection = this.mProjectionMatrix;
		this.mBasicShader.View = this.mInvViewMatrix;
		this.mBasicShader.Create();
		this.mBasicShader.AddShader(this.mShader[0]);	// basic.vs
		this.mBasicShader.AddShader(this.mShader[1]);	// basic.fs
		this.mBasicShader.Link();
		this.mBasicShader.Init();
		this.mShader.push(this.mBasicShader);
		
		// Add light sources
		var light1 = new Light();
		light1.Position.SetPoint(0.0, 20.0, 0.0);
		light1.Attenuation.x = 0.8;
		this.mBasicShader.LightObject.push(light1);
	}
	else if ( index == 1 )
	{
		// Create shader program to tag pixels that will be affected by the refraction shader
		this.mPixelTagShader = new PixelTagShader();
		this.mPixelTagShader.Projection = this.mProjectionMatrix;
		this.mPixelTagShader.View = this.mInvViewMatrix;
		this.mPixelTagShader.Create();
		this.mPixelTagShader.AddShader(this.mShader[0]);	// basic.vs
		this.mPixelTagShader.AddShader(this.mShader[2]);	// pixel_tag.fs
		this.mPixelTagShader.Link();
		this.mPixelTagShader.Init();
		this.mShader.push(this.mPixelTagShader);
	}
	else if ( index == 2 )
	{
		// Refraction shader program
		this.mRefractionShader = new RefractionShader();
		this.mRefractionShader.Create();
		this.mRefractionShader.AddShader(this.mShader[3]);	// image.vs
		this.mRefractionShader.AddShader(this.mShader[4]);	// refraction.fs
		this.mRefractionShader.Link();
		this.mRefractionShader.Init();
		this.mRefractionShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
		this.mShader.push(this.mRefractionShader);
		
		// Initialize shader properties
		this.mRefractionShader.RandomNumber = 0.0;
		this.mRefractionShader.Amplitude = this.mAmplitudeSlider.slider("value")
		this.mRefractionShader.Frequency = this.mFrequencySlider.slider("value")
		this.mRefractionShader.Period = this.mPeriodSlider.slider("value")
	}
	else if ( index == 3 )
	{
		// Shader for rendering cubmapped skyboxes.
		this.mSkyboxShader = new SkyboxShader();
		this.mSkyboxShader.Create();
		this.mSkyboxShader.AddShader(this.mShader[5]);	// skybox.vs
		this.mSkyboxShader.AddShader(this.mShader[6]);	// skybox.fs
		this.mSkyboxShader.Link();
		this.mSkyboxShader.Init();
		this.mShader.push(this.mSkyboxShader);
		
		// Initialize shader
		this.mSkyboxShader.Projection = this.mProjectionMatrix;
		this.mSkyboxShader.View = this.mInvViewMatrix;
	}
	else if ( index == 4 )
	{
		// Shader for adjusting brightness, contrast, and gamma correction.
		this.mBrightnessShader = new BrightnessShader();
		this.mBrightnessShader.Create();
		this.mBrightnessShader.AddShader(this.mShader[3]);	// image.vs
		this.mBrightnessShader.AddShader(this.mShader[7]);	// brightness.fs
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
		if ( this.mTxtLoadingProgress != null )
			this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount + index) / (this.mResource.Item.length + 5.0)) * 100.0));
	
		// Move on
		var parent = this;
		setTimeout(function () { parent.LoadShaders(index) }, 1);
	}
}


// <summary>
// Implementation.
// </summary>
RefractionScene.prototype.OnLoadComplete = function ()
{
	// Process shaders
	var shaderResource = new Array();
	shaderResource.push(this.mResource.Find("basic.vs"));
	shaderResource.push(this.mResource.Find("basic.fs"));
	shaderResource.push(this.mResource.Find("pixel_tag.fs"));
	shaderResource.push(this.mResource.Find("image.vs"));
	shaderResource.push(this.mResource.Find("refraction.fs"));
	shaderResource.push(this.mResource.Find("skybox.vs"));
	shaderResource.push(this.mResource.Find("skybox.fs"));
	shaderResource.push(this.mResource.Find("brightness.fs"));
	
	// Process textures
	this.mTexture = new Array();
	this.mTexture.push(this.mResource.Find("white.png"));
	this.mTexture.push(this.mResource.Find("sand.jpg"));
	var sampler = new SamplerState(SamplerState.LinearRepeat);
	sampler.HasMipMap = true;
	
	for (var i = 0; i < this.mTexture.length; ++i)
	{
		var resource = this.mTexture[i];
		if ( resource != null )
		{
			this.mTexture[i] = new GLTexture2D();
			this.mTexture[i].Create(resource.Item.width, resource.Item.height, Texture.Format.Rgb, sampler, resource.Item);
		}
	}
	
	var skyboxCubemap = new Array();
	skyboxCubemap.push(this.mResource.Find("sky_positive_x.jpg"));
	skyboxCubemap.push(this.mResource.Find("sky_negative_x.jpg"));
	skyboxCubemap.push(this.mResource.Find("sky_positive_y.jpg"));
	skyboxCubemap.push(this.mResource.Find("sky_positive_z.jpg"));
	skyboxCubemap.push(this.mResource.Find("sky_negative_z.jpg"));
	
	// Skybox cubemap
	var skyTexture = new GLTextureCube();
	var skyTextureWidth = skyboxCubemap[0].Item.width;
	var skyTextureHeight = skyboxCubemap[0].Item.height;
	var skyFaceIndex = 0;
	
	skyTexture.Create(skyTextureWidth, skyTextureHeight, Texture.Format.Rgb, SamplerState.LinearClamp);
	for (var i = 0; i < skyboxCubemap.length; ++i)
	{
		skyTexture.Copy(skyTexture.CubeFace.PositiveX + skyFaceIndex, skyboxCubemap[i].Item);
		
		// Skip negative y face
		++skyFaceIndex;
		if ( i == 2 )
			++skyFaceIndex;
	}
	this.mTexture.push(skyTexture);
	
	// Assign textures
	for (var i = 0; i < this.mEntity.length; ++i)
	{
		// Assign blank texture by default
		this.mEntity[i].ObjectMaterial.Texture = new Array();
		this.mEntity[i].ObjectMaterial.Texture.push(this.mTexture[0]);
	}
	
	// Assign skybox
	this.mEntity[this.mEntity.length - 1].ObjectMaterial.Texture[0] = skyTexture;
	
	// Ground texture
	this.mEntity[0].ObjectMaterial.Texture[0] = this.mTexture[1];
	
	
	// Setup camera matrices	
	this.mProjectionMatrix = ViewMatrix.Perspective(60.0, 1.333, 1.0, 1024.0);
	this.mViewMatrix.PointAt(new Point(0.0, this.mCameraHeight, this.mCameraZoom),
							 new Point());
	this.mInvViewMatrix = this.mViewMatrix.Inverse();
	
	// Compile shaders
	this.CompileShaders(0, shaderResource);
}