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
/// This class creates a cone mesh.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
/// <param name="numPoint">Number of points to create for this shape.</param>
/// <param name="radius">Radius of the circle.</param>
/// <param name="height">Height of the cone.</param>
function Cone (numPoint, radius, height)
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	PolygonMesh.call(this);
	
	
	// One centre point + points along the circle
	this.Create(numPoint + 1, numPoint * 3);

	// Centre point
	this.SetPoint(0, new Point(0.0, 0.0, height));
	this.SetUV(0, new Point(0.5, 0.5));

	// Points on shape
	for (var i = 0; i < numPoint; ++i)
	{
		var angle = (i / numPoint) * (2.0 * Math.PI);
		this.SetPoint(i + 1, new Point(Math.cos(angle) * radius, Math.sin(angle) * radius));
		this.SetUV(i + 1, new Point((Math.cos(angle) + 1.0) * 0.5, (Math.sin(angle) + 1.0) * 0.5));

		this.Index[i * 3 + 0] = 0;
		if ( i == (numPoint - 1) )
		{
			this.Index[i * 3 + 1] = i + 1;
			this.Index[i * 3 + 2] = 1;
		}
		else
		{
			this.Index[i * 3 + 1] = i + 1;
			this.Index[i * 3 + 2] = i + 2;
		}
	}

	// Set Normals
	this.CreateNormals();
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
Cone.prototype = new PolygonMesh();
Cone.prototype.constructor = Cone;