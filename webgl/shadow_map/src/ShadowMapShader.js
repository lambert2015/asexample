// <summary>
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
// </summary>


// <summary>
// The shadow map shader is a basic shader that also takes into account a depth map
// rendered from the light's point of view to determine if a pixel is in shadow.
// </summary>


// <summary>
// Constructor.
// </summary>
function ShadowMapShader ()
{
	// <summary>
	// Setup inherited members.
	// </summary>
	BasicShader.call(this);
	
	
	// <summary>
	// Shader variables.
	// </summary>
	this.mLightSourceProjectionMatrixId;
	this.mLightSourceViewMatrixId;
	this.mDepthMapId;
	this.mDepthCubeMapId;
	this.mFilterTypeId;
	

	// <summary>
	// View matrix at the light source. This is used only if the light source
	// is directional. Point light sources will calculate the 6 projection matrices
	// in realtime and check the cubemap.
	// </summary>
	this.LightSourceProjectionMatrix;
	this.LightSourceViewMatrix;
	
	
	// <summary>
	// Depth map texture to use. It may be 2D or cubemap. The shader will check the
	// light source type and assume the correct depth map was passed in. That is,
	// directional lights will use Texture2D and point lights will use TextureCube.
	// </summary>
	this.DepthMap;
	this.DepthCubeMap;
	
	
	// <summary>
	// Specifies the type of shadow map filtering to perform.
	// 0 = None
	// 1 = PCM
	// 2 = VSM
	// 3 = ESM
	// </summary>
	this.FilterType = 0;
}


// <summary>
// Prototypal Inheritance.
// </summary>
ShadowMapShader.prototype = new BasicShader();
ShadowMapShader.prototype.constructor = ShadowMapShader;


// <summary>
// Implementation.
// </summary>
ShadowMapShader.prototype.Init = function ()
{
	BasicShader.prototype.Init.call(this);
	
	// Get texture samples
	this.mDepthMapId = this.GetVariable("DepthMap");
	this.mDepthCubeMapId = this.GetVariable("DepthCubeMap");
	
	// Get matrices
	this.mLightSourceProjectionMatrixId = this.GetVariable("LightSourceProjectionMatrix");
	this.mLightSourceViewMatrixId = this.GetVariable("LightSourceViewMatrix");
	this.LightSourceViewMatrix = new Matrix(4, 4);
	
	// Get variables
	this.mFilterTypeId = this.GetVariable("FilterType");
}


// <summary>
// Implementation.
// </summary>
ShadowMapShader.prototype.Enable = function ()
{
	BasicShader.prototype.Enable.call(this);
	
	// Set light projection
	this.SetMatrix(this.mLightSourceProjectionMatrixId, this.LightSourceProjectionMatrix.MMatrix, 4);
	
	// Set variables
	this.SetVariableInt(this.mFilterTypeId, this.FilterType);
	
	// Set depth map sample
	gl.activeTexture(gl.TEXTURE0);
	if ( this.DepthMap )
		this.DepthMap.Bind();
	else if ( this.DepthCubeMap )
		this.DepthCubeMap.Bind();
}


// <summary>
// Implementation.
// </summary>
ShadowMapShader.prototype.Draw = function (entity, numPoints, numIndices)
{
	// Matrices
	this.SetMatrix(this.mLightSourceViewMatrixId, this.LightSourceViewMatrix.MMatrix, 4);

	// Draw
	BasicShader.prototype.Draw.call(this, entity, numPoints, numIndices);
}