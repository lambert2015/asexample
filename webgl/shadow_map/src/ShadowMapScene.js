// This scene demonstrates how to render shadow maps. The process is as follows.
// 1. Render the depth map from the light's point of view. A depth map is a
// texture
//    that stores the distance between the light source and the vertices.
//
//	1a. If you have a directional light source, you render a single depth map.
// 1b. If you have a point light source, you render all 6 depth maps to a
// cubemap.
//
// 2. Choose a shadow map filtering algorithm.
//	2a. Percentage Closer Filtering (PCF) will perform its filter in the shadow
// map shader.
//     This is similar to a convolution filter whereby you check neighbouring
// pixels. It's
//     not that fast, but simple to implement and understand.
// 2b. Variance Shadow Maps (VSM) and Exponential Shadow Maps (ESM) can take
// advantage of
//     faster filtering algorithms. First perform a seperable blur on the shadow
// map and
//     optionally generate mipmaps. The shadow map shader will use a special
// formula for
//     processing the depth map.
//
// 3. Next, render the scene as normal from the camera. In the shadow map shader,
// perform all
//    lighting calculations as you normally would. As a final step, calculate how
// much shadow
//    a fragment receives by comparing its vertex-to-light distance value with
// the one recorded
//    in the depth map. If the value is >, then the fragment is in shadow;
// otherwise it is not.
//    Remember, in depth comparison smaller values are closer to the source, so
// we want to
//    check if the fragment is in front (less than) or behind (greater than) the
// recorded value
//    in the depth map.

function ShadowMapScene() {
	// Setup inherited members.
	BaseScene.call(this);

	// Point light source.
	this.mPointLight = null;

	// Directional light source. Always points towards the origin.
	this.mDirectionalLight = null;

	// Gets or sets the current light position for either the point light or
	// the directional light.
	this.mLightPosition = new Point();

	// Gets or sets the current angle of the light source, in radians. Used for
	// animating the light source around in a circle.
	this.mAnimLightPosition

	// Stores the inverse view matrix.
	this.mInvViewMatrix = null;

	// Projection matrix used by the light sources. Typically a 90' perspective
	// frustum with 1.0 aspect ratio.
	this.mLightProjection = null;

	// Point light view array of matrices. This is used for rendering the scene
	// from the light's point of view. There are 6 view matrices in all, one
	// for each face of the cube.
	this.mPointLightViewMatrix = null;

	// The framebuffer object to store the depth map. This will be fed into the
	// shadow map shader.
	this.mFboDepth = null;

	// The framebuffer object for performing the first pass [horizontal] blur using
	// the
	// seperable blur algorithm. On the second pass, the final bluring will be stored
	// back
	// into the mFboDepth object.
	this.mFboBlur = null;

	// Framebuffer objects.
	this.mFboDepthColourBuffer = null;
	this.mFboDepthDepthBuffer = null;
	this.mFboBlurColourBuffer = null;

	// Gets or sets the dimensions of the FBO, or in other words the size of the
	// shadow map.
	this.mFboDimension = null;

	// The depth shader is responsible for rendering the depth values. The scene will
	// be
	// rendered from the light's point of view. For point lights, this will be
	// iterated
	// six times, one for each face of the cube.
	this.mDepthShader = null;

	// The shader uses gaussian to blur a texture. It uses the seperable blur
	// algorithm, which
	// divides blurring into two passes. The first pass will render a horizontal
	// blur. The second
	// pass will render the vertical blur. This is much faster than using a
	// traditional convolution
	// filter algorithm.
	this.mGaussianBlurShader = null;
	this.mGaussianBlurCubeShader = null;

	// The shadowmap shader is identical to the basic lighting shader except that
	// it performs an additional check to determine if the pixel is inside a shadow.
	this.mShadowMapShader = null;
	this.mShadowMapCubeShader = null;

	// This shader renders a simple texture to the screen. It is used for displaying
	// the depth map.
	this.mDepthRenderShader = null;
	this.mDepthRenderCubeShader = null;

	// Surface (rectangle) containing a texture to manipulate or view. Used for
	// blurring or
	// showing the depth map.
	this.mSurface = null;

	// Stores a reference to the canvas DOM element, which is used to reset the
	// viewport
	// back to its original size after rendering to the FBO, which uses a different
	// dimension.
	this.mCanvas = null;

	// UI members.
	this.mDivLoading = null;
	this.mTxtLoadingProgress = null;
	this.mCboxResolution = null;
	this.mCboxBlurDepthMap = null;
	this.mCboxFilter = null;
	this.mCboxViewState = null;
	this.mCboxEnableAnimation = null;
	this.mRadioDirectionalLight = null;
	this.mRadioPointLight = null;

	this.mViewState = 0;
	this.mIsPointLightActive = false;
}

// Prototypal Inheritance.
ShadowMapScene.prototype = new BaseScene();
ShadowMapScene.prototype.constructor = ShadowMapScene;

// Implementation.
ShadowMapScene.prototype.start = function() {
	// Setup members and default values
	this.mShader = [];
	this.mCanvas = document.getElementById("webgl_canvas");
	this.mFboDimension = new Point(512, 512);

	// Construct FBO for rendering the depth map
	var sampler = new SamplerState(SamplerState.LinearClamp);
	sampler.hasMipMap = true;
	this.mFboDepthColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboDepthColourBuffer.textureObject = new GLTexture2D();
	this.mFboDepthColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);

	this.mFboDepthDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboDepthDepthBuffer.renderBufferFormat = Texture.Format.Depth16;

	this.mFboDepth = new GLFrameBufferObject();
	this.mFboDepth.create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboDepth.attachBuffer(this.mFboDepthColourBuffer);
	this.mFboDepth.attachBuffer(this.mFboDepthDepthBuffer);

	// Construct FBO for rendering the blur
	sampler.hasMipMap = false;
	this.mFboBlurColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboBlurColourBuffer.textureObject = new GLTexture2D();
	this.mFboBlurColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);

	this.mFboBlur = new GLFrameBufferObject();
	this.mFboBlur.create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboBlur.attachBuffer(this.mFboBlurColourBuffer);

	// Construct the scene to be rendered
	this.mEntity = ShadowMapSceneGen.create();

	// Construct the surface used to perform the blurring or viewing the depth map
	// It will fit to the dimensions of the window.
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.objectEntity = rectVbo;
	this.mSurface.objectMatrix.translate(0.0, 0.0, 1.0);
	this.mSurface.objectMaterial.texture = [];

	// Create light sources
	this.mLightPosition.setPoint(0.0, 0.0, 0.0);
	this.mLightProjection = ViewMatrix.perspective(90.0, 1.0, 1.0, 30.0);
	this.mAnimLightPosition = 0.0;

	this.mPointLight = new Light();
	this.mPointLight.lightType = Light.LightSourceType.Point;
	this.mPointLight.position = this.mLightPosition;
	this.mPointLight.attenuation.z = 0.01;

	// Create the 6 projection matrices for the point light (one for each cube face)
	// Order is: +X, -X, +Y, -Y, +Z, -Z
	this.mPointLightViewMatrix = [];
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[0].rotate(0, -90, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[1].rotate(0, 90, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[2].rotate(-90, 0, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[3].rotate(90, 0, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	//this.mPointLightViewMatrix[4].rotate(0, 0, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[5].rotate(0, 180, 0);

	this.mDirectionalLight = new Light();
	this.mDirectionalLight.lightType = Light.LightSourceType.Directional;
	this.mDirectionalLight.position = this.mLightPosition;
	this.mDirectionalLight.direction.setPoint(0.0, -1.0, 0.0);
	this.mDirectionalLight.setCutoff(45.0, 0.0);

	// Create the directional light view matrix. It will be animated at runtime.
	this.mDirectionalLight.matrix = new Matrix(4, 4);
	this.mDirectionalLight.matrix.pointAt(this.mDirectionalLight.position, new Point(), new Point(1.0, 0.0, 0.0));
	this.mDirectionalLight.matrix = this.mDirectionalLight.matrix.inverse();

	// Prepare resources to download
	this.mResource.add(new ResourceItem("depth.vs", null, "./shaders/depth.vs"));
	this.mResource.add(new ResourceItem("depth.fs", null, "./shaders/depth.fs"));

	this.mResource.add(new ResourceItem("gaussianBlur.vs", null, "./shaders/gaussianBlur.vs"));
	this.mResource.add(new ResourceItem("gaussianBlur.fs", null, "./shaders/gaussianBlur.fs"));
	this.mResource.add(new ResourceItem("gaussianBlurCube.fs", null, "./shaders/gaussianBlurCube.fs"));

	this.mResource.add(new ResourceItem("shadowMap.vs", null, "./shaders/shadowMap.vs"));
	this.mResource.add(new ResourceItem("shadowMap.fs", null, "./shaders/shadowMap.fs"));
	this.mResource.add(new ResourceItem("shadowMapCube.fs", null, "./shaders/shadowMapCube.fs"));

	this.mResource.add(new ResourceItem("depthImage.vs", null, "./shaders/depthImage.vs"));
	this.mResource.add(new ResourceItem("depthImage.fs", null, "./shaders/depthImage.fs"));
	this.mResource.add(new ResourceItem("depthImageCube.fs", null, "./shaders/depthImageCube.fs"));

	// Setup user interface
	this.mDivLoading = $("#DivLoading");
	this.mTxtLoadingProgress = $("#TxtLoadingProgress");

	this.mCboxResolution = document.getElementById("CboxResolution");
	this.mCboxResolution.selectedIndex = 1;
	this.mCboxResolution.onchange = this.onResolutionValueChanged.bind(this);

	this.mCboxBlurDepthMap = document.getElementById("CboxDepthBlur");
	this.mCboxBlurDepthMap.selectedIndex = 2;
	this.mCboxBlurDepthMap.onchange = this.onBlurDepthMapValueChanged.bind(this);

	this.mCboxFilter = document.getElementById("CboxShadowMapFilter");
	this.mCboxFilter.selectedIndex = 0;
	this.mCboxFilter.onchange = this.onShadowMapFilterValueChanged.bind(this);

	this.mCboxViewState = document.getElementById("CboxViewState");
	this.mCboxViewState.selectedIndex = 0;
	this.mCboxViewState.onchange = this.onViewStateValueChanged.bind(this);

	this.mCboxEnableAnimation = document.getElementById("CboxEnableAnimation");
	this.mCboxEnableAnimation.checked = true;

	this.mRadioDirectionalLight = document.getElementById("RadioDirectionalLight");
	this.mRadioDirectionalLight.checked = true;
	this.mRadioDirectionalLight.onclick = this.onDirectionalLightSourceClicked.bind(this);

	this.mRadioPointLight = document.getElementById("RadioPointLight");
	this.mRadioPointLight.onclick = this.onPointLightSourceClicked.bind(this);

	// Start downloading resources
	BaseScene.prototype.start.call(this);

	// Create camera matrices
	this.mProjectionMatrix = ViewMatrix.perspective(90.0, 1.333, 1.0, 30.0);
	this.mViewMatrix.pointAt(new Point(0.0, 2.0, 9.9), new Point());
	this.mInvViewMatrix = this.mViewMatrix.inverse();
}
// Method called when the depth map resolution combo box value has changed.
ShadowMapScene.prototype.onResolutionValueChanged = function(event) {
	// Extract resolution
	var split = this.mCboxResolution.value.split(" ");
	this.mFboDimension.x = parseInt(split[0]);
	this.mFboDimension.y = parseInt(split[split.length - 1]);

	// Update the FBO resolution
	this.mFboDepth.resize(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboBlur.resize(this.mFboDimension.x, this.mFboDimension.y);

	this.mGaussianBlurShader.setSize(this.mFboDimension.x, this.mFboDimension.y);
	this.mGaussianBlurCubeShader.setSize(this.mFboDimension.x, this.mFboDimension.y);
	this.mDepthRenderShader.setSize(this.mFboDimension.x, this.mFboDimension.y);
	this.mDepthRenderCubeShader.setSize(this.mFboDimension.x, this.mFboDimension.y);
}
// Method called when the blur depth map combo box value has changed.
ShadowMapScene.prototype.onBlurDepthMapValueChanged = function(event) {
	if (this.mCboxBlurDepthMap.selectedIndex == 0) {
		this.mGaussianBlurShader.blurAmount = 0;
		this.mGaussianBlurCubeShader.blurAmount = 0;
	} else {
		var split = this.mCboxBlurDepthMap.value.split(" ");
		this.mGaussianBlurShader.blurAmount = parseInt(split[0]);
		this.mGaussianBlurCubeShader.blurAmount = this.mGaussianBlurShader.blurAmount;
	}
}
// Method called when the shadow map filter combo box value has changed.
ShadowMapScene.prototype.onShadowMapFilterValueChanged = function(event) {
	this.mDepthShader.filterType = this.mCboxFilter.selectedIndex;
	this.mShadowMapShader.filterType = this.mCboxFilter.selectedIndex;
	this.mShadowMapCubeShader.filterType = this.mCboxFilter.selectedIndex;
	this.mDepthRenderShader.filterType = this.mCboxFilter.selectedIndex;
	this.mDepthRenderCubeShader.filterType = this.mCboxFilter.selectedIndex;
}
// Method called when the view state combo box value has changed.
ShadowMapScene.prototype.onViewStateValueChanged = function(event) {
	this.mViewState = this.mCboxViewState.selectedIndex;
}
// Method called when the light source has changed.
ShadowMapScene.prototype.onDirectionalLightSourceClicked = function(event) {
	this.mIsPointLightActive = false;

	// Update FBO
	if (this.mFboDepthColourBuffer != null)
		this.mFboDepthColourBuffer.textureObject.release();

	var sampler = new SamplerState(SamplerState.LinearClamp);
	sampler.hasMipMap = true;
	this.mFboDepthColourBuffer.textureObject = new GLTexture2D();
	this.mFboDepthColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	this.mFboDepth.attachBuffer(this.mFboDepthColourBuffer);

	if (this.mFboBlurColourBuffer != null)
		this.mFboBlurColourBuffer.textureObject.release();

	sampler.hasMipMap = false;
	this.mFboBlurColourBuffer.textureObject = new GLTexture2D();
	this.mFboBlurColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	this.mFboBlur.attachBuffer(this.mFboBlurColourBuffer);

	this.mShadowMapShader.depthMap = this.mFboDepthColourBuffer.textureObject;
}
// Method called when the light source has changed.
ShadowMapScene.prototype.onPointLightSourceClicked = function(event) {
	this.mIsPointLightActive = true;

	// Update FBO
	if (this.mFboDepthColourBuffer != null)
		this.mFboDepthColourBuffer.textureObject.release();

	var sampler = new SamplerState(SamplerState.LinearClamp);
	sampler.hasMipMap = true;
	this.mFboDepthColourBuffer.textureObject = new GLTextureCube();
	this.mFboDepthColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	this.mFboDepth.attachBuffer(this.mFboDepthColourBuffer);

	if (this.mFboBlurColourBuffer != null)
		this.mFboBlurColourBuffer.textureObject.release();

	sampler.hasMipMap = false;
	this.mFboBlurColourBuffer.textureObject = new GLTextureCube();
	this.mFboBlurColourBuffer.textureObject.create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	this.mFboBlur.attachBuffer(this.mFboBlurColourBuffer);

	this.mShadowMapCubeShader.depthMap = this.mFboDepthColourBuffer.textureObject;
}
// Implementation.
ShadowMapScene.prototype.update = function() {
	BaseScene.prototype.update.call(this);

	// Draw only when all resources have been loaded
	if (this.mLoadComplete) {
		//
		// Animate the light source
		//
		if (this.mCboxEnableAnimation.checked) {
			if (!this.mIsPointLightActive)
				this.mLightPosition.setPoint(Math.sin(this.mAnimLightPosition) * 7.0, this.mLightPosition.y, Math.cos(this.mAnimLightPosition) * 7.0);
			else
				this.mLightPosition.setPoint(Math.sin(this.mAnimLightPosition) * 3.0, this.mLightPosition.y, Math.cos(this.mAnimLightPosition) * 3.0);
			this.mAnimLightPosition += 0.01;

			// Update directional light
			this.mDirectionalLight.direction = this.mLightPosition.negative().normalize();
			this.mDirectionalLight.matrix.pointAt(this.mLightPosition, new Point());
			this.mDirectionalLight.matrix = this.mDirectionalLight.matrix.inverse();

			// Update point light
			for (var i = 0; i < 6; ++i)
				this.mPointLightViewMatrix[i].translate(this.mLightPosition.x, this.mLightPosition.y, this.mLightPosition.z);
		}

		//
		// Step 1: Render depth map from the light's point of view
		//
		this.mDepthShader.enable();
		if (!this.mIsPointLightActive) {
			// Render depth map for a directional light
			this.mDepthShader.view = this.mDirectionalLight.matrix;

			this.mFboDepth.enable();

			gl.viewport(0, 0, this.mFboDepth.getFrameWidth(), this.mFboDepth.getFrameHeight());
			gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

			for (var i = 0; i < this.mEntity.length; ++i)
				this.mDepthShader.draw(this.mEntity[i]);

			this.mFboDepth.disable();
		} else {
			// Render depth maps for a point light (6 in total, one for each cube face)
			for (var f = 0; f < 6; ++f) {
				this.mDepthShader.view = this.mPointLightViewMatrix[f].inverse();

				this.mFboDepth.enableCubemap(gl.TEXTURE_CUBE_MAP_POSITIVE_X + f);

				gl.viewport(0, 0, this.mFboDepth.getFrameWidth(), this.mFboDepth.getFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

				for (var i = 0; i < this.mEntity.length; ++i)
					this.mDepthShader.draw(this.mEntity[i]);
			}
			this.mFboDepth.disable();
		}
		this.mDepthShader.disable();

		//
		// Step 2: Blur the shadow map
		// Applicable only with VSM or ESM filtering
		//
		if ((this.mGaussianBlurShader.blurAmount > 0) && (this.mShadowMapShader.filterType >= 2)) {
			if (!this.mIsPointLightActive) {
				this.mGaussianBlurShader.enable();

				// Render horizontal blur
				this.mFboBlur.enable();
				this.mSurface.objectMaterial.texture[0] = this.mFboDepthColourBuffer.textureObject;
				this.mGaussianBlurShader.draw(this.mSurface, 0);
				//this.mFboBlur.disable();

				// Render vertical blur (back into depth map)
				this.mFboDepth.enable();
				gl.clear(gl.DEPTH_BUFFER_BIT);
				this.mSurface.objectMaterial.texture[0] = this.mFboBlurColourBuffer.textureObject;
				this.mGaussianBlurShader.draw(this.mSurface, 1);
				this.mFboDepth.disable();

				this.mGaussianBlurShader.disable();
			} else {
				this.mGaussianBlurCubeShader.enable();

				// Bluring cubemap (quite expensive)
				for (var f = 0; f < 6; ++f) {
					this.mGaussianBlurCubeShader.cubeFace = f;

					// Render horizontal blur
					this.mFboBlur.enableCubemap(gl.TEXTURE_CUBE_MAP_POSITIVE_X + f);
					this.mSurface.objectMaterial.texture[0] = this.mFboDepthColourBuffer.textureObject;
					this.mGaussianBlurCubeShader.draw(this.mSurface, 0);
					//this.mFboBlur.disable();

					// Render vertical blur (back into depth map)
					this.mFboDepth.enableCubemap(gl.TEXTURE_CUBE_MAP_POSITIVE_X + f);
					gl.clear(gl.DEPTH_BUFFER_BIT);
					this.mSurface.objectMaterial.texture[0] = this.mFboBlurColourBuffer.textureObject;
					this.mGaussianBlurCubeShader.draw(this.mSurface, 1);
					//this.mFboDepth.disable();
				}
				this.mFboDepth.disable();

				this.mGaussianBlurCubeShader.disable();
			}
		}

		// Restore viewport
		gl.viewport(0, 0, this.mCanvas.width, this.mCanvas.height);

		//
		// Step 3: Generate mipmaps for the depth map
		//
		if (!this.mIsPointLightActive)
			this.mShadowMapShader.depthMap.createMipmaps();
		else
			this.mShadowMapCubeShader.depthMap.createMipmaps();

		if (this.mViewState <= 1) {
			// Step 4: Render the scene from the camera's point of view
			// and determine if a pixel is within the shadow by comparing
			// its z-depth against the value recorded in the depth map.
			if (!this.mIsPointLightActive) {
				// Directional light
				this.mShadowMapShader.enable();

				this.mShadowMapShader.projection = (this.mViewState == 0) ? this.mProjectionMatrix : this.mLightProjection;
				this.mShadowMapShader.view = (this.mViewState == 0) ? this.mInvViewMatrix : this.mDirectionalLight.matrix;
				this.mShadowMapShader.lightSourceViewMatrix = this.mDirectionalLight.matrix;

				for (var i = 0; i < this.mEntity.length; ++i)
					this.mShadowMapShader.draw(this.mEntity[i]);

				this.mShadowMapShader.disable();
			} else {
				// Point light
				this.mShadowMapCubeShader.enable();

				this.mShadowMapCubeShader.projection = (this.mViewState == 0) ? this.mProjectionMatrix : this.mLightProjection;
				this.mShadowMapCubeShader.view = (this.mViewState == 0) ? this.mInvViewMatrix : this.mDirectionalLight.matrix;

				for (var i = 0; i < this.mEntity.length; ++i)
					this.mShadowMapCubeShader.draw(this.mEntity[i]);

				this.mShadowMapCubeShader.disable();
			}
		} else {
			//
			// Optionally show the current depth map
			// Need to chose between 2D depth map view or cubemap depth map view
			//
			this.mSurface.objectMaterial.texture[0] = this.mFboDepthColourBuffer.textureObject;

			if (!this.mIsPointLightActive) {
				// Directional light
				this.mDepthRenderShader.enable();
				this.mDepthRenderShader.draw(this.mSurface);
				this.mDepthRenderShader.disable();
			} else {
				// Point light
				this.mDepthRenderCubeShader.enable();
				this.mDepthRenderCubeShader.draw(this.mSurface);
				this.mDepthRenderCubeShader.disable();
			}
		}
	}
}
// Implementation.
ShadowMapScene.prototype.end = function() {
	BaseScene.prototype.end.call(this);

	// Cleanup
	if (this.mFboDepth != null)
		this.mFboDepth.release();

	if (this.mFboDepthColourBuffer != null)
		this.mFboDepthColourBuffer.textureObject.release();

	if (this.mFboBlurColourBuffer != null)
		this.mFboBlurColourBuffer.textureObject.release();

	if (this.mFboBlur != null)
		this.mFboBlur.release();

	if (this.mSurface != null)
		this.mSurface.objectEntity.release();

	if (this.mDepthShader)
		this.mDepthShader.release();

	if (this.mGaussianBlurShader)
		this.mGaussianBlurShader.release();

	if (this.mShadowMapShader)
		this.mShadowMapShader.release();

	if (this.mShadowMapCubeShader)
		this.mShadowMapCubeShader.release();

	if (this.mDepthRenderShader)
		this.mDepthRenderShader.release();

	if (this.mDepthRenderCubeShader)
		this.mDepthRenderCubeShader.release();
}
// This method is called when an item for the scene has downloaded. it
// will increment the resource counter and dispatch an OnLoadComplete
// event once all items have been downloaded.
ShadowMapScene.prototype.onItemLoaded = function(sender, response) {
	BaseScene.prototype.onItemLoaded.call(this, sender, response);

	if (this.mTxtLoadingProgress != null)
		this.mTxtLoadingProgress.html(Math.floor((this.mResourceCount / (this.mResource.items.length * 2.0 + 6.0)) * 100.0));
}
// This method is called to compile a bunch of shaders. The browser will be
// blocked while the GPU compiles, so we need to give the browser a chance
// to refresh its view and take user input while this happens (good ui practice).
ShadowMapScene.prototype.compileShaders = function(index, list) {
	var shaderItem = list[index];
	if (shaderItem != null) {
		// Compile vertex shader
		var shader = new GLShader();
		if (!shader.create((shaderItem.name.lastIndexOf(".vs") != -1) ? 
		GLShader.ShaderType.Vertex : 
			GLShader.ShaderType.Fragment, shaderItem.item)) {
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

	// Update loading progress
	++index;
	if (this.mTxtLoadingProgress != null)
		this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount + index) / (this.mResource.items.length * 2.0 + 6.0)) * 100.0));

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
ShadowMapScene.prototype.loadShaders = function(index) {
	if (index == 0) {
		// Create depth map shader program
		this.mDepthShader = new DepthShader();
		this.mDepthShader.projection = this.mLightProjection;
		this.mDepthShader.create();
		this.mDepthShader.addShader(this.mShader[0]);
		this.mDepthShader.addShader(this.mShader[1]);
		this.mDepthShader.link();
		this.mDepthShader.init();
	} else if (index == 1) {
		// Create gaussian blur shader program
		this.mGaussianBlurShader = new GaussianBlurShader();
		this.mGaussianBlurShader.projection = this.mOrthographicMatrix;
		this.mGaussianBlurShader.view = new Matrix(4, 4);
		this.mGaussianBlurShader.create();
		this.mGaussianBlurShader.addShader(this.mShader[2]);
		this.mGaussianBlurShader.addShader(this.mShader[3]);
		this.mGaussianBlurShader.link();
		this.mGaussianBlurShader.init();
		this.mGaussianBlurShader.setSize(this.mFboDimension.x, this.mFboDimension.y);
		this.mGaussianBlurShader.blurAmount = 5;
	} else if (index == 2) {
		// Create gaussian blur cube shader program
		this.mGaussianBlurCubeShader = new GaussianBlurShader();
		this.mGaussianBlurCubeShader.projection = this.mOrthographicMatrix;
		this.mGaussianBlurCubeShader.view = new Matrix(4, 4);
		this.mGaussianBlurCubeShader.create();
		this.mGaussianBlurCubeShader.addShader(this.mShader[2]);
		this.mGaussianBlurCubeShader.addShader(this.mShader[4]);
		this.mGaussianBlurCubeShader.link();
		this.mGaussianBlurCubeShader.init();
		this.mGaussianBlurCubeShader.setSize(this.mFboDimension.x, this.mFboDimension.y);
		this.mGaussianBlurCubeShader.blurAmount = 5;
	} else if (index == 3) {
		// Create shadow map shader program
		this.mShadowMapShader = new ShadowMapShader();
		this.mShadowMapShader.projection = this.mProjectionMatrix;
		this.mShadowMapShader.view = this.mInvViewMatrix;
		this.mShadowMapShader.lightSourceProjectionMatrix = this.mLightProjection;
		this.mShadowMapShader.create();
		this.mShadowMapShader.addShader(this.mShader[5]);
		this.mShadowMapShader.addShader(this.mShader[6]);
		this.mShadowMapShader.link();
		this.mShadowMapShader.init();
		this.mShadowMapShader.lightObject.push(this.mDirectionalLight);
		this.mShadowMapShader.depthMap = this.mFboDepthColourBuffer.textureObject;
	} else if (index == 4) {
		// Create shadow map cube shader program
		this.mShadowMapCubeShader = new ShadowMapShader();
		this.mShadowMapCubeShader.projection = this.mProjectionMatrix;
		this.mShadowMapCubeShader.view = this.mInvViewMatrix;
		this.mShadowMapCubeShader.lightSourceProjectionMatrix = this.mLightProjection;
		this.mShadowMapCubeShader.create();
		this.mShadowMapCubeShader.addShader(this.mShader[5]);
		this.mShadowMapCubeShader.addShader(this.mShader[7]);
		this.mShadowMapCubeShader.link();
		this.mShadowMapCubeShader.init();
		this.mShadowMapCubeShader.lightObject.push(this.mPointLight);
		this.mShadowMapCubeShader.depthMap = this.mFboDepthColourBuffer.textureObject;
	} else if (index == 5) {
		// Create depth render shader program
		this.mDepthRenderShader = new DepthRenderShader();
		this.mDepthRenderShader.projection = this.mOrthographicMatrix;
		this.mDepthRenderShader.view = new Matrix(4, 4);
		this.mDepthRenderShader.create();
		this.mDepthRenderShader.addShader(this.mShader[8]);
		this.mDepthRenderShader.addShader(this.mShader[9]);
		this.mDepthRenderShader.link();
		this.mDepthRenderShader.init();
		this.mDepthRenderShader.setSize(this.mFboDimension.x, this.mFboDimension.y);
	} else if (index == 6) {
		// Create depth render cubemap shader program
		this.mDepthRenderCubeShader = new DepthRenderShader();
		this.mDepthRenderCubeShader.projection = this.mOrthographicMatrix;
		this.mDepthRenderCubeShader.view = new Matrix(4, 4);
		this.mDepthRenderCubeShader.create();
		this.mDepthRenderCubeShader.addShader(this.mShader[8]);
		this.mDepthRenderCubeShader.addShader(this.mShader[10]);
		this.mDepthRenderCubeShader.link();
		this.mDepthRenderCubeShader.init();
		this.mDepthRenderCubeShader.setSize(this.mFboDimension.x, this.mFboDimension.y);

		// Hide loading screen
		if (this.mDivLoading != null)
			this.mDivLoading.hide();

		this.mLoadComplete = true;
	}

	if (index < 6) {
		// Update loading progress
		++index;
		if (this.mTxtLoadingProgress != null)
			this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount * 2.0 + index) / (this.mResource.items.length * 2.0 + 6.0)) * 100.0));

		// Move on
		var parent = this;
		setTimeout(function() {
			parent.loadShaders(index)
		}, 1);
	}
}
// Implementation.
ShadowMapScene.prototype.onLoadComplete = function() {
	// Process shaders
	var shaderResource = [];
	shaderResource.push(this.mResource.find("depth.vs"));
	shaderResource.push(this.mResource.find("depth.fs"));
	shaderResource.push(this.mResource.find("gaussianBlur.vs"));
	shaderResource.push(this.mResource.find("gaussianBlur.fs"));
	shaderResource.push(this.mResource.find("gaussianBlurCube.fs"));
	shaderResource.push(this.mResource.find("shadowMap.vs"));
	shaderResource.push(this.mResource.find("shadowMap.fs"));
	shaderResource.push(this.mResource.find("shadowMapCube.fs"));
	shaderResource.push(this.mResource.find("depthImage.vs"));
	shaderResource.push(this.mResource.find("depthImage.fs"));
	shaderResource.push(this.mResource.find("depthImageCube.fs"));

	// Compile shaders
	this.compileShaders(0, shaderResource);
}