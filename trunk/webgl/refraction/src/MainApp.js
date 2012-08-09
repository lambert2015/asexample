
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
	
	tabs = $("#vertex-tabs");
	tabs.tabs();
	
	tabs = $("#fragment-tabs");
	tabs.tabs();
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