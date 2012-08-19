// This scene demonstrates how to render a depth of field effect. The process is
// as follows.
// 1. Render the scene to a texture.
//
// 2. Render the scene depth values to a texture. This is a separate process in
// OpenGL ES
//    because the depth texture format is not supported, but you could do it in a
// single pass
//    with normal OpenGL.
//
// 3. Load both the scene colour and depth textures into the DOF blur shader.
// This shader will
//    blur the pixels based on their recorded depth values and using the DOF blur
// equation. The
//    further the depth value from the DOF region, the more the pixel is blurred,
// up to some maximum.
//
//    For improved performance and blurring quality, you should blur to a
// resolution smaller
//    then what you use for rendering the scene. 512 x 512 resolution produces a
// nice result.
//
// 4. After rendering the blurred texture, blend the colour texture in step 1
// with the blurred texture
//    produced in step 3. Pixels that are in focus will use the higher resolution
// texture whereas pixels
//    not in focus will sample from the lower resolution and blurred texture.

function DepthOfFieldScene() {
	// Setup inherited members.
	BaseScene.call(this);

	// Stores the current inverse view matrix.
	this.mInvViewMatrix = null;

	// The framebuffer object to store the colour buffer (ie: the result of the
	// rendered scene).
	// This will be fed into the blur shader.
	this.mFboColour = null;

	// The framebuffer object to store the depth map. This will be fed into the
	// blur shader.
	this.mFboDepth = null;

	// The framebuffer object for performing the first pass [horizontal] blur using
	// the
	// separable blur algorithm. On the second pass, the final blurring will be
	// stored
	// into the mFboBlur2 colour target.
	this.mFboBlur = null;
	this.mFboBlur2 = null;

	// Framebuffer objects.
	this.mFboColourColourBuffer = null;
	this.mFboColourDepthBuffer = null;

	this.mFboDepthColourBuffer = null;
	this.mFboDepthDepthBuffer = null;

	this.mFboBlurColourBuffer = null;

	// Gets or sets the dimensions of the FBO, which may or may not be the same size
	// as the window.
	this.mFboDimension = null;
	this.mFboDimensionBlur = null;

	// The basic shader is responsible for rendering the scene as normal. It will
	// produce
	// the colour texture used in the blurring stage.
	this.mBasicShader = null;

	// The depth shader is responsible for rendering the depth values. It will
	// produce the
	// depth texture used in the blurring stage.
	this.mDepthShader = null;

	// The depth image shader is responsible for rendering the depth texture to
	// screen. Useful for
	// debugging or visualization purposes.
	this.mDepthImageShader = null;

	// The shader to blur a texture. It uses the separable blur algorithm, which
	// divides blurring
	// into two passes. The first pass will render a horizontal blur. The second pass
	// will render
	// the vertical blur. This is much faster than using a traditional convolution
	// filter algorithm.
	this.mDofBlurShader = null;

	// The image shader will render the final post-processed texture to screen.
	this.mDofImageShader = null;

	// Surface (rectangle) containing a texture to manipulate or view. Used for
	// blurring and showing
	// the final DOF result. It is designed to fit the size of the viewport.
	this.mSurface = null;

	// Textures.
	this.mTexCheckerBoard = null;
	this.mTexRuler = null;

	// Stores a reference to the canvas DOM element, which is used to reset the
	// viewport
	// back to its original size after rendering to the FBO, which uses a different
	// dimension.
	this.mCanvas = null;

	// UI members.
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

// Prototypal Inheritance.
DepthOfFieldScene.prototype = new BaseScene();
DepthOfFieldScene.prototype.constructor = DepthOfFieldScene;

// Implementation.
DepthOfFieldScene.prototype.start = function() {
	// Setup members and default values
	this.mShader = [];
	this.mCanvas = document.getElementById("webgl_canvas");
	this.mFboDimension = new Point(this.mCanvas.width, this.mCanvas.height);
	this.mFboDimensionBlur = new Point(512, 512);

	// Construct FBO for rendering the colour buffer
	var sampler = new SamplerState(SamplerState.LinearClamp);
	this.mFboColourColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboColourColourBuffer.textureObject = new GLTexture2D();
	this.mFboColourColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);

	this.mFboColourDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboColourDepthBuffer.renderBufferFormat = Texture.Format.Depth16;

	this.mFboColour = new GLFrameBufferObject();
	this.mFboColour.create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboColour.attachBuffer(this.mFboColourColourBuffer);
	this.mFboColour.attachBuffer(this.mFboColourDepthBuffer);

	// Construct FBO for rendering the depth buffer
	this.mFboDepthColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboDepthColourBuffer.textureObject = new GLTexture2D();
	this.mFboDepthColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);

	this.mFboDepthDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboDepthDepthBuffer.renderBufferFormat = Texture.Format.Depth16;

	this.mFboDepth = new GLFrameBufferObject();
	this.mFboDepth.create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboDepth.attachBuffer(this.mFboDepthColourBuffer);
	this.mFboDepth.attachBuffer(this.mFboDepthDepthBuffer);

	// Construct FBO for rendering the horizontal blur
	this.mFboBlurColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboBlurColourBuffer.textureObject = new GLTexture2D();
	this.mFboBlurColourBuffer.textureObject.create(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y, Texture.Format.Rgba, sampler);

	this.mFboBlur = new GLFrameBufferObject();
	this.mFboBlur.create(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y);
	this.mFboBlur.attachBuffer(this.mFboBlurColourBuffer);

	// Construct FBO for rendering the vertical blur
	this.mFboBlur2ColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboBlur2ColourBuffer.textureObject = new GLTexture2D();
	this.mFboBlur2ColourBuffer.textureObject.create(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y, Texture.Format.Rgba, sampler);

	this.mFboBlur2 = new GLFrameBufferObject();
	this.mFboBlur2.create(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y);
	this.mFboBlur2.attachBuffer(this.mFboBlur2ColourBuffer);

	// Construct the scene to be rendered
	this.mEntity = DepthOfFieldSceneGen.create();

	// Construct the surface used to perform the blurring and viewing the
	// post-processed result.
	// It will fit to the dimensions of the viewport.
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.objectEntity = rectVbo;
	this.mSurface.objectMatrix.translate(0.0, 0.0, 1.0);
	this.mSurface.objectMaterial.texture = [];
	this.mSurface.objectMaterial.texture.push(null);
	// First texture = colour buffer, assigned later
	this.mSurface.objectMaterial.texture.push(null);
	// Second texture = depth buffer, assigned later
	//this.mSurface.objectMaterial.texture.push(null); // Third texture = blurred
	// texture, assigned later

	// Prepare resources to download
	// The basic shader is responsible for rendering the scene with lights, colours,
	// and textures
	this.mResource.add(new ResourceItem("basic.vs", null, "./shaders/basic.vs"));
	this.mResource.add(new ResourceItem("basic.fs", null, "./shaders/basic.fs"));

	// The depth shader is responsible for rendering the depth values to texture
	this.mResource.add(new ResourceItem("depth.vs", null, "./shaders/depth.vs"));
	this.mResource.add(new ResourceItem("depth.fs", null, "./shaders/depth.fs"));

	// The following are image or post-processing shaders used in the DOF process.
	// image.vs is shared by all fragment shaders here
	this.mResource.add(new ResourceItem("image.vs", null, "./shaders/image.vs"));
	this.mResource.add(new ResourceItem("depth_image.fs", null, "./shaders/depth_image.fs"));
	this.mResource.add(new ResourceItem("dof_blur.fs", null, "./shaders/dof_blur.fs"));
	this.mResource.add(new ResourceItem("dof_image.fs", null, "./shaders/dof_image.fs"));

	// Textures used in the scene
	this.mResource.add(new ResourceItem("checker_board.png", null, "./images/checker_board.png"));
	this.mResource.add(new ResourceItem("ruler.png", null, "./images/ruler.png"));

	// Setup user interface
	this.mDivLoading = $("#DivLoading");
	this.mTxtLoadingProgress = $("#TxtLoadingProgress");

	this.mFocalLengthSlider = $("#FocalLengthSlider");
	this.mFocalLengthSlider.slider({
		animate : true,
		orientation : "horizontal",
		step : 1.0,
		min : 10.0,
		max : 200,
		value : 100
	});
	this.mFocalLengthSlider.on("slide", {
		owner : this
	}, this.onFocalLengthValueChanged);
	this.mFocalLengthSlider.on("slidechange", {
		owner : this
	}, this.onFocalLengthValueChanged);
	this.mFocalLengthSliderTxt = $("#FocalLengthSliderTxt");
	this.mFocalLengthSliderTxt.text(this.mFocalLengthSlider.slider("value"));

	this.mFocusDistanceSlider = $("#FocusDistanceSlider");
	this.mFocusDistanceSlider.slider({
		animate : true,
		orientation : "horizontal",
		step : 0.1,
		min : 1.0,
		max : 20.0,
		value : 10.0
	});
	this.mFocusDistanceSlider.on("slide", {
		owner : this
	}, this.onFocusDistanceValueChanged);
	this.mFocusDistanceSlider.on("slidechange", {
		owner : this
	}, this.onFocusDistanceValueChanged);
	this.mFocusDistanceSliderTxt = $("#FocusDistanceSliderTxt");
	this.mFocusDistanceSliderTxt.text(this.mFocusDistanceSlider.slider("value"));

	this.mFStopSlider = $("#FStopSlider");
	this.mFStopSlider.slider({
		animate : true,
		orientation : "horizontal",
		step : 0.1,
		min : 1.4,
		max : 16.0,
		value : 1.4
	});
	this.mFStopSlider.on("slide", {
		owner : this
	}, this.onFStopValueChanged);
	this.mFStopSlider.on("slidechange", {
		owner : this
	}, this.onFStopValueChanged);
	this.mFStopSliderTxt = $("#FStopSliderTxt");
	this.mFStopSliderTxt.text(this.mFStopSlider.slider("value"));

	this.mCboxViewState = document.getElementById("CboxViewState");
	this.mCboxViewState.selectedIndex = 0;
	this.mCboxViewState.onchange = this.onViewStateValueChanged.bind(this);

	// start downloading resources
	BaseScene.prototype.start.call(this);
}
// Method called when the focal length slider has changed.
DepthOfFieldScene.prototype.onFocalLengthValueChanged = function(event, ui) {
	event.data.owner.mDofBlurShader.focalLength = ui.value;
	event.data.owner.mDofBlurShader.updateBlurCoefficient();

	event.data.owner.mDofImageShader.focalLength = ui.value;
	event.data.owner.mDofImageShader.updateBlurCoefficient();

	event.data.owner.mFocalLengthSliderTxt.text(ui.value);
}
// Method called when the focus distance slider has changed.
DepthOfFieldScene.prototype.onFocusDistanceValueChanged = function(event, ui) {
	event.data.owner.mDofBlurShader.focusDistance = ui.value;
	event.data.owner.mDofBlurShader.updateBlurCoefficient();

	event.data.owner.mDofImageShader.focusDistance = ui.value;
	event.data.owner.mDofImageShader.updateBlurCoefficient();

	event.data.owner.mFocusDistanceSliderTxt.text(ui.value);
}
// Method called when the f-stop slider has changed.
DepthOfFieldScene.prototype.onFStopValueChanged = function(event, ui) {
	event.data.owner.mDofBlurShader.fStop = ui.value;
	event.data.owner.mDofBlurShader.updateBlurCoefficient();

	event.data.owner.mDofImageShader.fStop = ui.value;
	event.data.owner.mDofImageShader.updateBlurCoefficient();

	event.data.owner.mFStopSliderTxt.text(ui.value);
}
// Method called when the view state combo box value has changed.
DepthOfFieldScene.prototype.onViewStateValueChanged = function(event) {
	this.mViewState = this.mCboxViewState.selectedIndex;
}
// Implementation.
DepthOfFieldScene.prototype.update = function() {
	BaseScene.prototype.update.call(this);

	// draw only when all resources have been loaded
	if (this.mLoadComplete) {
		//
		// Step 1: Render the scene as normal to texture
		//
		this.mBasicShader.enable();
		this.mFboColour.enable();

		gl.viewport(0, 0, this.mFboColour.getFrameWidth(), this.mFboColour.getFrameHeight());
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

		for (var i = 0; i < this.mEntity.length; ++i)
			this.mBasicShader.draw(this.mEntity[i]);

		this.mFboColour.disable();
		this.mBasicShader.disable();

		//
		// Step 2: Render the scene's depth values to texture
		//
		this.mDepthShader.enable();
		this.mFboDepth.enable();

		gl.viewport(0, 0, this.mFboDepth.getFrameWidth(), this.mFboDepth.getFrameHeight());
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

		for (var i = 0; i < this.mEntity.length; ++i)
			this.mDepthShader.draw(this.mEntity[i]);

		this.mFboDepth.disable();
		this.mDepthShader.disable();

		//
		// Step 3: DOF blur the colour in the horizontal and vertical axis using the
		// colour and depth textures prepared in step 1 and 2.
		//
		this.mDofBlurShader.enable();
		gl.viewport(0, 0, this.mFboBlur.getFrameWidth(), this.mFboBlur.getFrameHeight());

		// Render horizontal blur
		this.mFboBlur.enable();
		this.mSurface.objectMaterial.texture[0] = this.mFboColourColourBuffer.textureObject;
		this.mSurface.objectMaterial.texture[1] = this.mFboDepthColourBuffer.textureObject;

		this.mDofBlurShader.draw(this.mSurface, 0);

		// Render vertical blur
		this.mFboBlur2.enable();
		gl.clear(gl.DEPTH_BUFFER_BIT);

		this.mSurface.objectMaterial.texture[0] = this.mFboBlurColourBuffer.textureObject;
		this.mDofBlurShader.draw(this.mSurface, 1);
		this.mFboBlur2.disable();
		this.mDofBlurShader.disable();

		// Restore viewport
		gl.viewport(0, 0, this.mCanvas.width, this.mCanvas.height);

		//
		// Step 4: Render the final result to screen.
		//
		if (this.mViewState == 0) {
			// Post-process final image
			this.mDofImageShader.enable();
			this.mSurface.objectMaterial.texture[0] = this.mFboColourColourBuffer.textureObject;
			this.mSurface.objectMaterial.texture[2] = this.mFboBlur2ColourBuffer.textureObject;
			this.mDofImageShader.draw(this.mSurface);
			this.mDofImageShader.disable();
		} else {
			// Visualize depth map
			this.mDepthImageShader.enable();
			this.mSurface.objectMaterial.texture[0] = this.mFboDepthColourBuffer.textureObject;
			this.mDepthImageShader.draw(this.mSurface);
			this.mDepthImageShader.disable();
		}
	}
}
// Implementation.
DepthOfFieldScene.prototype.end = function() {
	BaseScene.prototype.end.call(this);

	// Cleanup
	if (this.mFboColour != null)
		this.mFboColour.release();

	if (this.mFboColourColourBuffer != null)
		this.mFboColourColourBuffer.textureObject.release();

	if (this.mFboDepth != null)
		this.mFboDepth.release();

	if (this.mFboDepthColourBuffer != null)
		this.mFboDepthColourBuffer.textureObject.release();

	if (this.mFboBlur != null)
		this.mFboBlur.release();

	if (this.mFboBlurColourBuffer != null)
		this.mFboBlurColourBuffer.textureObject.release();

	if (this.mSurface != null)
		this.mSurface.objectEntity.release();

	if (this.mBasicShader)
		this.mBasicShader.release();

	if (this.mDepthShader)
		this.mDepthShader.release();

	if (this.mDofBlurShader)
		this.mDofBlurShader.release();

	if (this.mDofImageShader)
		this.mDofImageShader.release();

	if (this.mDepthImageShader)
		this.mDepthImageShader.release();

	if (this.mTexCheckerBoard)
		this.mTexCheckerBoard.release();

	if (this.mTexRuler)
		this.mTexRuler.release();
}
// This method is called when an item for the scene has downloaded. it
// will increment the resource counter and dispatch an onLoadComplete
// event once all items have been downloaded.

DepthOfFieldScene.prototype.onItemLoaded = function(sender, response) {
	BaseScene.prototype.onItemLoaded.call(this, sender, response);

	if (this.mTxtLoadingProgress != null)
		this.mTxtLoadingProgress.html(Math.floor((this.mResourceCount / (this.mResource.items.length * 2.0 + 6.0)) * 100.0));
}
// This method is called to compile a bunch of shaders. The browser will be
// blocked while the GPU compiles, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).

DepthOfFieldScene.prototype.compileShaders = function(index, list) {
	var shaderItem = list[index];
	if (shaderItem != null) {
		// Compile vertex shader
		var shader = new GLShader();
		if (!shader.create((shaderItem.name.lastIndexOf(".vs") != -1) ? GLShader.ShaderType.Vertex : GLShader.ShaderType.Fragment, shaderItem.item)) {
			// Report error
			var log = shader.getLog();
			alert("Error compiling " + shaderItem.name + ".\n\n" + log);
			return;
		} else
			this.mShader.push(shader);
	} else {
		// Resources missing?
		alert("Missing resources");
		return;
	}

	// update loading progress
	++index;
	if (this.mTxtLoadingProgress != null)
		this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount + index) / (this.mResource.items.length * 2.0 + 4.0)) * 100.0));

	if (index < list.length) {
		// Move on to next shader
		var parent = this;
		setTimeout(function() {
			parent.compileShaders(index, list)
		}, 1);
	} else if (index == list.length) {
		// Now start loading in the shaders
		this.loadShaders(0);
	}
}
// This method is called to load a bunch of shaders. The browser will be
// blocked while the GPU loads, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).

DepthOfFieldScene.prototype.loadShaders = function(index) {
	if (index == 0) {
		// create basic shader program
		this.mBasicShader = new BasicShader();
		this.mBasicShader.projection = this.mProjectionMatrix;
		this.mBasicShader.view = this.mInvViewMatrix;
		this.mBasicShader.create();
		this.mBasicShader.addShader(this.mShader[0]);
		this.mBasicShader.addShader(this.mShader[1]);
		this.mBasicShader.link();
		this.mBasicShader.init();

		// add light sources
		var light1 = new Light();
		light1.lightType = Light.LightSourceType.Point;
		light1.position = new Point(-4.0, 0.0, -4.0);
		light1.attenuation.z = 0.02;
		this.mBasicShader.lightObject.push(light1);

		var light2 = new Light();
		light2.lightType = Light.LightSourceType.Point;
		light2.position = new Point(4.0, 0.0, 4.0);
		light2.attenuation.z = 0.02;
		this.mBasicShader.lightObject.push(light2);
	} else if (index == 1) {
		// create depth map shader program
		this.mDepthShader = new DepthShader();
		this.mDepthShader.projection = this.mProjectionMatrix;
		this.mDepthShader.view = this.mInvViewMatrix;
		this.mDepthShader.create();
		this.mDepthShader.addShader(this.mShader[2]);
		this.mDepthShader.addShader(this.mShader[3]);
		this.mDepthShader.link();
		this.mDepthShader.init();
		this.mDepthShader.near = 1.0;
		this.mDepthShader.far = 25.0;
	} else if (index == 2) {
		// create depth image shader program
		this.mDepthImageShader = new ImageShader();
		this.mDepthImageShader.projection = this.mOrthographicMatrix;
		this.mDepthImageShader.view = new Matrix(4, 4);
		this.mDepthImageShader.create();
		this.mDepthImageShader.addShader(this.mShader[4]);
		this.mDepthImageShader.addShader(this.mShader[5]);
		this.mDepthImageShader.link();
		this.mDepthImageShader.init();
		this.mDepthImageShader.setSize(this.mFboDimension.x, this.mFboDimension.y);
	} else if (index == 3) {
		// create DOF blur shader program
		this.mDofBlurShader = new DofBlurShader();
		this.mDofBlurShader.projection = this.mOrthographicMatrix;
		this.mDofBlurShader.view = new Matrix(4, 4);
		this.mDofBlurShader.create();
		this.mDofBlurShader.addShader(this.mShader[4]);
		this.mDofBlurShader.addShader(this.mShader[6]);
		this.mDofBlurShader.link();
		this.mDofBlurShader.init();
		this.mDofBlurShader.setSize(this.mFboDimensionBlur.x, this.mFboDimensionBlur.y);

		this.mDofBlurShader.near = 1.0;
		this.mDofBlurShader.far = 25.0;
		this.mDofBlurShader.focalLength = this.mFocalLengthSlider.slider("value");
		this.mDofBlurShader.focusDistance = this.mFocusDistanceSlider.slider("value");
		this.mDofBlurShader.fStop = this.mFStopSlider.slider("value");
		this.mDofBlurShader.updateBlurCoefficient();
	} else if (index == 4) {
		// create DOF image shader program
		this.mDofImageShader = new DofImageShader();
		this.mDofImageShader.projection = this.mOrthographicMatrix;
		this.mDofImageShader.view = new Matrix(4, 4);
		this.mDofImageShader.create();
		this.mDofImageShader.addShader(this.mShader[4]);
		this.mDofImageShader.addShader(this.mShader[7]);
		this.mDofImageShader.link();
		this.mDofImageShader.init();
		this.mDofImageShader.setSize(this.mFboDimension.x, this.mFboDimension.y);

		this.mDofImageShader.near = this.mDofBlurShader.near;
		this.mDofImageShader.far = this.mDofBlurShader.far;
		this.mDofImageShader.focalLength = this.mDofBlurShader.focalLength;
		this.mDofImageShader.focusDistance = this.mDofBlurShader.focusDistance;
		this.mDofImageShader.fStop = this.mDofBlurShader.fStop;
		this.mDofImageShader.updateBlurCoefficient();

		// Hide loading screen
		if (this.mDivLoading != null)
			this.mDivLoading.hide();

		this.mLoadComplete = true;
	}

	if (index < 4) {
		// update loading progress
		++index;
		if (this.mTxtLoadingProgress != null)
			this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount * 2.0 + index) / (this.mResource.items.length * 2.0 + 4.0)) * 100.0));

		// Move on
		var parent = this;
		setTimeout(function() {
			parent.loadShaders(index)
		}, 1);
	}
}
// Implementation.

DepthOfFieldScene.prototype.onLoadComplete = function() {
	// Process shaders
	var shaderResource = [];
	shaderResource.push(this.mResource.find("basic.vs"));
	shaderResource.push(this.mResource.find("basic.fs"));
	shaderResource.push(this.mResource.find("depth.vs"));
	shaderResource.push(this.mResource.find("depth.fs"));
	shaderResource.push(this.mResource.find("image.vs"));
	shaderResource.push(this.mResource.find("depth_image.fs"));
	shaderResource.push(this.mResource.find("dof_blur.fs"));
	shaderResource.push(this.mResource.find("dof_image.fs"));

	// Process textures
	var sampler = new SamplerState(SamplerState.LinearClamp);
	sampler.hasMipMap = true;
	var imgCheckerBoard = this.mResource.find("checker_board.png");
	if (imgCheckerBoard != null) {
		this.mTexCheckerBoard = new GLTexture2D();
		this.mTexCheckerBoard.create(imgCheckerBoard.item.width, imgCheckerBoard.item.height, Texture.Format.Alpha8, sampler, imgCheckerBoard.item);

		this.mEntity[1].objectMaterial.texture = [];
		this.mEntity[1].objectMaterial.texture.push(this.mTexCheckerBoard);
	}

	var imgRuler = this.mResource.find("ruler.png");
	if (imgRuler != null) {
		this.mTexRuler = new GLTexture2D();
		this.mTexRuler.create(imgRuler.item.width, imgRuler.item.height, Texture.Format.Alpha8, sampler, imgRuler.item);

		this.mEntity[0].objectMaterial.texture = [];
		this.mEntity[0].objectMaterial.texture.push(this.mTexRuler);
	}

	// Setup camera matrices
	this.mProjectionMatrix = ViewMatrix.perspective(60.0, 1.333, 1.0, 30.0);
	this.mViewMatrix.pointAt(new Point(0.0, -1.0, 9.9), new Point());
	this.mInvViewMatrix = this.mViewMatrix.inverse();

	// Compile shaders
	this.compileShaders(0, shaderResource);
}