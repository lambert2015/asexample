
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




// This shader renders geometry to the alpha channel, which will be used by the refraction shader
// to process tagged pixels. The fragment shader will tag pixels by setting their alpha value to 0.




// Constructor.

function BlendShader ()
{
	
	// Setup inherited members.
	
	ImageShader.call(this);
	
	
	
	// Shader variables.
	
	this.mSrcColourId = null;
	this.mDstColourId = null;
	
	
	// Matrices not used
	this.Projection = new Matrix(4, 4);
	this.View = new Matrix(4, 4);
}



// Prototypal Inheritance.

BlendShader.prototype = new ImageShader();
BlendShader.prototype.constructor = BlendShader;



// Colour (tint) applied to the destination texture.
// Variable is static so that the colour applies to all blend modes.

BlendShader.DstColour = new Point(1, 1, 1, 1);



// Colour (tint) applied to the source texture.
// Variable is static so that the colour applies to all blend modes.

BlendShader.SrcColour = new Point(1, 1, 1, 1);



// Implementation.

BlendShader.prototype.Init = function ()
{
	ImageShader.prototype.Init.call(this);
	
	// Get shader variables
	this.mSrcColourId = this.GetVariable("SrcColour");
	this.mDstColourId = this.GetVariable("DstColour");
}



// Implementation.

BlendShader.prototype.Enable = function ()
{
	ImageShader.prototype.Enable.call(this);
	
	// Set colours
	this.SetVariable(this.mDstColourId, BlendShader.DstColour.x, BlendShader.DstColour.y, BlendShader.DstColour.z, BlendShader.DstColour.w);
	this.SetVariable(this.mSrcColourId, BlendShader.SrcColour.x, BlendShader.SrcColour.y, BlendShader.SrcColour.z, BlendShader.SrcColour.w);
}