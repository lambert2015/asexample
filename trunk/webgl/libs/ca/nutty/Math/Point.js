
// Point / vector object.




// Provides a point data type, containing (X, Y, Z, W) values.

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



// Sum of points.

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



// Negative.

Point.prototype.Negative = function ()
{
	return new Point(-this.x,
					 -this.y,
					 -this.z,
					 -this.w);
}



// Difference of points.

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



// Multiplication of points.

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



// Division of points.

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



// Absolute value of point.

Point.prototype.Absolute = function ()
{
	return new Point(this.x < 0 ? -this.x : this.x,
					 this.y < 0 ? -this.y : this.y,
					 this.z < 0 ? -this.z : this.z,
					 this.w < 0 ? -this.w : this.w);
}



// Clamp.

Point.prototype.Clamp = function (min, max)
{
	return new Point(this.x < min ? min : this.x > max ? max : this.x,
					 this.y < min ? min : this.y > max ? max : this.y,
					 this.z < min ? min : this.z > max ? max : this.z,
					 this.w < min ? min : this.w > max ? max : this.w);
}



// Cross product of points.

Point.prototype.Cross = function (point)
{
	return new Point(this.y * point.z - this.z * point.y,
					 this.z * point.x - this.x * point.z,
					 this.x * point.y - this.y * point.x);
}



// Distance between two points.

Point.prototype.Distance = function (point)
{
	return Math.sqrt(((this.x - point.x) * (this.x - point.x)) +
					 ((this.y - point.y) * (this.y - point.y)) +
					 ((this.z - point.z) * (this.z - point.z)));
}



// Dot product between two points.
// If dot < 0, vectors are greater than 90 degrees apart (facing each other, or away)
// If dot > 0, vectors are within 90 degrees of each other (facing in similar direction)
// If dot = 0, vectors are orthogonal (perpindicular)

Point.prototype.Dot = function (point)
{
	return ((this.x * point.x) +
			(this.y * point.y) +
			(this.z * point.z));
}



// Magnitude of this point.

Point.prototype.Magnitude = function ()
{
	return Math.sqrt((this.x * this.x) +
					 (this.y * this.y) +
					 (this.z * this.z) +
					 (this.w * this.w));
}



// Normalize point.

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



// Set point.

Point.prototype.SetPoint = function (x, y, z, w)
{
	this.x = x ? x : 0;
	this.y = y ? y : 0;
	this.z = z ? z : 0;
	this.w = w ? w : 0;
}