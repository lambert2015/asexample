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
/// This class creates a cube mesh.
/// </summary>


/// <summary>
/// Constructor.
/// </summary>
/// <param name="x">X-Axis extent of the cube.</param>
/// <param name="y">Y-Axis extent of the cube.</param>
/// <param name="z">Z-Axis extent of the cube.</param>
function Cube (x, y, z)
{
	/// <summary>
	/// Setup inherited members.
	/// </summary>
	PolygonMesh.call();
	
	
	// One centre point + points along the circle
	this.Create(8 + 2 + 2, 12 * 3);

	// Set points
	this.SetPoint(0, new Point(-x, -y, -z));
	this.SetPoint(1, new Point(x, -y, -z));
	this.SetPoint(2, new Point(x, y, -z));
	this.SetPoint(3, new Point(-x, y, -z));

	this.SetPoint(4, new Point(-x, -y, z));
	this.SetPoint(5, new Point(x, -y, z));
	this.SetPoint(6, new Point(x, y, z));
	this.SetPoint(7, new Point(-x, y, z));

	// Special points for top and bottom (fix uv)
	this.SetPoint(8, new Point(-x, y, z));
	this.SetPoint(9, new Point(x, y, z));
	this.SetPoint(10, new Point(-x, -y, z));
	this.SetPoint(11, new Point(x, -y, z));

	// Set uv
	this.SetUV(0, new Point(0.0, 0.0));
	this.SetUV(1, new Point(1.0, 0.0));
	this.SetUV(2, new Point(1.0, 1.0));
	this.SetUV(3, new Point(0.0, 1.0));

	this.SetUV(4, new Point(1.0, 0.0));
	this.SetUV(5, new Point(0.0, 0.0));
	this.SetUV(6, new Point(0.0, 1.0));
	this.SetUV(7, new Point(1.0, 1.0));

	// Special uv for top and bottom
	this.SetUV(8, new Point(0.0, 0.0));
	this.SetUV(9, new Point(1.0, 0.0));
	this.SetUV(10, new Point(0.0, 1.0));
	this.SetUV(11, new Point(1.0, 1.0));

	// Back				Left				// Bottom				// Front				// Right				Top
	this.Index[0] = 0;	this.Index[6] = 0;	this.Index[12] = 0;		this.Index[18] = 5;		this.Index[24] = 5;		this.Index[30] = 9;
	this.Index[1] = 3;	this.Index[7] = 4;	this.Index[13] = 1;		this.Index[19] = 6;		this.Index[25] = 1;		this.Index[31] = 2;
	this.Index[2] = 2;	this.Index[8] = 7;	this.Index[14] = 11;	this.Index[20] = 7;		this.Index[26] = 2;		this.Index[32] = 3;

	this.Index[3] = 2;	this.Index[9] = 7;	this.Index[15] = 11;	this.Index[21] = 7;		this.Index[27] = 2;		this.Index[33] = 3;
	this.Index[4] = 1;	this.Index[10] = 3;	this.Index[16] = 10;	this.Index[22] = 4;		this.Index[28] = 6;		this.Index[34] = 8;
	this.Index[5] = 0;	this.Index[11] = 0;	this.Index[17] = 0;		this.Index[23] = 5;		this.Index[29] = 5;		this.Index[35] = 9;

	// Set Normals
	for (var i = 0; i < 12; ++i)
	{
		var p = this.GetPoint(i);
		p.x = (p.x < 0.0) ? -1.0 : 1.0;
		p.y = (p.y < 0.0) ? -1.0 : 1.0;
		p.z = (p.z < 0.0) ? -1.0 : 1.0;
		this.SetNormal(i, p.Normalize());
	}
}


/// <summary>
/// Prototypal Inheritance.
/// </summary>
Cube.prototype = new PolygonMesh();
Cube.prototype.constructor = Cube;