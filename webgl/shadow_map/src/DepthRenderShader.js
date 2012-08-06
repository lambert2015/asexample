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
/// This shader renders the depth map to the screen, letting you visualize how it looks.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
function DepthRenderShader ()
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	ImageShader.call(this);
	
	
	/// <summary>
	/// Shader variables.
	/// </summary>
	this.mFilterTypeId;
	this.mSampleCubeId;
	
	
	/// <summary>
	/// Specifies the type of shadow map filtering to perform.
	/// 0 = None
	/// 1 = PCM
	/// 2 = VSM
	/// 3 = ESM
	/// </summary>
	this.FilterType = 0;
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
DepthRenderShader.prototype = new ImageShader();
DepthRenderShader.prototype.constructor = DepthRenderShader;


/// <summary>
/// Implementation.
/// </summary>
DepthRenderShader.prototype.Init = function ()
{
	ImageShader.prototype.Init.call(this);

	// Get variables
	this.mFilterTypeId = this.GetVariable("FilterType");
}


/// <summary>
/// Implementation.
/// </summary>
DepthRenderShader.prototype.Enable = function ()
{
	ImageShader.prototype.Enable.call(this);
	
	// Set variables
	this.SetVariableInt(this.mFilterTypeId, this.FilterType);
}