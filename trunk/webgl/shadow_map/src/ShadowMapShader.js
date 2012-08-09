
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




// The shadow map shader is a basic shader that also takes into account a depth map
// rendered from the light's point of view to determine if a pixel is in shadow.




// Constructor.

function ShadowMapShader ()
{
	
	// Setup inherited members.
	
	BasicShader.call(this);
	
	
	
	// Shader variables.
	
	this.mLightSourceProjectionMatrixId;
	this.mLightSourceViewMatrixId;
	this.mDepthMapId;
	this.mDepthCubeMapId;
	this.mFilterTypeId;
	

	
	// View matrix at the light source. This is used only if the light source
	// is directional. Point light sources will calculate the 6 projection matrices
	// in realtime and check the cubemap.
	
	this.LightSourceProjectionMatrix;
	this.LightSourceViewMatrix;
	
	
	
	// Depth map texture to use. It may be 2D or cubemap. The shader will check the
	// light source type and assume the correct depth map was passed in. That is,
	// directional lights will use Texture2D and point lights will use TextureCube.
	
	this.DepthMap;
	this.DepthCubeMap;
	
	
	
	// Specifies the type of shadow map filtering to perform.
	// 0 = None
	// 1 = PCM
	// 2 = VSM
	// 3 = ESM
	
	this.FilterType = 0;
}



// Prototypal Inheritance.

ShadowMapShader.prototype = new BasicShader();
ShadowMapShader.prototype.constructor = ShadowMapShader;



// Implementation.

ShadowMapShader.prototype.Init = function ()
{
	BasicShader.prototype.Init.call(this);
	
	// Get texture samples
	this.mDepthMapId = this.getVariable("DepthMap");
	this.mDepthCubeMapId = this.getVariable("DepthCubeMap");
	
	// Get matrices
	this.mLightSourceProjectionMatrixId = this.getVariable("LightSourceProjectionMatrix");
	this.mLightSourceViewMatrixId = this.getVariable("LightSourceViewMatrix");
	this.LightSourceViewMatrix = new Matrix(4, 4);
	
	// Get variables
	this.mFilterTypeId = this.getVariable("FilterType");
}



// Implementation.

ShadowMapShader.prototype.Enable = function ()
{
	BasicShader.prototype.Enable.call(this);
	
	// Set light projection
	this.setMatrix(this.mLightSourceProjectionMatrixId, this.LightSourceProjectionMatrix.MMatrix, 4);
	
	// Set variables
	this.setVariableInt(this.mFilterTypeId, this.FilterType);
	
	// Set depth map sample
	gl.activeTexture(gl.TEXTURE0);
	if ( this.DepthMap )
		this.DepthMap.Bind();
	else if ( this.DepthCubeMap )
		this.DepthCubeMap.Bind();
}



// Implementation.

ShadowMapShader.prototype.Draw = function (entity, numPoints, numIndices)
{
	// Matrices
	this.setMatrix(this.mLightSourceViewMatrixId, this.LightSourceViewMatrix.MMatrix, 4);

	// Draw
	BasicShader.prototype.Draw.call(this, entity, numPoints, numIndices);
}