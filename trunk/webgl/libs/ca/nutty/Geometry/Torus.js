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
/// This class creates a torus mesh.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
/// <param name="numSegments">Number of horizontal segments to create.</param>
/// <param name="numRings">Number of vertical rings to create.</param>
/// <param name="radius">Radius of the tube.</param>
/// <param name="distance">Distance from the centre of the torus to the centre of the tube.</param>
function Torus (numSegments, numRings, radius, distance)
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	PolygonMesh.call(this);
	
	
	// One centre point + points along the circle
	this.Create(numSegments * numRings, ((numSegments - 1) * 6) * (numRings - 1));

	// Range between 0 and 2PI
	var u;
	var v;

	var point = 0;
	var index = 0;

	for (var i = 0; i < numRings; ++i)
	{
		v = (i / (numRings - 1.0)) * (2.0 * Math.PI);

		// One ring (circle) in the torus
		for (var j = 0; j < numSegments; ++j)
		{
			u = (j / (numSegments - 1.0)) * (2.0 * Math.PI);

			var w = distance + (radius * Math.cos(v));
			var x = w * Math.cos(u);
			var y = w * Math.sin(u);
			var z = radius * Math.sin(v);

			this.SetPoint(point, new Point(x, y, z));
			this.SetUV(point, new Point(i / (numRings - 1.0), j / (numSegments - 1.0)));
			
			if ( (i < (numRings - 1)) && (j < (numSegments - 1)) )
			{
				this.Index[index    ] = point;
				this.Index[index + 1] = point + 1;
				this.Index[index + 2] = point + 1 + numSegments;

				this.Index[index + 3] = point + 1 + numSegments;
				this.Index[index + 4] = point + numSegments;
				this.Index[index + 5] = point;
				
				index += 6;
			}
			
			++point;
		}
	}
	
	// Set Normals
	this.CreateNormals();
	
	// Average normals along the seam
	var index2;
	for (var i = 0; i < numRings; ++i)
	{
		index = i * numSegments * 3;
		index2 = index + (numSegments - 1) * 3;

		this.Normal[index    ] = (this.Normal[index    ] + this.Normal[index2    ]) * 0.5;
		this.Normal[index + 1] = (this.Normal[index + 1] + this.Normal[index2 + 1]) * 0.5;
		this.Normal[index + 2] = (this.Normal[index + 2] + this.Normal[index2 + 2]) * 0.5;

		this.Normal[index2    ] = this.Normal[index];
		this.Normal[index2 + 1] = this.Normal[index + 1];
		this.Normal[index2 + 2] = this.Normal[index + 2];
	}

	// Average normals along the seam
	var endIndex = (numRings - 1) * numSegments * 3;
	for (var i = 0; i < numSegments; ++i)
	{
		index = i * 3;
		this.Normal[index    ] = (this.Normal[index    ] + this.Normal[index + endIndex    ]) * 0.5;
		this.Normal[index + 1] = (this.Normal[index + 1] + this.Normal[index + endIndex + 1]) * 0.5;
		this.Normal[index + 2] = (this.Normal[index + 2] + this.Normal[index + endIndex + 2]) * 0.5;

		this.Normal[index + endIndex    ] = this.Normal[index];
		this.Normal[index + endIndex + 1] = this.Normal[index + 1];
		this.Normal[index + endIndex + 2] = this.Normal[index + 2];
	}
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
Torus.prototype = new PolygonMesh();
Torus.prototype.constructor = Torus;