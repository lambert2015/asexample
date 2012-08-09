
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




// This scene demonstrates how to correct the gamma for a render. Your monitor applies a
// gamma curve to images displayed on the screen, but renderers operate in linear space.
// You must apply the inverse gamma to the rendered image before it is sent to the monitor.




// Constructor.

function GammaCorrectionScene ()
{
	
	// Setup inherited members.
	
	BaseScene.call(this);
	
	
	
	// Stores the current inverse view matrix.
	
	this.mInvViewMatrix = null;
	
	
	
	// The framebuffer object to store the colour buffer (ie: the result of the rendered scene).
	// This will be fed into the gamma correction shader.
	
	this.mFboColour = null;
	
	
	
	// Framebuffer objects.
	
	this.mFboColourColourBuffer = null;
	this.mFboColourDepthBuffer = null;

	
	
	// Gets or sets the dimensions of the FBO, which may or may not be the same size
	// as the window.
	
	this.mFboDimension = null;
	
	
	
	// Stores a list of shaders loaded and compiled by this scene.
	
	this.mShader = null;
	
	
	
	// The basic shader is responsible for rendering the scene as normal. It will produce
	// the colour texture used in the gamma / brightness stage.
	
	this.mBasicShader = null;
	
	
	
	// Shader for rendering 2D images onto the screen. Used in the texture compare scene.
	
	this.mImageShader = null;
	
	
	
	// Shader for altering the frame's brightness and contrast values.
	
	this.mBrightnessShader = null;
	
	
	
	// Surface (rectangle) containing a texture to manipulate or view. Used during
	// the gamma correction process. It is designed to fit the size of the viewport.
	
	this.mSurface = null;
	
	
	
	// Textures.
	
	this.mTexture = new Array();
	
	
	
	// Stores a reference to the canvas DOM element, which is used to reset the viewport
	// back to its original size after rendering to the FBO, which uses a different
	// dimension.
	
	this.mCanvas = null;
	
	
	
	// UI members.
	
	this.mDivLoading = null;
	this.mTxtLoadingProgress = null;
	
	this.mSceneText = new Array();
	
	this.mAmbientRedSlider = null;
	this.mAmbientRedSliderTxt = null;
	
	this.mAmbientGreenSlider = null;
	this.mAmbientGreenSliderTxt = null;
	
	this.mAmbientBlueSlider = null;
	this.mAmbientBlueSliderTxt = null;
	
	this.mDiffuseRedSlider = null;
	this.mDiffuseRedSliderTxt = null;
	
	this.mDiffuseGreenSlider = null;
	this.mDiffuseGreenSliderTxt = null;
	
	this.mDiffuseBlueSlider = null;
	this.mDiffuseBlueSliderTxt = null;
	
	this.mShininessSlider = null;
	this.mShininessSliderTxt = null;
	
	this.mBtnEnableGamma = null;
	this.mGammaSlider = null;
	this.mGammaSliderTxt = null;
	
	this.mIsGammaEnabled = true;
	
	this.mBrightnessSlider = null;
	this.mBrightnessSliderTxt = null;
	this.mContrastSlider = null;
	this.mContrastSliderTxt = null;
	
	this.mCboxScenes = null;
	this.mSceneIndex = 0;
}



// Prototypal Inheritance.

GammaCorrectionScene.prototype = new BaseScene();
GammaCorrectionScene.prototype.constructor = GammaCorrectionScene;



// Implementation.

GammaCorrectionScene.prototype.Start = function ()
{
	// Setup members and default values
	this.mShader = new Array();
	this.mCanvas = document.getElementById("Canvas");
	
	// Set the FBO dimensions to match with the window
	this.mFboDimension = new Point(this.mCanvas.width, this.mCanvas.height);
	
	
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
	
	
	// Construct the scene to be rendered
	this.mEntity = GammaCorrectionSceneGen.Create();
	
	// Construct the surface used to for post-processing images
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.Create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.objectEntity = rectVbo;
	this.mSurface.objectMaterial.Texture = new Array();
	this.mSurface.objectMaterial.Texture.push(this.mFboColourColourBuffer.TextureObject);

	
	// Prepare resources to download
	// The basic shader is responsible for rendering the scene with lights, colours, and textures
	this.mResource.Add(new ResourceItem("basic.vs", null, "./shaders/basic.vs"));
	this.mResource.Add(new ResourceItem("basic.fs", null, "./shaders/basic.fs"));
	
	// The image shader is responsible for rendering textures onto the screen.
	this.mResource.Add(new ResourceItem("image.vs", null, "./shaders/image.vs"));
	this.mResource.Add(new ResourceItem("image.fs", null, "./shaders/image.fs"));
	
	// Brightness / contrast / gamma correction shader
	this.mResource.Add(new ResourceItem("brightness.fs", null, "./shaders/brightness.fs"));
	
	
	// Textures used in the scene
	this.mResource.Add(new ResourceItem("white.png", null, "./images/white.png"));
	this.mResource.Add(new ResourceItem("brick.jpg", null, "./images/brick.jpg"));
	this.mResource.Add(new ResourceItem("checkerboard.png", null, "./images/checkerboard.png"));
	this.mResource.Add(new ResourceItem("gradient_10.png", null, "./images/gradient_10.png"));
	this.mResource.Add(new ResourceItem("gradient_blacks.png", null, "./images/gradient_blacks.png"));
	
	
	// Setup user interface
	var material = this.mEntity[0].objectMaterial;
	
	this.mDivLoading = $("#DivLoading");
	this.mTxtLoadingProgress = $("#TxtLoadingProgress");
	
	// Scene information text
	this.mSceneText.push($("#DivScene1Text"));
	this.mSceneText.push($("#DivScene2Text"));
	this.mSceneText.push($("#DivScene3Text"));
	this.mSceneText.push($("#DivScene4Text"));
	this.mSceneText.push($("#DivScene5Text"));
	
	// Show only the first scene's text. Hide others
	this.mSceneText[0].show();
	for (var i = 1; i < this.mSceneText.length; ++i)
		this.mSceneText[i].hide();
	
	// Red ambient slider configuration
	this.mAmbientRedSlider = $("#OARedSlider");
	this.mAmbientRedSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.1,
		max: 1.0,
		value: material.Ambient.x
	});
	this.mAmbientRedSlider.on("slide", this, this.OnAmbientRedValueChanged);
	this.mAmbientRedSlider.on("slidechange", this, this.OnAmbientRedValueChanged);
	this.mAmbientRedSliderTxt = $("#OARedSliderTxt");
	this.mAmbientRedSliderTxt.text(material.Ambient.x);
	
	// Green ambient slider configuration
	this.mAmbientGreenSlider = $("#OAGreenSlider");
	this.mAmbientGreenSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.1,
		max: 1.0,
		value: material.Ambient.y
	});
	this.mAmbientGreenSlider.on("slide", this, this.OnAmbientGreenValueChanged);
	this.mAmbientGreenSlider.on("slidechange", this, this.OnAmbientGreenValueChanged);
	this.mAmbientGreenSliderTxt = $("#OAGreenSliderTxt");
	this.mAmbientGreenSliderTxt.text(material.Ambient.y);
	
	// Blue ambient slider configuration
	this.mAmbientBlueSlider = $("#OABlueSlider");
	this.mAmbientBlueSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.1,
		max: 1.0,
		value: material.Ambient.z
	});
	this.mAmbientBlueSlider.on("slide", this, this.OnAmbientBlueValueChanged);
	this.mAmbientBlueSlider.on("slidechange", this, this.OnAmbientBlueValueChanged);
	this.mAmbientBlueSliderTxt = $("#OABlueSliderTxt");
	this.mAmbientBlueSliderTxt.text(material.Ambient.z);
	
	// Red diffuse slider configuration
	this.mDiffuseRedSlider = $("#ODRedSlider");
	this.mDiffuseRedSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.1,
		max: 1.0,
		value: material.Diffuse.x
	});
	this.mDiffuseRedSlider.on("slide", this, this.OnDiffuseRedValueChanged);
	this.mDiffuseRedSlider.on("slidechange", this, this.OnDiffuseRedValueChanged);
	this.mDiffuseRedSliderTxt = $("#ODRedSliderTxt");
	this.mDiffuseRedSliderTxt.text(material.Diffuse.x);
	
	// Green diffuse slider configuration
	this.mDiffuseGreenSlider = $("#ODGreenSlider");
	this.mDiffuseGreenSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.1,
		max: 1.0,
		value: material.Diffuse.y
	});
	this.mDiffuseGreenSlider.on("slide", this, this.OnDiffuseGreenValueChanged);
	this.mDiffuseGreenSlider.on("slidechange", this, this.OnDiffuseGreenValueChanged);
	this.mDiffuseGreenSliderTxt = $("#ODGreenSliderTxt");
	this.mDiffuseGreenSliderTxt.text(material.Diffuse.y);
	
	// Blue diffuse slider configuration
	this.mDiffuseBlueSlider = $("#ODBlueSlider");
	this.mDiffuseBlueSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.1,
		max: 1.0,
		value: material.Diffuse.z
	});
	this.mDiffuseBlueSlider.on("slide", this, this.OnDiffuseBlueValueChanged);
	this.mDiffuseBlueSlider.on("slidechange", this, this.OnDiffuseBlueValueChanged);
	this.mDiffuseBlueSliderTxt = $("#ODBlueSliderTxt");
	this.mDiffuseBlueSliderTxt.text(material.Diffuse.z);
	
	// Light intensity slider configuration
	this.mIntensitySlider = $("#IntensityValueSlider");
	this.mIntensitySlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		range: "min",
		step: 0.1,
		min: 0.0,
		max: 4.0,
		value: material.Shininess
	});
	this.mIntensitySlider.on("slide", this, this.OnIntensityValueChanged);
	this.mIntensitySlider.on("slidechange", this, this.OnIntensityValueChanged);
	this.mIntensitySliderTxt = $("#IntensityValueSliderTxt");
	this.mIntensitySliderTxt.text(material.Shininess);
	
	// Gamma slider configuration
	this.mBtnEnableGamma = $("#BtnEnableGamma");
	this.mBtnEnableGamma.change(this, this.OnGammaEnabledChanged);
	
	this.mGammaSlider = $("#GammaSlider");
	this.mGammaSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		step: 0.1,
		min: 0.1,
		max: 4.0,
		value: 2.2
	});
	this.mGammaSlider.on("slide", this, this.OnGammaValueChanged);
	this.mGammaSlider.on("slidechange", this, this.OnGammaValueChanged);
	this.mGammaSliderTxt = $("#GammaSliderTxt");
	this.mGammaSliderTxt.text(this.mGammaSlider.slider("value"));
	
	// Brightness slider configuration
	this.mBrightnessSlider = $("#BrightnessValueSlider");
	this.mBrightnessSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		step: 0.1,
		min: -1.0,
		max: 1.0,
		value: 0.0
	});
	this.mBrightnessSlider.on("slide", this, this.OnBrightnessValueChanged);
	this.mBrightnessSlider.on("slidechange", this, this.OnBrightnessValueChanged);
	this.mBrightnessSliderTxt = $("#BrightnessValueSliderTxt");
	this.mBrightnessSliderTxt.text(this.mBrightnessSlider.slider("value"));
	
	// Contrast slider configuration
	this.mContrastSlider = $("#ContrastValueSlider");
	this.mContrastSlider.slider(
	{
		animate: true,
		orientation: "horizontal",
		step: 0.1,
		min: 0.0,
		max: 2.0,
		value: 1.0
	});
	this.mContrastSlider.on("slide", this, this.OnContrastValueChanged);
	this.mContrastSlider.on("slidechange", this, this.OnContrastValueChanged);
	this.mContrastSliderTxt = $("#ContrastValueSliderTxt");
	this.mBrightnessSliderTxt.text(this.mContrastSlider.slider("value"));
	
	// Scenes / Steps combo box
	this.mCboxScenes = $("#CboxScenes");
	this.mCboxScenes.change(this, this.OnSceneChanged);
	
	
	// Start downloading resources
	BaseScene.prototype.Start.call(this);
}



// Method called when the red component ambient slider has changed.

GammaCorrectionScene.prototype.OnAmbientRedValueChanged = function (event, ui)
{
	event.data.mEntity[0].objectMaterial.Ambient.x = ui.value;
	event.data.mAmbientRedSliderTxt.text(ui.value);
}



// Method called when the green component ambient slider has changed.

GammaCorrectionScene.prototype.OnAmbientGreenValueChanged = function (event, ui)
{
	event.data.mEntity[0].objectMaterial.Ambient.y = ui.value;
	event.data.mAmbientGreenSliderTxt.text(ui.value);
}



// Method called when the blue component ambient slider has changed.

GammaCorrectionScene.prototype.OnAmbientBlueValueChanged = function (event, ui)
{
	event.data.mEntity[0].objectMaterial.Ambient.z = ui.value;
	event.data.mAmbientBlueSliderTxt.text(ui.value);
}



// Method called when the red component diffuse slider has changed.

GammaCorrectionScene.prototype.OnDiffuseRedValueChanged = function (event, ui)
{
	event.data.mEntity[0].objectMaterial.Diffuse.x = ui.value;
	event.data.mDiffuseRedSliderTxt.text(ui.value);
}



// Method called when the green component diffuse slider has changed.

GammaCorrectionScene.prototype.OnDiffuseGreenValueChanged = function (event, ui)
{
	event.data.mEntity[0].objectMaterial.Diffuse.y = ui.value;
	event.data.mDiffuseGreenSliderTxt.text(ui.value);
}



// Method called when the blue component diffuse slider has changed.

GammaCorrectionScene.prototype.OnDiffuseBlueValueChanged = function (event, ui)
{
	event.data.mEntity[0].objectMaterial.Diffuse.z = ui.value;
	event.data.mDiffuseBlueSliderTxt.text(ui.value);
}



// Method called when the shininess slider has changed.

GammaCorrectionScene.prototype.OnIntensityValueChanged = function (event, ui)
{
	event.data.mBasicShader.LightObject[0].Colour.x = ui.value;
	event.data.mBasicShader.LightObject[0].Colour.y = ui.value;
	event.data.mBasicShader.LightObject[0].Colour.z = ui.value;
	event.data.mIntensitySliderTxt.text(ui.value);
}



// Method called when the enable gamma checkbox has changed.

GammaCorrectionScene.prototype.OnGammaEnabledChanged = function (event)
{
	event.data.mIsGammaEnabled = this.checked;
	
	if ( this.checked )
	{
		if ( event.data.mSceneIndex > 2 )
			event.data.mBasicShader.Gamma = event.data.mGammaSlider.slider("value");
		
		if ( event.data.mSceneIndex == 1 )
			event.data.mBrightnessShader.GammaCutoff = 0.5;
		else if ( event.data.mSceneIndex != 4 )
			event.data.mBrightnessShader.GammaCutoff = 1.0;
	}
	else
	{
		event.data.mBasicShader.Gamma = 1.0;
		event.data.mBrightnessShader.GammaCutoff = 0.0;
	}
}



// Method called when the gamma slider has changed.

GammaCorrectionScene.prototype.OnGammaValueChanged = function (event, ui)
{
	// Important! The gamma slider represents the monitor's gamma setting.
	// To correct for this, we must apply the _inverse_ gamma value to the
	// image. The end result is a linear output, which is what we want.
	event.data.mBrightnessShader.InvGamma = 1.0 / ui.value;
	event.data.mGammaSliderTxt.text(ui.value);
	
	// Adjust the gamma in the basic shader to "uncorrect" the texture. This is step 3.
	if ( (event.data.mSceneIndex == 3) && event.data.mIsGammaEnabled )
		event.data.mBasicShader.Gamma = ui.value;
}



// Method called when the brightness slider has changed.

GammaCorrectionScene.prototype.OnBrightnessValueChanged = function (event, ui)
{
	event.data.mBrightnessShader.Brightness = ui.value;
	event.data.mBrightnessSliderTxt.text(ui.value);
}



// Method called when the contrast slider has changed.

GammaCorrectionScene.prototype.OnContrastValueChanged = function (event, ui)
{
	event.data.mBrightnessShader.Contrast = ui.value;
	event.data.mContrastSliderTxt.text(ui.value);
}



// Method called when the user selected a new scene / step.

GammaCorrectionScene.prototype.OnSceneChanged = function (event)
{
	event.data.mSceneIndex = event.target.selectedIndex;
	
	// Show the proper scene text at the top of the webgl canvas
	for (var i = 0; i < event.data.mSceneText.length; ++i)
		event.data.mSceneText[i].hide();
	event.data.mSceneText[event.data.mSceneIndex].show();
	
	// Reenable gamma when switching scenes
	if ( !event.data.mIsGammaEnabled )
	{
		event.data.mIsGammaEnabled = true;
		event.data.mBtnEnableGamma.prop("checked", true);
	}

	// Handle special logic depending on the selected scene / step.
	event.data.mBasicShader.Gamma = 1.0;
	event.data.mBrightnessShader.GammaCutoff = 1.0;
	
	if ( event.data.mSceneIndex == 0 )
	{
		// Set the sphere to use the white texture
		event.data.mEntity[0].objectMaterial.Texture[0] = event.data.mTexture[1];
	}
	else
	{
		if ( event.data.mSceneIndex == 1 )
		{
			// For the texture compare scene, show half with gamma correction and
			// the other half without.
			event.data.mBrightnessShader.GammaCutoff = 0.5;
		}
		else if ( (event.data.mSceneIndex == 3) && event.data.mIsGammaEnabled )
		{
			// For the textured sphere scene, apply gamma to the texture to "uncorrect" it.
			event.data.mBasicShader.Gamma = event.data.mGammaSlider.slider("value");
		}
		else if ( event.data.mSceneIndex == 4 )
		{
			// Disable gamma correction for the calibration screen.
			event.data.mBrightnessShader.GammaCutoff = 0.0;
		}
		
		// Set the sphere to use the colour texture
		event.data.mEntity[0].objectMaterial.Texture[0] = event.data.mTexture[0];
	}
}



// Implementation.

GammaCorrectionScene.prototype.Update = function ()
{
	BaseScene.prototype.Update.call(this);
	
	// Draw only when all resources have been loaded
	if ( this.mLoadComplete )
	{
		// For the calibration screen, show a black background to make it easier to distinguish
		// changes.
		if ( this.mSceneIndex == 4 )
			gl.clearColor(0, 0, 0, 1);
		else
			gl.clearColor(1, 1, 1, 1);
	
	
		//
		// Step 1: Render the scene as normal to texture
		//
		this.mFboColour.Enable();
		gl.viewport(0, 0, this.mFboColour.GetFrameWidth(), this.mFboColour.GetFrameHeight());
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		// Draw the correct objects based on the selected scene / step
		if ( this.mSceneIndex == 1 )
		{
			// Compare corrected vs uncorrected textures
			this.mImageShader.Enable();
				this.mImageShader.Draw(this.mEntity[2]);
			this.mImageShader.Disable();
		}
		else if ( this.mSceneIndex < 4 )
		{
			// Draw sphere and room
			this.mBasicShader.Enable();
				for (var i = 0; i < 2; ++i)
					this.mBasicShader.Draw(this.mEntity[i]);
			this.mBasicShader.Disable();
		}
		else
		{
			// Display calibration scene
			this.mImageShader.Enable();
				for (var i = 3; i < this.mEntity.length; ++i)
					this.mImageShader.Draw(this.mEntity[i]);
			this.mImageShader.Disable();
		}

		// Stop rendering to texture
		this.mFboColour.Disable();
			
			
		// Restore viewport
		gl.viewport(0, 0, this.mCanvas.width, this.mCanvas.height);
		
		
		//
		// Step 2: Alter brightness, contrast, and gamma
		//	
		this.mBrightnessShader.Enable();
			gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
				
			// Render flat surface
			this.mBrightnessShader.Draw(this.mSurface);
		this.mBrightnessShader.Disable();
	}
}



// Implementation.

GammaCorrectionScene.prototype.End = function ()
{
	BaseScene.prototype.End.call(this);

	// Cleanup
	if ( this.mFboColour != null )
		this.mFboColour.Release();
	
	if ( this.mFboColourColourBuffer != null )
		this.mFboColourColourBuffer.TextureObject.Release();
	
	if ( this.mSurface != null )
		this.mSurface.objectEntity.Release();

	// Release shader programs		
	if ( this.mBasicShader != null )
		this.mBasicShader.Release();
		
	if ( this.mImageShader != null )
		this.mImageShader.Release();
	
	if ( this.mBrightnessShader != null )
		this.mBrightnessShader.Release();
		
	// Release textures
	if ( this.mTexture != null )
	{
		for (var i = 0; i < this.mTexture.length; ++i)
			this.mTexture[i].Release();
	}
}



// This method is called when an item for the scene has downloaded. it
// will increment the resource counter and dispatch an OnLoadComplete
// event once all items have been downloaded.

GammaCorrectionScene.prototype.OnItemLoaded = function (sender, response)
{
	BaseScene.prototype.OnItemLoaded.call(this, sender, response);
	
	if ( this.mTxtLoadingProgress != null )
		this.mTxtLoadingProgress.html(Math.floor((this.mResourceCount / this.mResource.Item.length) * 100.0));
}



// This method is called to compile a bunch of shaders. The browser will be
// blocked while the GPU compiles, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).

GammaCorrectionScene.prototype.CompileShaders = function (index, list)
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



// This method is called to load a bunch of shaders. The browser will be
// blocked while the GPU loads, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).

GammaCorrectionScene.prototype.LoadShaders = function (index)
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
		
		// Add light sources
		var light1 = new Light();
		light1.Position.setPoint(2.0, 2.0, 2.0);
		light1.Attenuation.z = 0.01;
		this.mBasicShader.LightObject.push(light1);
	}
	else if ( index == 1 )
	{
		// Create standard render FBO texture program
		this.mImageShader = new ImageShader();
		this.mImageShader.Create();
		this.mImageShader.AddShader(this.mShader[2]);	// image.vs
		this.mImageShader.AddShader(this.mShader[3]);	// image.fs
		this.mImageShader.Link();
		this.mImageShader.Init();
		
		// Initialize shader
		this.mImageShader.Projection = new Matrix(4, 4);
		this.mImageShader.View = new Matrix(4, 4);
	}
	else if ( index == 2 )
	{
		// Create brightness shader program
		this.mBrightnessShader = new BrightnessShader();
		this.mBrightnessShader.Create();
		this.mBrightnessShader.AddShader(this.mShader[2]);	// image.vs
		this.mBrightnessShader.AddShader(this.mShader[4]);	// brightness.fs
		this.mBrightnessShader.Link();
		this.mBrightnessShader.Init();
		this.mBrightnessShader.InvGamma = 1.0 / 2.2;
		this.mBrightnessShader.GammaCutoff = 1.0;
		
		// Hide loading screen
		if ( this.mDivLoading != null )
			this.mDivLoading.hide();
		
		this.mLoadComplete = true;
	}
	
	if ( !this.mLoadComplete )
	{
		// Update loading progress
		++index;
	
		// Move on
		var parent = this;
		setTimeout(function () { parent.LoadShaders(index) }, 1);
	}
}



// Implementation.

GammaCorrectionScene.prototype.OnLoadComplete = function ()
{
	// Process shaders
	var shaderResource = new Array();
	shaderResource.push(this.mResource.Find("basic.vs"));
	shaderResource.push(this.mResource.Find("basic.fs"));
	shaderResource.push(this.mResource.Find("image.vs"));
	shaderResource.push(this.mResource.Find("image.fs"));
	shaderResource.push(this.mResource.Find("brightness.fs"));
	
	// Process textures
	this.mTexture.push(this.mResource.Find("brick.jpg"));			// 24 bpp
	this.mTexture.push(this.mResource.Find("white.png"));			// 8 bpp
	this.mTexture.push(this.mResource.Find("checkerboard.png"));	// 8 bpp
	this.mTexture.push(this.mResource.Find("gradient_10.png"));		// 8 bpp
	this.mTexture.push(this.mResource.Find("gradient_blacks.png"));	// 8 bpp
	
	for (var i = 0; i < this.mTexture.length; ++i)
	{
		var resource = this.mTexture[i];
		if ( resource != null )
		{
			var texture = new GLTexture2D();
			if ( i == 0 )
				texture.Create(resource.Item.width, resource.Item.height, Texture.Format.RGB, SamplerState.LinearClamp, resource.Item);
			else
				texture.Create(resource.Item.width, resource.Item.height, Texture.Format.Alpha8, SamplerState.PointClamp, resource.Item);
				
			this.mTexture[i] = texture;
		}
	}
	
	// Assign textures
	
	// Assign the default "white" texture to all objects (necessary to avoid problems in the basic fragment shader)
	for (var i = 0; i < this.mEntity.length; ++i)
	{
		this.mEntity[i].objectMaterial.Texture = new Array();
		this.mEntity[i].objectMaterial.Texture.push(this.mTexture[1]);
	}
	
	// Brick
	this.mEntity[2].objectMaterial.Texture[0] = this.mTexture[0];
	
	// Checkerboard
	this.mEntity[1].objectMaterial.Texture[0] = this.mTexture[2];
	
	// Calibration
	this.mEntity[3].objectMaterial.Texture[0] = this.mTexture[3];
	this.mEntity[4].objectMaterial.Texture[0] = this.mTexture[4];
	
	
	// Setup camera matrices
	this.mProjectionMatrix = ViewMatrix.Perspective(60.0, 1.333, 1.0, 30.0);
	this.mViewMatrix.PointAt(new Point(0.0, 1.0, 5.0),
							 new Point());
	this.mInvViewMatrix = this.mViewMatrix.Inverse();
	
	// Compile shaders
	this.CompileShaders(0, shaderResource);
}