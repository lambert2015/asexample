// <summary>
// The BaseScene represents common logic shared between all scenes.
// </summary>


// <summary>
// Constructor.
// </summary>
function BaseScene ()
{
	// <summary>
	// Array containing a list of resources used by this scene. They are usually
	// downloaded from the server at runtime.
	// </summary>
	this.mResource = new ResourceManager();
	
	
	// <summary>
	// Counter to track how many of the resource items have downloaded.
	// </summary>
	this.mResourceCount = 0;
	
	
	// <summary>
	// Stores a list of renderable entities associated with this scene.
	// </summary>
	this.mEntity = new Array();
	
	
	// <summary>
	// Stores a list of shaders associated with this scene.
	// </summary>
	this.mShader = new Array();
	
	
	// <summary>
	// Perspective matrix to render 2d or 3d environments.
	// </summary>
	this.mProjectionMatrix = null;
	this.mOrthographicMatrix = null;
	
	
	// <summary>
	// View matrix (ie: the camera).
	// </summary>
	this.mViewMatrix = null;
	
	
	// <summary>
	// Set to true when all resources have been loaded and it's safe to
	// begin updating the scene.
	// </summary>
	this.mLoadComplete = false;
}


// <summary>
// This method is called when the scene is loading. Implementations
// should override this method to perform custom startup logic.
// </summary>
BaseScene.prototype.Start = function ()
{
	// Setup members
	this.mProjectionMatrix = ViewMatrix.Perspective(45.0, 1.333, 0.1, 100.0);
	this.mOrthographicMatrix = ViewMatrix.Orthographic(1.0, 1.0, 0.1, 100.0);
	this.mViewMatrix = new Matrix();
	
	// Setup OpenGL
	gl.clearColor(1.0, 1.0, 1.0, 0.0);
	gl.clearDepth(1.0);
	
	//gl.enable(gl.CULL_FACE);
	//gl.frontFace(gl.CCW);
	gl.enable(gl.DEPTH_TEST);
	gl.enable(gl.BLEND);
	
	// Download resources
	for (var i = 0; i < this.mResource.Item.length; ++i)
	{
		var httpState = new Object();
		httpState.Parent = this;
		httpState.Resource = this.mResource.Item[i];
	
		// Images are loaded differently	
		if ( (httpState.Resource.Uri.lastIndexOf(".jpg") >= 0) ||
			 (httpState.Resource.Uri.lastIndexOf(".png") >= 0) )
		{
			var image = new Image();
			image.onload = this.OnImageLoad;
			image.onerror = this.OnImageError;
			image.State = httpState;
			image.src = httpState.Resource.Uri;
		}
		else
		{
			var request = new HttpRequest(this.OnHttpResponse);
			request.SendRequest(HttpRequest.Method.GET, httpState.Resource.Uri, null, httpState, true);
		}
	}
}


// <summary>
// This method is called for each frame rendered in the application.
// Derived scenes should implement this method to perform any rendering.
// </summary>
BaseScene.prototype.Update = function ()
{
	// Clear buffers
	gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
}


// <summary>
// This method is called when the scene is no longer needed.
// Implementations should override this method to perform custom
// shutdown logic.
// </summary>
BaseScene.prototype.End = function ()
{
	// Cleanup
	for (var i = 0; i < this.mEntity.length; ++i)
		this.mEntity[i].ObjectEntity.Release();
	this.mEntity[i] = new Array();
	
	for (var i = 0; i < this.mShader.length; ++i)
		this.mShader[i].Release();
	this.mShader[i] = new Array();
}


// <summary>
// This method is called when an item for the scene has downloaded. it
// will increment the resource counter and dispatch an OnLoadComplete
// event once all items have been downloaded.
// </summary>
BaseScene.prototype.OnItemLoaded = function (sender, response)
{
	++this.mResourceCount;
	if ( this.mResourceCount == this.mResource.Item.length )
	{
		// All resources have been downloaded
		this.OnLoadComplete();
	}
}


// <summary>
// This method is called when the image source has successfully loaded.
// </summary>
BaseScene.prototype.OnImageLoad = function ()
{
	this.State.Resource.Item = this;
	this.State.Parent.OnItemLoaded();
}


// <summary>
// This method is called when the image source failed to load.
// </summary>
BaseScene.prototype.OnImageError = function ()
{
	this.State.Resource.Item = null;
	this.State.Parent.OnItemLoaded();
}


// <summary>
// This method is called when a response has been received for a 
// particular resource item.
// </summary>
BaseScene.prototype.OnHttpResponse = function (sender, response)
{
	response.State.Resource.Item = response.ResponseText;
	response.State.Parent.OnItemLoaded();
}


// <summary>
// This method is called once all resources have loaded. The scene
// should override this method and perform any load logic on the
// resource items.
// </summary>
BaseScene.prototype.OnLoadComplete = function ()
{
	this.mLoadComplete = true;
}