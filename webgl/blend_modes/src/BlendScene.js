
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




// This scene demonstrates the various blending operations by manually calculating the
// blending inside a shader. This is useful when you need to expand on OpenGL's minimal
// set of blending operations.




// Global variable that identifies the number of blending operations available.

var NUM_BLEND_MODES = 18;



// Constructor.

function BlendScene ()
{
	
	// Setup inherited members.
	
	BaseScene.call(this);
	
	
	
	// Shaders for performing blend operations on two textures.
	// [0] = Add, [1] = Subtract, [2] = Multiply, etc...
	
	this.mShader = null;
	
	
	
	// Surface (rectangle) containing the textures to blend. It is designed to
	// fit the size of the viewport.
	
	this.mSurface = null;
	
	
	
	// Stores the textures used by this scene.
	
	this.mTexture = new Array();
	
	
	
	// Gets or sets the current blend mode. Set default to additive.
	
	this.mSelectedBlendMode = NUM_BLEND_MODES + 1;
	
	
	
	// UI members.
	
	this.mDivLoading = null;
	this.mTxtLoadingProgress = null;
	
	this.mBlendAmountSlider = null;
	this.mBlendAmountSliderTxt = null;
	
	this.mColourSlider = null;
	
	this.mCBoxSource = null;
	this.mCBoxDestination = null;
	this.mCBoxBlendMode = null;
}



// Prototypal Inheritance.

BlendScene.prototype = new BaseScene();
BlendScene.prototype.constructor = BlendScene;



// Implementation.

BlendScene.prototype.Start = function ()
{
	// Setup members and default values
	this.mShader = new Array();
	
	// Construct the surface used to for post-processing images
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.Create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.objectEntity = rectVbo;
	this.mSurface.objectMatrix = new Matrix(4, 4);
	this.mSurface.objectMaterial.Texture = new Array();
	this.mSurface.objectMaterial.Texture.push(null);	// Destination texture
	this.mSurface.objectMaterial.Texture.push(null);	// Source texture

	
	// Prepare resources to download
	// The blend shader is responsible for blending two textures.
	this.mResource.Add(new ResourceItem("image.vs", null, "./shaders/image.vs"));
	this.mResource.Add(new ResourceItem("blend.fs", null, "./shaders/blend.fs"));
	
	
	// Textures used in the scene
	this.mResource.Add(new ResourceItem("white.png", null, "./images/white.png")); // White texture can be tinted to different colours
	this.mResource.Add(new ResourceItem("rcmp.jpg", null, "./images/rcmp.jpg"));
	this.mResource.Add(new ResourceItem("awesome_face.png", null, "./images/awesome_face.png"));
	
	
	// Setup user interface
	this.mDivLoading = $("#DivLoading");
	this.mTxtLoadingProgress = $("#TxtLoadingProgress");
	
	// Sliders
	var sliders = ["#SrcRedSlider", this.OnSrcRedSliderChanged,
				   "#SrcGreenSlider", this.OnSrcGreenSliderChanged,
				   "#SrcBlueSlider", this.OnSrcBlueSliderChanged,
				   "#DstRedSlider", this.OnDstRedSliderChanged,
				   "#DstGreenSlider", this.OnDstGreenSliderChanged,
				   "#DstBlueSlider", this.OnDstBlueSliderChanged];
	this.mColourSlider = new Array();
	for (var i = 0; i < sliders.length; i += 2)
	{
		var sliderCtrl = $(sliders[i]);
		sliderCtrl.slider(
		{
			animate: true,
			orientation: "horizontal",
			range: "min",
			step: 0.01,
			min: 0.0,
			max: 1.0,
			value: 1.0
		});
		sliderCtrl.on("slide", this, sliders[i + 1]);
		sliderCtrl.on("slidechange", this, sliders[i + 1]);
		var sliderCtrlTxt = $(sliders[i] + "Txt");
		sliderCtrlTxt.text(sliderCtrl.slider("value"));
		
		// Store controls in array
		this.mColourSlider.push(sliderCtrl);
		this.mColourSlider.push(sliderCtrlTxt);
	}
	
	// Source texture combobox
	this.mCBoxSource = $("#CBoxSource");
	this.mCBoxSource.on("change", this, this.OnSourceChanged);
	
	// Destination texture combobox
	this.mCBoxDestination = $("#CBoxDestination");
	this.mCBoxDestination.on("change", this, this.OnDestinationChanged);
	
	// Blend modes
	this.mCBoxBlendMode = $("#CBoxBlendMode");
	this.mCBoxBlendMode.on("change", this, this.OnBlendModeChanged);
	
	
	// Start downloading resources
	BaseScene.prototype.Start.call(this);
}



// Methods called when the source colour slider values changed.

BlendScene.prototype.OnSrcRedSliderChanged = function (event, ui)
{
	BlendShader.SrcColour.x = ui.value;
	event.data.mColourSlider[1].text(ui.value);
}

BlendScene.prototype.OnSrcGreenSliderChanged = function (event, ui)
{
	BlendShader.SrcColour.y = ui.value;
	event.data.mColourSlider[3].text(ui.value);
}

BlendScene.prototype.OnSrcBlueSliderChanged = function (event, ui)
{
	BlendShader.SrcColour.z = ui.value;
	event.data.mColourSlider[5].text(ui.value);
}



// Methods called when the destination colour slider values changed.

BlendScene.prototype.OnDstRedSliderChanged = function (event, ui)
{
	BlendShader.DstColour.x = ui.value;
	event.data.mColourSlider[7].text(ui.value);
}

BlendScene.prototype.OnDstGreenSliderChanged = function (event, ui)
{
	BlendShader.DstColour.y = ui.value;
	event.data.mColourSlider[9].text(ui.value);
}

BlendScene.prototype.OnDstBlueSliderChanged = function (event, ui)
{
	BlendShader.DstColour.z = ui.value;
	event.data.mColourSlider[11].text(ui.value);
}



// Method called when the source texture has changed.

BlendScene.prototype.OnSourceChanged = function (event)
{
	var selectedIndex = event.currentTarget.selectedIndex;
	event.data.mSurface.objectMaterial.Texture[1] = event.data.mTexture[selectedIndex];
}



// Method called when the destination texture has changed.

BlendScene.prototype.OnDestinationChanged = function (event)
{
	var selectedIndex = event.currentTarget.selectedIndex;
	event.data.mSurface.objectMaterial.Texture[0] = event.data.mTexture[selectedIndex];
}



// Method called when the blend mode has changed.

BlendScene.prototype.OnBlendModeChanged = function (event)
{
	event.data.mSelectedBlendMode = event.currentTarget.selectedIndex + NUM_BLEND_MODES + 1;
}



// Implementation.

BlendScene.prototype.Update = function ()
{
	BaseScene.prototype.Update.call(this);
	
	// Draw only when all resources have been loaded
	if ( this.mLoadComplete )
	{
		//
		// Render both textures to an orthographic view for blending.
		//
		this.mShader[this.mSelectedBlendMode].Enable();
			this.mShader[this.mSelectedBlendMode].Draw(this.mSurface);
		this.mShader[this.mSelectedBlendMode].Disable();
	}
}



// Implementation.

BlendScene.prototype.End = function ()
{
	BaseScene.prototype.End.call(this);

	// Cleanup
	
	// Release VBOs
	if ( this.mSurface != null )
		this.mSurface.objectEntity.Release();
		
	// Release textures
	if ( this.mTexture != null )
	{
		for (var i = 0; i < this.mTexture.length; ++i)
			this.mTexture[i].Release();
	}
}



// Implementation.

BlendScene.prototype.OnItemLoaded = function (sender, response)
{
	BaseScene.prototype.OnItemLoaded.call(this, sender, response);
	
	if ( this.mTxtLoadingProgress != null )
		this.mTxtLoadingProgress.html(Math.floor((this.mResourceCount / (this.mResource.Item.length + NUM_BLEND_MODES)) * 100.0));
}



// This method is called to compile a bunch of shaders. The browser will be
// blocked while the GPU compiles, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).

BlendScene.prototype.CompileShaders = function (index, list, blendModes)
{
	var shaderItem = list[index];
	if ( shaderItem != null )
	{
		var shaderCode = shaderItem.Item;
		if ( index > 0 )
			shaderCode = shaderCode.replace("{BLEND_MODE}", blendModes[index - 1]);
	
		// Compile vertex shader
		var shader = new GLShader();
		if ( !shader.Create((shaderItem.Name.lastIndexOf(".vs") != -1) ? shader.ShaderType.Vertex : shader.ShaderType.Fragment, shaderCode) )
		{
			var blendMode = (index > 0) ? (" (" + blendModes[index - 1] + ")") : "";
		
			// Report error
			var log = shader.GetLog();
			alert("Error compiling " + shaderItem.Name + blendMode + ".\n\n" + log);
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
		setTimeout(function () { parent.CompileShaders(index, list, blendModes) }, 1);
	}
	else if ( index == list.length )
	{
		// Now start loading in the shaders
		this.LoadShaders(0, blendModes);
	}
}



// This method is called to load a bunch of shaders. The browser will be
// blocked while the GPU loads, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).

BlendScene.prototype.LoadShaders = function (index, blendModes)
{
	// Compile blend shaders
	var blendShader = new BlendShader();
	blendShader.Create();
	blendShader.AddShader(this.mShader[0]);			// image.vs
	blendShader.AddShader(this.mShader[index + 1]);	// blend.fs
	blendShader.Link();
	blendShader.Init();
	this.mShader.push(blendShader);
	
	// Hide loading screen
	if ( index == (blendModes.length - 1) )
	{
		if ( this.mDivLoading != null )
			this.mDivLoading.hide();
		
		this.mLoadComplete = true;
	}
	
	if ( !this.mLoadComplete )
	{
		// Update loading progress
		++index;
		if ( this.mTxtLoadingProgress != null )
			this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount + index) / (this.mResource.Item.length + blendModes.length)) * 100.0));
	
		// Move on
		var parent = this;
		setTimeout(function () { parent.LoadShaders(index, blendModes) }, 1);
	}
}



// Implementation.

BlendScene.prototype.OnLoadComplete = function ()
{
	// Recompile the blend.fs [uber] shader for each blend mode
	// The items in this array will eventually replace #define {BLEND_MODE}
	// in the file blend.fs with the blend mode we wish to compile.
	var blendModes = new Array();
	$("#CBoxBlendMode option").each( function(i)
		{
			blendModes.push(this.text.toUpperCase().replace(" ", "_"));
		});

	// Process shaders
	var shaderResource = new Array();
	shaderResource.push(this.mResource.Find("image.vs"));
	var blendShader = this.mResource.Find("blend.fs");
	for (var i = 0; i < blendModes.length; ++i)
		shaderResource.push(blendShader);
	
	// Process textures
	this.mTexture = new Array();
	this.mTexture.push(this.mResource.Find("white.png"));
	this.mTexture.push(this.mResource.Find("rcmp.jpg"));
	this.mTexture.push(this.mResource.Find("awesome_face.png"));
	
	for (var i = 0; i < this.mTexture.length; ++i)
	{
		var resource = this.mTexture[i];
		if ( resource != null )
		{
			this.mTexture[i] = new GLTexture2D();
			this.mTexture[i].Create(resource.Item.width, resource.Item.height, (i == 2) ? Texture.Format.Rgba : Texture.Format.Rgb, SamplerState.LinearClamp, resource.Item);
		}
	}
	
	// Assign textures
	this.mSurface.objectMaterial.Texture[0] = this.mTexture[1];
	this.mSurface.objectMaterial.Texture[1] = this.mTexture[1];

	
	// Compile shaders
	this.CompileShaders(0, shaderResource, blendModes);
}