// This scene demonstrates the various blending operations by manually calculating the
// blending inside a shader. This is useful when you need to expand on OpenGL's minimal
// set of blending operations.

// Global variable that identifies the number of blending operations available.
var NUM_BLEND_MODES = 18;

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
	this.mTexture = [];
	
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
BlendScene.prototype.start = function ()
{
	// Setup members and default values
	this.mShader = [];
	
	// Construct the surface used to for post-processing images
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.objectEntity = rectVbo;
	this.mSurface.objectMatrix = new Matrix(4, 4);
	this.mSurface.objectMaterial.texture = [];
	this.mSurface.objectMaterial.texture.push(null);	// Destination texture
	this.mSurface.objectMaterial.texture.push(null);	// Source texture

	
	// Prepare resources to download
	// The blend shader is responsible for blending two textures.
	this.mResource.add(new ResourceItem("image.vs", null, "./shaders/image.vs"));
	this.mResource.add(new ResourceItem("blend.fs", null, "./shaders/blend.fs"));
	
	
	// Textures used in the scene
	this.mResource.add(new ResourceItem("white.png", null, "./images/white.png")); // White texture can be tinted to different colours
	this.mResource.add(new ResourceItem("rcmp.jpg", null, "./images/rcmp.jpg"));
	this.mResource.add(new ResourceItem("awesome_face.png", null, "./images/awesome_face.png"));
	
	
	// Setup user interface
	this.mDivLoading = $("#DivLoading");
	this.mTxtLoadingProgress = $("#TxtLoadingProgress");
	
	// Sliders
	var sliders = ["#SrcRedSlider", this.onSrcRedSliderChanged,
				   "#SrcGreenSlider", this.onSrcGreenSliderChanged,
				   "#SrcBlueSlider", this.onSrcBlueSliderChanged,
				   "#DstRedSlider", this.onDstRedSliderChanged,
				   "#DstGreenSlider", this.onDstGreenSliderChanged,
				   "#DstBlueSlider", this.onDstBlueSliderChanged];
	this.mColourSlider = [];
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
	this.mCBoxSource.on("change", this, this.onSourceChanged);
	
	// Destination texture combobox
	this.mCBoxDestination = $("#CBoxDestination");
	this.mCBoxDestination.on("change", this, this.onDestinationChanged);
	
	// Blend modes
	this.mCBoxBlendMode = $("#CBoxBlendMode");
	this.mCBoxBlendMode.on("change", this, this.onBlendModeChanged);
	
	
	// Start downloading resources
	BaseScene.prototype.start.call(this);
}

// Methods called when the source colour slider values changed.
BlendScene.prototype.onSrcRedSliderChanged = function (event, ui)
{
	BlendShader.srcColour.x = ui.value;
	event.data.mColourSlider[1].text(ui.value);
}

BlendScene.prototype.onSrcGreenSliderChanged = function (event, ui)
{
	BlendShader.srcColour.y = ui.value;
	event.data.mColourSlider[3].text(ui.value);
}

BlendScene.prototype.onSrcBlueSliderChanged = function (event, ui)
{
	BlendShader.srcColour.z = ui.value;
	event.data.mColourSlider[5].text(ui.value);
}

// Methods called when the destination colour slider values changed.
BlendScene.prototype.onDstRedSliderChanged = function (event, ui)
{
	BlendShader.dstColour.x = ui.value;
	event.data.mColourSlider[7].text(ui.value);
}

BlendScene.prototype.onDstGreenSliderChanged = function (event, ui)
{
	BlendShader.dstColour.y = ui.value;
	event.data.mColourSlider[9].text(ui.value);
}

BlendScene.prototype.onDstBlueSliderChanged = function (event, ui)
{
	BlendShader.dstColour.z = ui.value;
	event.data.mColourSlider[11].text(ui.value);
}



// Method called when the source texture has changed.

BlendScene.prototype.onSourceChanged = function (event)
{
	var selectedIndex = event.currentTarget.selectedIndex;
	event.data.mSurface.objectMaterial.texture[1] = event.data.mTexture[selectedIndex];
}



// Method called when the destination texture has changed.

BlendScene.prototype.onDestinationChanged = function (event)
{
	var selectedIndex = event.currentTarget.selectedIndex;
	event.data.mSurface.objectMaterial.texture[0] = event.data.mTexture[selectedIndex];
}



// Method called when the blend mode has changed.

BlendScene.prototype.onBlendModeChanged = function (event)
{
	event.data.mSelectedBlendMode = event.currentTarget.selectedIndex + NUM_BLEND_MODES + 1;
}



// Implementation.

BlendScene.prototype.update = function ()
{
	BaseScene.prototype.update.call(this);
	
	// Draw only when all resources have been loaded
	if ( this.mLoadComplete )
	{
		//
		// Render both textures to an orthographic view for blending.
		//
		this.mShader[this.mSelectedBlendMode].enable();
			this.mShader[this.mSelectedBlendMode].draw(this.mSurface);
		this.mShader[this.mSelectedBlendMode].disable();
	}
}



// Implementation.

BlendScene.prototype.end = function ()
{
	BaseScene.prototype.end.call(this);

	// Cleanup
	
	// Release VBOs
	if ( this.mSurface != null )
		this.mSurface.objectEntity.release();
		
	// Release textures
	if ( this.mTexture != null )
	{
		for (var i = 0; i < this.mTexture.length; ++i)
			this.mTexture[i].release();
	}
}



// Implementation.

BlendScene.prototype.onItemLoaded = function (sender, response)
{
	BaseScene.prototype.onItemLoaded.call(this, sender, response);
	
	if ( this.mTxtLoadingProgress != null )
		this.mTxtLoadingProgress.html(Math.floor((this.mResourceCount / (this.mResource.items.length + NUM_BLEND_MODES)) * 100.0));
}



// This method is called to compile a bunch of shaders. The browser will be
// blocked while the GPU compiles, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).

BlendScene.prototype.compileShaders = function (index, list, blendModes)
{
	var shaderItem = list[index];
	if ( shaderItem != null )
	{
		var shaderCode = shaderItem.item;
		if ( index > 0 )
			shaderCode = shaderCode.replace("{BLEND_MODE}", blendModes[index - 1]);
	
		// Compile vertex shader
		var shader = new GLShader();
		if ( !shader.create((shaderItem.name.lastIndexOf(".vs") != -1) ? 
			GLShader.ShaderType.Vertex : 
			GLShader.ShaderType.Fragment, shaderCode) )
		{
			var blendMode = (index > 0) ? (" (" + blendModes[index - 1] + ")") : "";
		
			// Report error
			var log = shader.getLog();
			alert("Error compiling " + shaderItem.name + blendMode + ".\n\n" + log);
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
		setTimeout(function () { parent.compileShaders(index, list, blendModes) }, 1);
	}
	else if ( index == list.length )
	{
		// Now start loading in the shaders
		this.loadShaders(0, blendModes);
	}
}

// This method is called to load a bunch of shaders. The browser will be
// blocked while the GPU loads, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).
BlendScene.prototype.loadShaders = function (index, blendModes)
{
	// Compile blend shaders
	var blendShader = new BlendShader();
	blendShader.create();
	blendShader.addShader(this.mShader[0]);			// image.vs
	blendShader.addShader(this.mShader[index + 1]);	// blend.fs
	blendShader.link();
	blendShader.init();
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
			this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount + index) / (this.mResource.items.length + blendModes.length)) * 100.0));
	
		// Move on
		var parent = this;
		setTimeout(function () { parent.loadShaders(index, blendModes) }, 1);
	}
}

// Implementation.
BlendScene.prototype.onLoadComplete = function ()
{
	// Recompile the blend.fs [uber] shader for each blend mode
	// The items in this array will eventually replace #define {BLEND_MODE}
	// in the file blend.fs with the blend mode we wish to compile.
	var blendModes = [];
	$("#CBoxBlendMode option").each( function(i)
		{
			blendModes.push(this.text.toUpperCase().replace(" ", "_"));
		});

	// Process shaders
	var shaderResource = [];
	shaderResource.push(this.mResource.find("image.vs"));
	var blendShader = this.mResource.find("blend.fs");
	for (var i = 0; i < blendModes.length; ++i)
		shaderResource.push(blendShader);
	
	// Process textures
	this.mTexture = [];
	this.mTexture.push(this.mResource.find("white.png"));
	this.mTexture.push(this.mResource.find("rcmp.jpg"));
	this.mTexture.push(this.mResource.find("awesome_face.png"));
	
	for (var i = 0; i < this.mTexture.length; ++i)
	{
		var resource = this.mTexture[i];
		if ( resource != null )
		{
			this.mTexture[i] = new GLTexture2D();
			this.mTexture[i].create(resource.item.width, resource.item.height, (i == 2) ? Texture.Format.Rgba : Texture.Format.Rgb, SamplerState.LinearClamp, resource.item);
		}
	}
	
	// Assign textures
	this.mSurface.objectMaterial.texture[0] = this.mTexture[1];
	this.mSurface.objectMaterial.texture[1] = this.mTexture[1];

	
	// Compile shaders
	this.compileShaders(0, shaderResource, blendModes);
}