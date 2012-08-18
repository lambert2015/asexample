// A Quaternion is a means of representing rotation in 4D space, it is
// an extension to the complex numbering system.
//
// Compared to Euler angles they are simpler to compose and avoid the
// problem of gimbal lock. Compared to rotation matrices they are more
// numerically stable and may be more efficient.
function Quaternion(x, y, z, w) {

	// Setup inherited members.
	Point.call(this, x, y, z, w);

	// Constants
	this.Sqrt2 = 1.414213562;
	this.PI180 = Math.PI / 180.0;

	// Setup members
	if (w == null)
		this.w = 1.0;
}

// Prototypal Inheritance.
Quaternion.prototype = new Point();
Quaternion.prototype.constructor = Quaternion;

// Rotate a quaternion using Euler angles.
// <param name="x">X-angle rotation.</param>
// <param name="y">Y-angle rotation.</param>
// <param name="z">Z-angle rotation.</param>
Quaternion.prototype.rotate = function(x, y, z) {
	x = (x * this.PI180) * 0.5;
	y = (y * this.PI180) * 0.5;
	z = (z * this.PI180) * 0.5;

	var c1 = Math.cos(x);
	var s1 = Math.sin(x);
	var c2 = Math.cos(y);
	var s2 = Math.sin(y);
	var c3 = Math.cos(z);
	var s3 = Math.sin(z);

	var cc = c1 * c3;
	var cs = c1 * s3;
	var sc = s1 * c3;
	var ss = s1 * s3;

	this.w = (c2 * cc) + (s2 * ss);
	this.x = (c2 * sc) - (s2 * cs);
	this.y = (c2 * ss) + (s2 * cc);
	this.z = (c2 * cs) - (s2 * sc);
}
// Spherical Linear Interpolation between two quaternions.
// <param name="quat">Quaternion to slerp to.</param>
// <param name="t">Scalar value between 0.0 and 1.0.</param>
// <returns>The interpolated quaternion.</returns>
Quaternion.prototype.slerp = function(quat, t) {
	// Calculate the angle between both quaternions
	var angle = Math.acos(this.dot(quat));

	var s1 = 0.0;
	var s2 = 0.0;

	if (angle > 0.0) {
		// Precalculate slerp values
		var s = Math.sin(angle);
		s1 = Math.sin((1.0 - t) * angle) / s;
		s2 = Math.sin(t * angle) / s;
	} else {
		s1 = 1.0 - t;
		s2 = t;
	}

	return (new Quaternion((s1 * this.x) + (s2 * quat.x), (s1 * this.y) + (s2 * quat.y), (s1 * this.z) + (s2 * quat.z), (s1 * this.w) + (s2 * quat.w))).normalize();
}
// Convert a quaternion to a matrix.
// <param name="matrix">Reference to a 4x4 matrix.</param>
Quaternion.prototype.toMatrix = function(matrix) {
	var x2 = this.x * this.Sqrt2;
	var y2 = this.y * this.Sqrt2;
	var z2 = this.z * this.Sqrt2;
	var w2 = this.w * this.Sqrt2;

	var xx = x2 * x2;
	var yy = y2 * y2;
	var zz = z2 * z2;

	matrix[0] = 1.0 - yy - zz;
	matrix[1] = w2 * z2 + x2 * y2;
	matrix[2] = x2 * z2 - w2 * y2;
	//matrix[3] = 0.0;

	matrix[4] = x2 * y2 - w2 * z2;
	matrix[5] = 1.0 - xx - zz;
	matrix[6] = w2 * x2 + y2 * z2;
	//matrix[7] = 0.0;

	matrix[8] = w2 * y2 + x2 * z2;
	matrix[9] = y2 * z2 - w2 * x2;
	matrix[10] = 1.0 - xx - yy;
	//matrix[11] = 0.0;

	//matrix[15] = 1.0;
}