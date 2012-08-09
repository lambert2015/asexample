// The MainApp handles the application entry and exit points. It is used
// to initialize and render the scenes.

// Stores the active scene to be rendered.
// This must be initially set by the index page.
var currentScene = null;

// Function called when the HTML page has loaded.
// Initialize page.
AppLoad = function ()
{
	// Initialize UI
	var tabs = $("#tabs");
	tabs.tabs();
	tabs.show();
}

// This method is called when the HTML page has loaded.
AppStart = function ()
{
	// Initialize WebGL
	var canvas = document.getElementById("Canvas");
	try
	{
		gl = canvas.getContext("experimental-webgl");
		gl.viewport(0.0, 0.0, canvas.width, canvas.height);
		
		// Start main scene
		if ( currentScene != null )
		{
			$("#DivStart").hide();
			$("#WebGLDemo").show();
		
			currentScene.Start();

			// Start renderer
			AppRender();
		}
	}
	catch ( error )
	{
		// Does not support WebGL
		$("#DivNoWebGL").show();
		$("#BtnStartWebGL").hide();
	}
}

// This method is called when the HTML page is unloading.
AppStop = function ()
{
	// Cleanup
	if ( currentScene )
	{
		currentScene.End();
		currentScene = null;
	}
}

// This method is called when a new frame is to be rendered
// in the browser. Typically, this function is called 60 times
// per second.
AppRender = function ()
{
	if ( currentScene )
	{
		// Render the current scene
		currentScene.Update();
		
		// HTML standards at its finest. Bind this function to the
		// next frame cycle.
		if ( window.requestAnimationFrame )
			window.requestAnimationFrame(AppRender);
		else if ( window.webkitRequestAnimationFrame )
			window.webkitRequestAnimationFrame(AppRender);
		else if ( window.mozRequestAnimationFrame )
			window.mozRequestAnimationFrame(AppRender);
		else if ( window.oRequestAnimationFrame )
			window.oRequestAnimationFrame(AppRender);
		else if ( window.msRequestAnimationFrame )
			window.msRequestAnimationFrame(AppRender);
	}
}