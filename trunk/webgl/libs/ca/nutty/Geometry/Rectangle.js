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
/// This class creates a rectangular mesh.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
/// <param name="x">X-Axis extent of the rectangle.</param>
/// <param name="y">Y-Axis extent of the rectangle.</param>
function Rectangle (x, y)
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	PolygonMesh.call();
	
	
	// Create two triangles
	this.Create(4, 6);

	// Set points
	this.SetPoint(0, new Point(-x, -y));
	this.SetPoint(1, new Point(x, -y));
	this.SetPoint(2, new Point(x, y));
	this.SetPoint(3, new Point(-x, y));

	// Set uv
	this.SetUV(0, new Point(0.0, 0.0));
	this.SetUV(1, new Point(1.0, 0.0));
	this.SetUV(2, new Point(1.0, 1.0));
	this.SetUV(3, new Point(0.0, 1.0));

	// Set indices
	this.Index[0] = 0;
	this.Index[1] = 1;
	this.Index[2] = 2;

	this.Index[3] = 2;
	this.Index[4] = 3;
	this.Index[5] = 0;

	// Set Normals
	this.CreateNormals();
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
Rectangle.prototype = new PolygonMesh();
Rectangle.prototype.constructor = Rectangle;