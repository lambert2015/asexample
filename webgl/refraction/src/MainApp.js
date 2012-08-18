// The MainApp handles the application entry and exit points. It is used
// to initialize and render the scenes.

// Stores the active scene to be rendered.
// This must be initially set by the index page.

var currentScene = null;

// Function called when the HTML page has loaded.
// Initialize page.

appLoad = function() {
	// Initialize UI
	var tabs = $("#tabs");
	tabs.tabs();
	tabs.show();

	tabs = $("#vertex-tabs");
	tabs.tabs();

	tabs = $("#fragment-tabs");
	tabs.tabs();
}
// This method is called when the HTML page has loaded.

appStart = function() {
	// Initialize WebGL
	var canvas = document.getElementById("Canvas");
	try {
		gl = canvas.getContext("experimental-webgl");
		gl.viewport(0.0, 0.0, canvas.width, canvas.height);

		// Start main scene
		if (currentScene != null) {
			$("#DivStart").hide();
			$("#WebGLDemo").show();

			currentScene.Start();

			// Start renderer
			appRender();
		}
	} catch ( error ) {
		// Does not support WebGL
		$("#DivNoWebGL").show();
		$("#BtnStartWebGL").hide();
	}
}
// This method is called when the HTML page is unloading.

appStop = function() {
	// Cleanup
	if (currentScene) {
		currentScene.End();
		currentScene = null;
	}
}
// This method is called when a new frame is to be rendered
// in the browser. Typically, this function is called 60 times
// per second.

appRender = function() {
	if (currentScene) {
		// Render the current scene
		currentScene.Update();

		// HTML standards at its finest. Bind this function to the
		// next frame cycle.
		if (window.requestAnimationFrame)
			window.requestAnimationFrame(appRender);
		else if (window.webkitRequestAnimationFrame)
			window.webkitRequestAnimationFrame(appRender);
		else if (window.mozRequestAnimationFrame)
			window.mozRequestAnimationFrame(appRender);
		else if (window.oRequestAnimationFrame)
			window.oRequestAnimationFrame(appRender);
		else if (window.msRequestAnimationFrame)
			window.msRequestAnimationFrame(appRender);
	}
}