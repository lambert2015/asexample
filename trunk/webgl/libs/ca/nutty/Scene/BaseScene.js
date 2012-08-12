// The BaseScene represents common logic shared between all scenes.
function BaseScene ()
{
	// Array containing a list of resources used by this scene. They are usually
	// downloaded from the server at runtime.
	this.mResource = new ResourceManager();
	
	// Counter to track how many of the resource items have downloaded.
	this.mResourceCount = 0;

	// Stores a list of renderable entities associated with this scene.
	this.mEntity = [];
	
	// Stores a list of shaders associated with this scene.
	this.mShader = [];
	
	// Perspective matrix to render 2d or 3d environments.
	this.mProjectionMatrix = null;
	this.mOrthographicMatrix = null;
	
	// View matrix (ie: the camera).
	this.mViewMatrix = null;
	
	// Set to true when all resources have been loaded and it's safe to
	// begin updating the scene.
	this.mLoadComplete = false;
}

// This method is called when the scene is loading. Implementations
// should override this method to perform custom startup logic.
BaseScene.prototype.start = function ()
{
	// Setup members
	this.mProjectionMatrix = ViewMatrix.perspective(45.0, 1.333, 0.1, 100.0);
	this.mOrthographicMatrix = ViewMatrix.orthographic(1.0, 1.0, 0.1, 100.0);
	this.mViewMatrix = new Matrix();
	
	// Setup OpenGL
	gl.clearColor(1.0, 1.0, 1.0, 0.0);
	gl.clearDepth(1.0);
	
	//gl.enable(gl.CULL_FACE);
	//gl.frontFace(gl.CCW);
	gl.enable(gl.DEPTH_TEST);
	gl.enable(gl.BLEND);
	
	// Download resources
	for (var i = 0; i < this.mResource.items.length; ++i)
	{
		var httpState = new Object();
		httpState.parent = this;
		httpState.resource = this.mResource.items[i];
	
		// Images are loaded differently	
		if ( (httpState.resource.uri.lastIndexOf(".jpg") >= 0) ||
			 (httpState.resource.uri.lastIndexOf(".png") >= 0) )
		{
			var image = new Image();
			image.onload = this.onImageLoad;
			image.onerror = this.onImageError;
			image.state = httpState;
			image.src = httpState.resource.uri;
		}
		else
		{
			var request = new HttpRequest(this.onHttpResponse);
			request.sendRequest(HttpRequest.Method.GET, httpState.resource.uri, null, httpState, true);
		}
	}
}

// This method is called for each frame rendered in the application.
// Derived scenes should implement this method to perform any rendering.
BaseScene.prototype.update = function ()
{
	// Clear buffers
	gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
}

// This method is called when the scene is no longer needed.
// Implementations should override this method to perform custom
// shutdown logic.
BaseScene.prototype.end = function ()
{
	// Cleanup
	for (var i = 0; i < this.mEntity.length; ++i)
		this.mEntity[i].objectEntity.release();
	this.mEntity[i] = [];
	
	for (var i = 0; i < this.mShader.length; ++i)
		this.mShader[i].release();
	this.mShader[i] = [];
}

// This method is called when an item for the scene has downloaded. it
// will increment the resource counter and dispatch an onLoadComplete
// event once all items have been downloaded.
BaseScene.prototype.onItemLoaded = function (sender, response)
{
	++this.mResourceCount;
	if ( this.mResourceCount == this.mResource.items.length )
	{
		// All resources have been downloaded
		this.onLoadComplete();
	}
}

// This method is called when the image source has successfully loaded.
BaseScene.prototype.onImageLoad = function ()
{
	this.state.resource.item = this;
	this.state.parent.onItemLoaded();
}

// This method is called when the image source failed to load.
BaseScene.prototype.onImageError = function ()
{
	this.state.resource.item = null;
	this.state.parent.onItemLoaded();
}

// This method is called when a response has been received for a 
// particular resource item.
BaseScene.prototype.onHttpResponse = function (sender, response)
{
	response.state.resource.item = response.responseText;
	response.state.parent.onItemLoaded();
}

// This method is called once all resources have loaded. The scene
// should override this method and perform any load logic on the
// resource items.
BaseScene.prototype.onLoadComplete = function ()
{
	this.mLoadComplete = true;
}