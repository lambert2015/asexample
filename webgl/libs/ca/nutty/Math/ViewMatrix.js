// ViewMatrix builds Matrix objects based on certain desired views.
function ViewMatrix ()
{
}

// Build a frustum matrix.
// <param name="left">Left coordinate of frustum.</param>
// <param name="right">Right coordinate of frustum.</param>
// <param name="bottom">Bottom coordinate of frustum.</param>
// <param name="top">Top coordinate of frustum.</param>
// <param name="near">Near distance of frustum.</param>
// <param name="far">Far distance of frustum.</param>
// <returns>A frustum (3D rectangular region of space) matrix.</returns>
ViewMatrix.frustum = function (left, right, bottom, top, near, far)
{
	var matrix = new Matrix(4, 4);

	matrix.MMatrix[0] = (2.0 * near) / (right - left);
	matrix.MMatrix[1] = 0.0;
	matrix.MMatrix[2] = 0.0;
	matrix.MMatrix[3] = 0.0;

	matrix.MMatrix[4] = 0.0;
	matrix.MMatrix[5] = (2.0 * near) / (top - bottom);
	matrix.MMatrix[6] = 0.0;
	matrix.MMatrix[7] = 0.0;

	matrix.MMatrix[8] = (right + left) / (right - left);
	matrix.MMatrix[9] = (top + bottom) / (top - bottom);
	matrix.MMatrix[10] = -(far + near) / (far - near);
	matrix.MMatrix[11] = -1.0;

	matrix.MMatrix[12] = 0.0;
	matrix.MMatrix[13] = 0.0;
	matrix.MMatrix[14] = -(2.0 * far * near) / (far - near);
	matrix.MMatrix[15] = 0.0;

	return matrix;
}



// Build an orthographic matrix with centre at (0,0).

// <param name="width">Width of the frustum.</param>
// <param name="height">Height of the frustum.</param>
// <param name="near">Near distance of frustum.</param>
// <param name="far">Far distance of frustum.</param>
// <returns>An orthographic matrix.</returns>
ViewMatrix.orthographic = function (width, height, near, far)
{
	var matrix = new Matrix(4, 4);

	matrix.MMatrix[0] = 1.0 / width;
	matrix.MMatrix[1] = 0.0;
	matrix.MMatrix[2] = 0.0;
	matrix.MMatrix[3] = 0.0;

	matrix.MMatrix[4] = 0.0;
	matrix.MMatrix[5] = 1.0 / height;
	matrix.MMatrix[6] = 0.0;
	matrix.MMatrix[7] = 0.0;

	matrix.MMatrix[8] = 0.0;
	matrix.MMatrix[9] = 0.0;
	matrix.MMatrix[10] = -2.0 / (far - near);
	matrix.MMatrix[11] = 0.0;

	matrix.MMatrix[12] = 0;
	matrix.MMatrix[13] = 0;
	matrix.MMatrix[14] = -near / (far - near);
	matrix.MMatrix[15] = 1.0;

	return matrix;
}



// Build an orthographic matrix.

// <param name="left">Left coordinate of frustum.</param>
// <param name="right">Right coordinate of frustum.</param>
// <param name="bottom">Bottom coordinate of frustum.</param>
// <param name="top">Top coordinate of frustum.</param>
// <param name="near">Near distance of frustum.</param>
// <param name="far">Far distance of frustum.</param>
// <returns>An orthographic matrix.</returns>
ViewMatrix.orthographicRect = function (left, right, bottom, top, near, far)
{
	var matrix = new Matrix(4, 4);

	matrix.MMatrix[0] = 2.0 / (right - left);
	matrix.MMatrix[1] = 0.0;
	matrix.MMatrix[2] = 0.0;
	matrix.MMatrix[3] = 0.0;

	matrix.MMatrix[4] = 0.0;
	matrix.MMatrix[5] = 2.0 / (top - bottom);
	matrix.MMatrix[6] = 0.0;
	matrix.MMatrix[7] = 0.0;

	matrix.MMatrix[8] = 0.0;
	matrix.MMatrix[9] = 0.0;
	matrix.MMatrix[10] = -2.0 / (far - near);
	matrix.MMatrix[11] = 0.0;

	matrix.MMatrix[12] = -(right + left) / (right - left);
	matrix.MMatrix[13] = -(top + bottom) / (top - bottom);
	matrix.MMatrix[14] = -(far + near) / (far - near);
	matrix.MMatrix[15] = 1.0;

	return matrix;
}



// Build a perspective matrix.

// <param name="fovY">Angular pitch of frustum</param>
// <param name="aspect">Aspext ratio of frustum</param>
// <param name="near">Near distance of frustum</param>
// <param name="far">Far distance of frustum</param>
// <returns>A projection matrix</returns>
ViewMatrix.perspective = function (fovY, aspect, near, far)
{
	var top = near * Math.tan(fovY * (Math.PI / 360.0));
	var bottom = -top;
	var left = bottom * aspect;
	var right = top * aspect;

	return this.frustum(left,
						right,
						bottom,
						top,
						near,
						far);
}



// Build a viewport matrix.

// <param name="width">Width of the viewport.</param>
// <param name="height">Height of the viewport.</param>
// <returns>A viewport matrix.</returns>
ViewMatrix.viewPort = function (x, y, width, height)
{
	var matrix = new Matrix(4, 4);

	matrix.MMatrix[0] = width * 0.5;
	matrix.MMatrix[1] = 0.0;
	matrix.MMatrix[2] = 0.0;
	matrix.MMatrix[3] = 0.0;

	matrix.MMatrix[4] = 0.0;
	matrix.MMatrix[5] = height * 0.5;
	matrix.MMatrix[6] = 0.0;
	matrix.MMatrix[7] = 0.0;

	matrix.MMatrix[8] = 0.0;
	matrix.MMatrix[9] = 0.0;
	matrix.MMatrix[10] = 1.0;
	matrix.MMatrix[11] = 0.0;

	matrix.MMatrix[12] = x + width * 0.5;
	matrix.MMatrix[13] = y + height * 0.5;
	matrix.MMatrix[14] = 0.0;
	matrix.MMatrix[15] = 1.0;

	return matrix;
}