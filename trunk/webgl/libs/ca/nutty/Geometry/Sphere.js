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
/// This class creates a spherical mesh.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
/// <param name="numSegments">Number of horizontal segments to create.</param>
/// <param name="numRings">Number of vertical rings to create.</param>
/// <param name="radius">Radius of the sphere.</param>
/// <param name="cutoff">Amount of sphere to cutoff. 0.5 generates a hemisphere.</param>
function Sphere (numSegments, numRings, radius, cutoff)
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	PolygonMesh.call(this);
	
	
	cutoff = 1.0 - cutoff;
	var actualRings = (numRings * cutoff);

	// One centre point + points along the circle
	this.Create(numSegments * actualRings, ((numSegments - 1) * 6) * (actualRings - 1));

	// Points on shape
	var index = 0;
	var point = 0;

	for (var y = 0; y < actualRings; ++y)
	{
		var v = y / (numRings - 1.0);
		var yAngle = v * Math.PI;
		var yPos = Math.cos(yAngle) * radius;
		var r = Math.sin(yAngle) * radius;

		for (var x = 0; x < numSegments; ++x)
		{
			var u = x / (numSegments - 1.0);
			var xAngle = u * (2.0 * Math.PI);
			this.SetPoint(point, new Point(Math.cos(xAngle) * r, Math.sin(xAngle) * r, yPos));
			this.SetUV(point, new Point(u, v));

			// Set indices
			if ( (y > 0) && (x < (numSegments - 1)) )
			{
				var p = point - numSegments;

				this.Index[index * 3 + 0] = p;
				this.Index[index * 3 + 1] = point;
				this.Index[index * 3 + 2] = point + 1;
				++index;

				this.Index[index * 3 + 0] = point + 1;
				this.Index[index * 3 + 1] = p + 1;
				this.Index[index * 3 + 2] = p;
				++index;
			}

			++point;
		}
	}

	// Set Normals
	this.CreateNormals();

	// Average normals along the polars
	for (var x = 0; x < numSegments; ++x)
	{
		var index1 = x * 3;
		this.Normal[index1 + 0] = 0.0;
		this.Normal[index1 + 1] = 0.0;
		this.Normal[index1 + 2] = 1.0;

		if ( actualRings == numRings )
		{
			index1 = (this.VertexPoint.length - 3) - index1;
			this.Normal[index1 + 0] = 0.0;
			this.Normal[index1 + 1] = 0.0;
			this.Normal[index1 + 2] = -1.0;
		}
	}

	// Average normals along the seam
	for (var y = 1; y < (actualRings - 1); ++y)
	{
		var index1 = (y * numSegments) * 3;
		var index2 = index1 + ((numSegments - 1) * 3);

		this.Normal[index1 + 0] = (this.Normal[index1 + 0] + this.Normal[index2 + 0]) * 0.5;
		this.Normal[index1 + 1] = (this.Normal[index1 + 1] + this.Normal[index2 + 1]) * 0.5;
		this.Normal[index1 + 2] = (this.Normal[index1 + 2] + this.Normal[index2 + 2]) * 0.5;

		this.Normal[index2 + 0] = this.Normal[index1 + 0];
		this.Normal[index2 + 1] = this.Normal[index1 + 1];
		this.Normal[index2 + 2] = this.Normal[index1 + 2];
	}
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
Sphere.prototype = new PolygonMesh();
Sphere.prototype.constructor = Sphere;