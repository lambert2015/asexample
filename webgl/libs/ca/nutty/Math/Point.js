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
/// Point / vector object.
/// </summary>


/// <summary>
/// Provides a point data type, containing (X, Y, Z, W) values.
/// </summary>
function Point (x, y, z, w)
{
	//
	//	x, y, z, w
	//		Points
	//
	this.x = (x != null) ? x : 0;
	this.y = (y != null) ? y : 0;
	this.z = (z != null) ? z : 0;
	this.w = (w != null) ? w : 0;
}


/// <summary>
/// Sum of points.
/// </summary>
Point.prototype.Add = function (point)
{
	return new Point(this.x + point.x,
					 this.y + point.y,
					 this.z + point.z,
					 this.w + point.w);
}

Point.prototype.AddScalar = function (value)
{
	return new Point(this.x + value,
					 this.y + value,
					 this.z + value,
					 this.w + value);
}


/// <summary>
/// Negative.
/// </summary>
Point.prototype.Negative = function ()
{
	return new Point(-this.x,
					 -this.y,
					 -this.z,
					 -this.w);
}


/// <summary>
/// Difference of points.
/// </summary>
Point.prototype.Subtract = function (point)
{
	return new Point(this.x - point.x,
					 this.y - point.y,
					 this.z - point.z,
					 this.w - point.w);
}

Point.prototype.SubtractScalar = function (value)
{
	return new Point(this.x - value,
					 this.y - value,
					 this.z - value,
					 this.w - value);
}


/// <summary>
/// Multiplication of points.
/// </summary>
Point.prototype.Multiply = function (point)
{
	return new Point(this.x * point.x,
					 this.y * point.y,
					 this.z * point.z,
					 this.w * point.w);
}

Point.prototype.MultiplyScalar = function (value)
{
	return new Point(this.x * value,
					 this.y * value,
					 this.z * value,
					 this.w * value);
}


/// <summary>
/// Division of points.
/// </summary>
Point.prototype.Divide = function (point)
{
	return new Point(this.x / point.x,
					 this.y / point.y,
					 this.z / point.z,
					 this.w / point.w);
}

Point.prototype.DivideScalar = function (value)
{
	return new Point(this.x / value,
					 this.y / value,
					 this.z / value,
					 this.w / value);
}


/// <summary>
/// Absolute value of point.
/// </summary>
Point.prototype.Absolute = function ()
{
	return new Point(this.x < 0 ? -this.x : this.x,
					 this.y < 0 ? -this.y : this.y,
					 this.z < 0 ? -this.z : this.z,
					 this.w < 0 ? -this.w : this.w);
}


/// <summary>
/// Clamp.
/// </summary>
Point.prototype.Clamp = function (min, max)
{
	return new Point(this.x < min ? min : this.x > max ? max : this.x,
					 this.y < min ? min : this.y > max ? max : this.y,
					 this.z < min ? min : this.z > max ? max : this.z,
					 this.w < min ? min : this.w > max ? max : this.w);
}


/// <summary>
/// Cross product of points.
/// </summary>
Point.prototype.Cross = function (point)
{
	return new Point(this.y * point.z - this.z * point.y,
					 this.z * point.x - this.x * point.z,
					 this.x * point.y - this.y * point.x);
}


/// <summary>
/// Distance between two points.
/// </summary>
Point.prototype.Distance = function (point)
{
	return Math.sqrt(((this.x - point.x) * (this.x - point.x)) +
					 ((this.y - point.y) * (this.y - point.y)) +
					 ((this.z - point.z) * (this.z - point.z)));
}


/// <summary>
/// Dot product between two points.
/// If dot < 0, vectors are greater than 90 degrees apart (facing each other, or away)
/// If dot > 0, vectors are within 90 degrees of each other (facing in similar direction)
/// If dot = 0, vectors are orthogonal (perpindicular)
/// </summary>
Point.prototype.Dot = function (point)
{
	return ((this.x * point.x) +
			(this.y * point.y) +
			(this.z * point.z));
}


/// <summary>
/// Magnitude of this point.
/// </summary>
Point.prototype.Magnitude = function ()
{
	return Math.sqrt((this.x * this.x) +
					 (this.y * this.y) +
					 (this.z * this.z) +
					 (this.w * this.w));
}


/// <summary>
/// Normalize point.
/// </summary>
Point.prototype.Normalize = function ()
{
	var unit = this.Magnitude();
	if ( unit != 0.0 )
	{
		this.x /= unit;
		this.y /= unit;
		this.z /= unit;
		this.w /= unit;
	}

	return this;
}


/// <summary>
/// Set point.
/// </summary>
Point.prototype.SetPoint = function (x, y, z, w)
{
	this.x = x ? x : 0;
	this.y = y ? y : 0;
	this.z = z ? z : 0;
	this.w = w ? w : 0;
}