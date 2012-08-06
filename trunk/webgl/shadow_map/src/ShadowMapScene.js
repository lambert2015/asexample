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
/// This scene demonstrates how to render shadow maps. The process is as follows.
/// 1. Render the depth map from the light's point of view. A depth map is a texture
///    that stores the distance between the light source and the vertices.
///
///	1a. If you have a directional light source, you render a single depth map.
/// 1b. If you have a point light source, you render all 6 depth maps to a cubemap.
///
/// 2. Choose a shadow map filtering algorithm.
///	2a. Percentage Closer Filtering (PCF) will perform its filter in the shadow map shader.
///     This is similar to a convolution filter whereby you check neighbouring pixels. It's
///     not that fast, but simple to implement and understand.
/// 2b. Variance Shadow Maps (VSM) and Exponential Shadow Maps (ESM) can take advantage of
///     faster filtering algorithms. First perform a seperable blur on the shadow map and
///     optionally generate mipmaps. The shadow map shader will use a special formula for
///     processing the depth map.
///
/// 3. Next, render the scene as normal from the camera. In the shadow map shader, perform all
///    lighting calculations as you normally would. As a final step, calculate how much shadow
///    a fragment receives by comparing its vertex-to-light distance value with the one recorded
///    in the depth map. If the value is >, then the fragment is in shadow; otherwise it is not.
///    Remember, in depth comparison smaller values are closer to the source, so we want to
///    check if the fragment is in front (less than) or behind (greater than) the recorded value
///    in the depth map.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function ShadowMapScene ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	BaseScene.call(this);
	
	
	/// <summary>
	/// Point light source.
	/// </summary>
	this.mPointLight = null;
	
	
	/// <summary>
	/// Directional light source. Always points towards the origin.
	/// </summary>
	this.mDirectionalLight = null;
	
	
	/// <summary>
	/// Gets or sets the current light position for either the point light or
	/// the directional light.
	/// </summary>
	this.mLightPosition = new Point();
	
	
	/// <summary>
	/// Gets or sets the current angle of the light source, in radians. Used for
	/// animating the light source around in a circle.
	/// </summary>
	this.mAnimLightPosition;
	
	
	/// <summary>
	/// Stores the inverse view matrix.
	/// </summary>
	this.mInvViewMatrix = null;
	
	
	/// <summary>
	/// Projection matrix used by the light sources. Typically a 90' perspective
	/// frustum with 1.0 aspect ratio.
	/// </summary>
	this.mLightProjection = null;
	
	
	/// <summary>
	/// Point light view array of matrices. This is used for rendering the scene
	/// from the light's point of view. There are 6 view matrices in all, one
	/// for each face of the cube.
	/// </summary>
	this.mPointLightViewMatrix = null;
	
	
	/// <summary>
	/// The framebuffer object to store the depth map. This will be fed into the
	/// shadow map shader.
	/// </summary>
	this.mFboDepth = null;
	
	
	/// <summary>
	/// The framebuffer object for performing the first pass [horizontal] blur using the
	/// seperable blur algorithm. On the second pass, the final bluring will be stored back
	/// into the mFboDepth object.
	/// </summary>
	this.mFboBlur = null;
	
	
	/// <summary>
	/// Framebuffer objects.
	/// </summary>
	this.mFboDepthColourBuffer = null;
	this.mFboDepthDepthBuffer = null;
	this.mFboBlurColourBuffer = null;

	
	/// <summary>
	/// Gets or sets the dimensions of the FBO, or in other words the size of the shadow map.
	/// </summary>
	this.mFboDimension = null;
	
	
	/// <summary>
	/// The depth shader is responsible for rendering the depth values. The scene will be
	/// rendered from the light's point of view. For point lights, this will be iterated
	/// six times, one for each face of the cube.
	/// </summary>
	this.mDepthShader = null;
	
	
	/// <summary>
	/// The shader uses gaussian to blur a texture. It uses the seperable blur algorithm, which
	/// divides blurring into two passes. The first pass will render a horizontal blur. The second
	/// pass will render the vertical blur. This is much faster than using a traditional convolution
	/// filter algorithm.
	/// </summary>
	this.mGaussianBlurShader = null;
	this.mGaussianBlurCubeShader = null;
	
	
	/// <summary>
	/// The shadowmap shader is identical to the basic lighting shader except that
	/// it performs an additional check to determine if the pixel is inside a shadow.
	/// </summary>
	this.mShadowMapShader = null;
	this.mShadowMapCubeShader = null;
	
	
	/// <summary>
	/// This shader renders a simple texture to the screen. It is used for displaying
	/// the depth map.
	/// </summary>
	this.mDepthRenderShader = null;
	this.mDepthRenderCubeShader = null;
	
	
	/// <summary>
	/// Surface (rectangle) containing a texture to manipulate or view. Used for blurring or
	/// showing the depth map.
	/// </summary>
	this.mSurface = null;
	
	
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


/// <summary>
/// Prototypal Inheritance.
/// </summary>
ShadowMapScene.prototype = new BaseScene();
ShadowMapScene.prototype.constructor = ShadowMapScene;


/// <summary>
/// Implementation.
/// </summary>
ShadowMapScene.prototype.Start = function ()
{
	// Setup members and default values
	this.mShader = new Array();
	this.mCanvas = document.getElementById("Canvas");
	this.mFboDimension = new Point(512, 512);
	
	// Construct FBO for rendering the depth map
	var sampler = new SamplerState(SamplerState.LinearClamp);
	sampler.HasMipMap = true;
	this.mFboDepthColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboDepthColourBuffer.TextureObject = new GLTexture2D();
	this.mFboDepthColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	
	this.mFboDepthDepthBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Depth);
	this.mFboDepthDepthBuffer.RenderBufferFormat = Texture.Format.Depth16;
	
	this.mFboDepth = new GLFrameBufferObject();
	this.mFboDepth.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboDepth.AttachBuffer(this.mFboDepthColourBuffer);
	this.mFboDepth.AttachBuffer(this.mFboDepthDepthBuffer);
	
	// Construct FBO for rendering the blur
	sampler.HasMipMap = false;
	this.mFboBlurColourBuffer = new FrameBufferObject(FrameBufferObject.BufferType.Colour);
	this.mFboBlurColourBuffer.TextureObject = new GLTexture2D();
	this.mFboBlurColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	
	this.mFboBlur = new GLFrameBufferObject();
	this.mFboBlur.Create(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboBlur.AttachBuffer(this.mFboBlurColourBuffer);

	// Construct the scene to be rendered
	this.mEntity = ShadowMapSceneGen.Create();
	
	// Construct the surface used to perform the blurring or viewing the depth map
	// It will fit to the dimensions of the window.
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.Create(rectMesh);
	this.mSurface = new Entity();
	this.mSurface.ObjectEntity = rectVbo;
	this.mSurface.ObjectMatrix.Translate(0.0, 0.0, 1.0);
	this.mSurface.ObjectMaterial.Texture = new Array();
	
	// Create light sources
	this.mLightPosition.SetPoint(0.0, 0.0, 0.0);
	this.mLightProjection = ViewMatrix.Perspective(90.0, 1.0, 1.0, 30.0);
	this.mAnimLightPosition = 0.0;
	
	this.mPointLight = new Light();
	this.mPointLight.LightType = Light.LightSourceType.Point;
	this.mPointLight.Position = this.mLightPosition;
	this.mPointLight.Attenuation.z = 0.01;
	
	// Create the 6 projection matrices for the point light (one for each cube face)
	// Order is: +X, -X, +Y, -Y, +Z, -Z
	this.mPointLightViewMatrix = new Array();
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[0].Rotate(0, -90, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[1].Rotate(0, 90, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[2].Rotate(-90, 0, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[3].Rotate(90, 0, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	//this.mPointLightViewMatrix[4].Rotate(0, 0, 0);
	this.mPointLightViewMatrix.push(new Matrix(4, 4));
	this.mPointLightViewMatrix[5].Rotate(0, 180, 0);
	
	this.mDirectionalLight = new Light();
	this.mDirectionalLight.LightType = Light.LightSourceType.Directional;
	this.mDirectionalLight.Position = this.mLightPosition;
	this.mDirectionalLight.Direction.SetPoint(0.0, -1.0, 0.0);
	this.mDirectionalLight.SetCutoff(45.0, 0.0);
	
	// Create the directional light view matrix. It will be animated at runtime.
	this.mDirectionalLight.Matrix = new Matrix(4, 4);
	this.mDirectionalLight.Matrix.PointAt(this.mDirectionalLight.Position,
										  new Point(),
										  new Point(1.0, 0.0, 0.0));
	this.mDirectionalLight.Matrix = this.mDirectionalLight.Matrix.Inverse();

	// Prepare resources to download
	this.mResource.Add(new ResourceItem("depth.vs", null, "./shaders/depth.vs"));
	this.mResource.Add(new ResourceItem("depth.fs", null, "./shaders/depth.fs"));
	
	this.mResource.Add(new ResourceItem("gaussianBlur.vs", null, "./shaders/gaussianBlur.vs"));
	this.mResource.Add(new ResourceItem("gaussianBlur.fs", null, "./shaders/gaussianBlur.fs"));
	this.mResource.Add(new ResourceItem("gaussianBlurCube.fs", null, "./shaders/gaussianBlurCube.fs"));
	
	this.mResource.Add(new ResourceItem("shadowMap.vs", null, "./shaders/shadowMap.vs"));
	this.mResource.Add(new ResourceItem("shadowMap.fs", null, "./shaders/shadowMap.fs"));
	this.mResource.Add(new ResourceItem("shadowMapCube.fs", null, "./shaders/shadowMapCube.fs"));
	
	this.mResource.Add(new ResourceItem("depthImage.vs", null, "./shaders/depthImage.vs"));
	this.mResource.Add(new ResourceItem("depthImage.fs", null, "./shaders/depthImage.fs"));
	this.mResource.Add(new ResourceItem("depthImageCube.fs", null, "./shaders/depthImageCube.fs"));
	
	// Setup user interface
	this.mDivLoading = $("#DivLoading");
	this.mTxtLoadingProgress = $("#TxtLoadingProgress");
	
	this.mCboxResolution = document.getElementById("CboxResolution");
	this.mCboxResolution.selectedIndex = 1;
	this.mCboxResolution.onchange = this.OnResolutionValueChanged.bind(this);
	
	this.mCboxBlurDepthMap = document.getElementById("CboxDepthBlur");
	this.mCboxBlurDepthMap.selectedIndex = 2;
	this.mCboxBlurDepthMap.onchange = this.OnBlurDepthMapValueChanged.bind(this);
	
	this.mCboxFilter = document.getElementById("CboxShadowMapFilter");
	this.mCboxFilter.selectedIndex = 0;
	this.mCboxFilter.onchange = this.OnShadowMapFilterValueChanged.bind(this);
	
	this.mCboxViewState = document.getElementById("CboxViewState");
	this.mCboxViewState.selectedIndex = 0;
	this.mCboxViewState.onchange = this.OnViewStateValueChanged.bind(this);
	
	this.mCboxEnableAnimation = document.getElementById("CboxEnableAnimation");
	this.mCboxEnableAnimation.checked = true;
	
	this.mRadioDirectionalLight = document.getElementById("RadioDirectionalLight");
	this.mRadioDirectionalLight.checked = true;
	this.mRadioDirectionalLight.onclick = this.OnDirectionalLightSourceClicked.bind(this);
	
	this.mRadioPointLight = document.getElementById("RadioPointLight");
	this.mRadioPointLight.onclick = this.OnPointLightSourceClicked.bind(this);
	
	// Start downloading resources
	BaseScene.prototype.Start.call(this);
	
	// Create camera matrices
	this.mProjectionMatrix = ViewMatrix.Perspective(65.0, 1.333, 1.0, 30.0);
	this.mViewMatrix.PointAt(new Point(0.0, 2.0, 9.9),
							 new Point());
	this.mInvViewMatrix = this.mViewMatrix.Inverse();
}


/// <summary>
/// Method called when the depth map resolution combo box value has changed.
/// </summary>
ShadowMapScene.prototype.OnResolutionValueChanged = function (event)
{
	// Extract resolution
	var split = this.mCboxResolution.value.split(" ");
	this.mFboDimension.x = parseInt(split[0]);
	this.mFboDimension.y = parseInt(split[split.length - 1]);

	// Update the FBO resolution
	this.mFboDepth.Resize(this.mFboDimension.x, this.mFboDimension.y);
	this.mFboBlur.Resize(this.mFboDimension.x, this.mFboDimension.y);
	
	this.mGaussianBlurShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
	this.mGaussianBlurCubeShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
	this.mDepthRenderShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
	this.mDepthRenderCubeShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
}


/// <summary>
/// Method called when the blur depth map combo box value has changed.
/// </summary>
ShadowMapScene.prototype.OnBlurDepthMapValueChanged = function (event)
{
	if ( this.mCboxBlurDepthMap.selectedIndex == 0 )
	{
		this.mGaussianBlurShader.BlurAmount = 0;
		this.mGaussianBlurCubeShader.BlurAmount = 0;
	}
	else
	{
		var split = this.mCboxBlurDepthMap.value.split(" ");
		this.mGaussianBlurShader.BlurAmount = parseInt(split[0]);
		this.mGaussianBlurCubeShader.BlurAmount = this.mGaussianBlurShader.BlurAmount;
	}
}


/// <summary>
/// Method called when the shadow map filter combo box value has changed.
/// </summary>
ShadowMapScene.prototype.OnShadowMapFilterValueChanged = function (event)
{
	this.mDepthShader.FilterType = this.mCboxFilter.selectedIndex;
	this.mShadowMapShader.FilterType = this.mCboxFilter.selectedIndex;
	this.mShadowMapCubeShader.FilterType = this.mCboxFilter.selectedIndex;
	this.mDepthRenderShader.FilterType = this.mCboxFilter.selectedIndex;
	this.mDepthRenderCubeShader.FilterType = this.mCboxFilter.selectedIndex;
}


/// <summary>
/// Method called when the view state combo box value has changed.
/// </summary>
ShadowMapScene.prototype.OnViewStateValueChanged = function (event)
{
	this.mViewState = this.mCboxViewState.selectedIndex;
}


/// <summary>
/// Method called when the light source has changed.
/// </summary>
ShadowMapScene.prototype.OnDirectionalLightSourceClicked = function (event)
{	
	this.mIsPointLightActive = false;

	// Update FBO
	if ( this.mFboDepthColourBuffer != null )
		this.mFboDepthColourBuffer.TextureObject.Release();
	
	var sampler = new SamplerState(SamplerState.LinearClamp);
	sampler.HasMipMap = true;
	this.mFboDepthColourBuffer.TextureObject = new GLTexture2D();
	this.mFboDepthColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	this.mFboDepth.AttachBuffer(this.mFboDepthColourBuffer);
	
	if ( this.mFboBlurColourBuffer != null )
		this.mFboBlurColourBuffer.TextureObject.Release();
		
	sampler.HasMipMap = false;
	this.mFboBlurColourBuffer.TextureObject = new GLTexture2D();
	this.mFboBlurColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	this.mFboBlur.AttachBuffer(this.mFboBlurColourBuffer);
	
	this.mShadowMapShader.DepthMap = this.mFboDepthColourBuffer.TextureObject;
}


/// <summary>
/// Method called when the light source has changed.
/// </summary>
ShadowMapScene.prototype.OnPointLightSourceClicked = function (event)
{
	this.mIsPointLightActive = true;

	// Update FBO
	if ( this.mFboDepthColourBuffer != null )
		this.mFboDepthColourBuffer.TextureObject.Release();
	
	var sampler = new SamplerState(SamplerState.LinearClamp);
	sampler.HasMipMap = true;
	this.mFboDepthColourBuffer.TextureObject = new GLTextureCube();
	this.mFboDepthColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	this.mFboDepth.AttachBuffer(this.mFboDepthColourBuffer);
	
	if ( this.mFboBlurColourBuffer != null )
		this.mFboBlurColourBuffer.TextureObject.Release();
		
	sampler.HasMipMap = false;
	this.mFboBlurColourBuffer.TextureObject = new GLTextureCube();
	this.mFboBlurColourBuffer.TextureObject.Create(this.mFboDimension.x, this.mFboDimension.y, Texture.Format.Rgba, sampler);
	this.mFboBlur.AttachBuffer(this.mFboBlurColourBuffer);
	
	this.mShadowMapCubeShader.DepthMap = this.mFboDepthColourBuffer.TextureObject;
}


/// <summary>
/// Implementation.
/// </summary>
ShadowMapScene.prototype.Update = function ()
{
	BaseScene.prototype.Update.call(this);
	
	// Draw only when all resources have been loaded
	if ( this.mLoadComplete )
	{
		//
		// Animate the light source
		//
		if ( this.mCboxEnableAnimation.checked )
		{
			if ( !this.mIsPointLightActive )
				this.mLightPosition.SetPoint(Math.sin(this.mAnimLightPosition) * 7.0, this.mLightPosition.y, Math.cos(this.mAnimLightPosition) * 7.0);
			else
				this.mLightPosition.SetPoint(Math.sin(this.mAnimLightPosition) * 3.0, this.mLightPosition.y, Math.cos(this.mAnimLightPosition) * 3.0);
			this.mAnimLightPosition += 0.01;
			
			// Update directional light
			this.mDirectionalLight.Direction = this.mLightPosition.Negative().Normalize();
			this.mDirectionalLight.Matrix.PointAt(this.mLightPosition,
												  new Point());
			this.mDirectionalLight.Matrix = this.mDirectionalLight.Matrix.Inverse();
			
			// Update point light
			for (var i = 0; i < 6; ++i)
				this.mPointLightViewMatrix[i].Translate(this.mLightPosition.x, this.mLightPosition.y, this.mLightPosition.z);
		}
	
	
		//
		// Step 1: Render depth map from the light's point of view
		//	
		this.mDepthShader.Enable();
		if ( !this.mIsPointLightActive )
		{
			// Render depth map for a directional light
			this.mDepthShader.View = this.mDirectionalLight.Matrix;

			this.mFboDepth.Enable();
				gl.viewport(0, 0, this.mFboDepth.GetFrameWidth(), this.mFboDepth.GetFrameHeight());
				gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
					
				for (var i = 0; i < this.mEntity.length; ++i)
					this.mDepthShader.Draw(this.mEntity[i]);
			this.mFboDepth.Disable();
		}
		else
		{
			// Render depth maps for a point light (6 in total, one for each cube face)
			for (var f = 0; f < 6; ++f)
			{
				this.mDepthShader.View = this.mPointLightViewMatrix[f].Inverse();
				
				this.mFboDepth.EnableCubemap(gl.TEXTURE_CUBE_MAP_POSITIVE_X + f);
					gl.viewport(0, 0, this.mFboDepth.GetFrameWidth(), this.mFboDepth.GetFrameHeight());
					gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
			
					for (var i = 0; i < this.mEntity.length; ++i)
						this.mDepthShader.Draw(this.mEntity[i]);
			}
			this.mFboDepth.Disable();
		}
		this.mDepthShader.Disable();
		
		
		//
		// Step 2: Blur the shadow map
		// Applicable only with VSM or ESM filtering
		//
		if ( (this.mGaussianBlurShader.BlurAmount > 0) &&
			 (this.mShadowMapShader.FilterType >= 2) )
		{
			if ( !this.mIsPointLightActive )
			{
				this.mGaussianBlurShader.Enable();
				
				// Render horizontal blur
				this.mFboBlur.Enable();
					this.mSurface.ObjectMaterial.Texture[0] = this.mFboDepthColourBuffer.TextureObject;
					this.mGaussianBlurShader.Draw(this.mSurface, 0);
				//this.mFboBlur.Disable();
				
				// Render vertical blur (back into depth map)
				this.mFboDepth.Enable();
					gl.clear(gl.DEPTH_BUFFER_BIT);
					this.mSurface.ObjectMaterial.Texture[0] = this.mFboBlurColourBuffer.TextureObject;
					this.mGaussianBlurShader.Draw(this.mSurface, 1);
				this.mFboDepth.Disable();
				
				this.mGaussianBlurShader.Disable();
			}
			else
			{
				this.mGaussianBlurCubeShader.Enable();
				
				// Bluring cubemap (quite expensive)
				for (var f = 0; f < 6; ++f)
				{
					this.mGaussianBlurCubeShader.CubeFace = f;
				
					// Render horizontal blur
					this.mFboBlur.EnableCubemap(gl.TEXTURE_CUBE_MAP_POSITIVE_X + f);
						this.mSurface.ObjectMaterial.Texture[0] = this.mFboDepthColourBuffer.TextureObject;
						this.mGaussianBlurCubeShader.Draw(this.mSurface, 0);
					//this.mFboBlur.Disable();
					
					// Render vertical blur (back into depth map)
					this.mFboDepth.EnableCubemap(gl.TEXTURE_CUBE_MAP_POSITIVE_X + f);
						gl.clear(gl.DEPTH_BUFFER_BIT);
						this.mSurface.ObjectMaterial.Texture[0] = this.mFboBlurColourBuffer.TextureObject;
						this.mGaussianBlurCubeShader.Draw(this.mSurface, 1);
					//this.mFboDepth.Disable();
				}
				this.mFboDepth.Disable();
				
				this.mGaussianBlurCubeShader.Disable();
			}
		}
		
		
		// Restore viewport
		gl.viewport(0, 0, this.mCanvas.width, this.mCanvas.height);
		
		
		//
		// Step 3: Generate mipmaps for the depth map
		//
		if ( !this.mIsPointLightActive )
			this.mShadowMapShader.DepthMap.CreateMipmaps();
		else
			this.mShadowMapCubeShader.DepthMap.CreateMipmaps();
		
		
		if ( this.mViewState <= 1 )
		{
			// Step 4: Render the scene from the camera's point of view
			// and determine if a pixel is within the shadow by comparing
			// its z-depth against the value recorded in the depth map.
			if ( !this.mIsPointLightActive )
			{
				// Directional light
				this.mShadowMapShader.Enable();
					this.mShadowMapShader.Projection = (this.mViewState == 0) ? this.mProjectionMatrix : this.mLightProjection;
					this.mShadowMapShader.View = (this.mViewState == 0) ? this.mInvViewMatrix : this.mDirectionalLight.Matrix;
					this.mShadowMapShader.LightSourceViewMatrix = this.mDirectionalLight.Matrix;
					
					for (var i = 0; i < this.mEntity.length; ++i)
						this.mShadowMapShader.Draw(this.mEntity[i]);
				this.mShadowMapShader.Disable();
			}
			else
			{
				// Point light
				this.mShadowMapCubeShader.Enable();
					this.mShadowMapCubeShader.Projection = (this.mViewState == 0) ? this.mProjectionMatrix : this.mLightProjection;
					this.mShadowMapCubeShader.View = (this.mViewState == 0) ? this.mInvViewMatrix : this.mDirectionalLight.Matrix;
					
					for (var i = 0; i < this.mEntity.length; ++i)
						this.mShadowMapCubeShader.Draw(this.mEntity[i]);
				this.mShadowMapCubeShader.Disable();
			}
		}
		else
		{
			//
			// Optionally show the current depth map
			// Need to chose between 2D depth map view or cubemap depth map view
			//
			this.mSurface.ObjectMaterial.Texture[0] = this.mFboDepthColourBuffer.TextureObject;
			
			if ( !this.mIsPointLightActive )
			{
				// Directional light
				this.mDepthRenderShader.Enable();
				this.mDepthRenderShader.Draw(this.mSurface);
				this.mDepthRenderShader.Disable();
			}
			else
			{
				// Point light
				this.mDepthRenderCubeShader.Enable();
				this.mDepthRenderCubeShader.Draw(this.mSurface);
				this.mDepthRenderCubeShader.Disable();
			}
		}
	}
}


/// <summary>
/// Implementation.
/// </summary>
ShadowMapScene.prototype.End = function ()
{
	BaseScene.prototype.End.call(this);

	// Cleanup
	if ( this.mFboDepth != null )
		this.mFboDepth.Release();
		
	if ( this.mFboDepthColourBuffer != null )
		this.mFboDepthColourBuffer.TextureObject.Release();
	
	if ( this.mFboBlurColourBuffer != null )
		this.mFboBlurColourBuffer.TextureObject.Release();
	
	if ( this.mFboBlur != null )
		this.mFboBlur.Release();
	
	if ( this.mSurface != null )
		this.mSurface.ObjectEntity.Release();
		
	if ( this.mDepthShader )
		this.mDepthShader.Release();
		
	if ( this.mGaussianBlurShader )
		this.mGaussianBlurShader.Release();
	
	if ( this.mShadowMapShader )
		this.mShadowMapShader.Release();
	
	if ( this.mShadowMapCubeShader )
		this.mShadowMapCubeShader.Release();
	
	if ( this.mDepthRenderShader )
		this.mDepthRenderShader.Release();
	
	if ( this.mDepthRenderCubeShader )
		this.mDepthRenderCubeShader.Release();
}


/// <summary>
/// This method is called when an item for the scene has downloaded. it
/// will increment the resource counter and dispatch an OnLoadComplete
/// event once all items have been downloaded.
/// </summary>
ShadowMapScene.prototype.OnItemLoaded = function (sender, response)
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
ShadowMapScene.prototype.CompileShaders = function (index, list)
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
		this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount + index) / (this.mResource.Item.length * 2.0 + 6.0)) * 100.0));

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
ShadowMapScene.prototype.LoadShaders = function (index)
{
	if ( index == 0 )
	{
		// Create depth map shader program
		this.mDepthShader = new DepthShader();
		this.mDepthShader.Projection = this.mLightProjection;
		this.mDepthShader.Create();
		this.mDepthShader.AddShader(this.mShader[0]);
		this.mDepthShader.AddShader(this.mShader[1]);
		this.mDepthShader.Link();
		this.mDepthShader.Init();
	}
	else if ( index == 1 )
	{
		// Create gaussian blur shader program
		this.mGaussianBlurShader = new GaussianBlurShader();
		this.mGaussianBlurShader.Projection = this.mOrthographicMatrix;
		this.mGaussianBlurShader.View = new Matrix(4, 4);
		this.mGaussianBlurShader.Create();
		this.mGaussianBlurShader.AddShader(this.mShader[2]);
		this.mGaussianBlurShader.AddShader(this.mShader[3]);
		this.mGaussianBlurShader.Link();
		this.mGaussianBlurShader.Init();
		this.mGaussianBlurShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
		this.mGaussianBlurShader.BlurAmount = 5;
	}
	else if ( index == 2 )
	{	
		// Create gaussian blur cube shader program
		this.mGaussianBlurCubeShader = new GaussianBlurShader();
		this.mGaussianBlurCubeShader.Projection = this.mOrthographicMatrix;
		this.mGaussianBlurCubeShader.View = new Matrix(4, 4);
		this.mGaussianBlurCubeShader.Create();
		this.mGaussianBlurCubeShader.AddShader(this.mShader[2]);
		this.mGaussianBlurCubeShader.AddShader(this.mShader[4]);
		this.mGaussianBlurCubeShader.Link();
		this.mGaussianBlurCubeShader.Init();
		this.mGaussianBlurCubeShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
		this.mGaussianBlurCubeShader.BlurAmount = 5;
	}
	else if ( index == 3 )
	{
		// Create shadow map shader program
		this.mShadowMapShader = new ShadowMapShader();
		this.mShadowMapShader.Projection = this.mProjectionMatrix;
		this.mShadowMapShader.View = this.mInvViewMatrix;
		this.mShadowMapShader.LightSourceProjectionMatrix = this.mLightProjection;
		this.mShadowMapShader.Create();
		this.mShadowMapShader.AddShader(this.mShader[5]);
		this.mShadowMapShader.AddShader(this.mShader[6]);
		this.mShadowMapShader.Link();
		this.mShadowMapShader.Init();
		this.mShadowMapShader.LightObject.push(this.mDirectionalLight);
		this.mShadowMapShader.DepthMap = this.mFboDepthColourBuffer.TextureObject;
	}
	else if ( index == 4 )
	{
		// Create shadow map cube shader program
		this.mShadowMapCubeShader = new ShadowMapShader();
		this.mShadowMapCubeShader.Projection = this.mProjectionMatrix;
		this.mShadowMapCubeShader.View = this.mInvViewMatrix;
		this.mShadowMapCubeShader.LightSourceProjectionMatrix = this.mLightProjection;
		this.mShadowMapCubeShader.Create();
		this.mShadowMapCubeShader.AddShader(this.mShader[5]);
		this.mShadowMapCubeShader.AddShader(this.mShader[7]);
		this.mShadowMapCubeShader.Link();
		this.mShadowMapCubeShader.Init();
		this.mShadowMapCubeShader.LightObject.push(this.mPointLight);
		this.mShadowMapCubeShader.DepthMap = this.mFboDepthColourBuffer.TextureObject;
	}
	else if ( index == 5 )
	{
		// Create depth render shader program
		this.mDepthRenderShader = new DepthRenderShader();
		this.mDepthRenderShader.Projection = this.mOrthographicMatrix;
		this.mDepthRenderShader.View = new Matrix(4, 4);
		this.mDepthRenderShader.Create();
		this.mDepthRenderShader.AddShader(this.mShader[8]);
		this.mDepthRenderShader.AddShader(this.mShader[9]);
		this.mDepthRenderShader.Link();
		this.mDepthRenderShader.Init();
		this.mDepthRenderShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
	}
	else if ( index == 6 )
	{
		// Create depth render cubemap shader program
		this.mDepthRenderCubeShader = new DepthRenderShader();
		this.mDepthRenderCubeShader.Projection = this.mOrthographicMatrix;
		this.mDepthRenderCubeShader.View = new Matrix(4, 4);
		this.mDepthRenderCubeShader.Create();
		this.mDepthRenderCubeShader.AddShader(this.mShader[8]);
		this.mDepthRenderCubeShader.AddShader(this.mShader[10]);
		this.mDepthRenderCubeShader.Link();
		this.mDepthRenderCubeShader.Init();
		this.mDepthRenderCubeShader.SetSize(this.mFboDimension.x, this.mFboDimension.y);
		
		// Hide loading screen
		if ( this.mDivLoading != null )
			this.mDivLoading.hide();
		
		this.mLoadComplete = true;
	}
	
	if ( index < 6 )
	{
		// Update loading progress
		++index;
		if ( this.mTxtLoadingProgress != null )
			this.mTxtLoadingProgress.html(Math.floor(((this.mResourceCount * 2.0 + index) / (this.mResource.Item.length * 2.0 + 6.0)) * 100.0));
	
		// Move on
		var parent = this;
		setTimeout(function () { parent.LoadShaders(index) }, 1);
	}
}


/// <summary>
/// Implementation.
/// </summary>
ShadowMapScene.prototype.OnLoadComplete = function ()
{
	// Process shaders
	var shaderResource = new Array();
	shaderResource.push(this.mResource.Find("depth.vs"));
	shaderResource.push(this.mResource.Find("depth.fs"));
	shaderResource.push(this.mResource.Find("gaussianBlur.vs"));
	shaderResource.push(this.mResource.Find("gaussianBlur.fs"));
	shaderResource.push(this.mResource.Find("gaussianBlurCube.fs"));
	shaderResource.push(this.mResource.Find("shadowMap.vs"));
	shaderResource.push(this.mResource.Find("shadowMap.fs"));
	shaderResource.push(this.mResource.Find("shadowMapCube.fs"));
	shaderResource.push(this.mResource.Find("depthImage.vs"));
	shaderResource.push(this.mResource.Find("depthImage.fs"));
	shaderResource.push(this.mResource.Find("depthImageCube.fs"));
	
	// Compile shaders
	this.CompileShaders(0, shaderResource);
}