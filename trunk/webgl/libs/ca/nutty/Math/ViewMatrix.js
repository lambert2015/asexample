// ViewMatrix builds Matrix objects based on certain desired views.
function ViewMatrix() {
}

// Build a frustum matrix.
// <param name="left">Left coordinate of frustum.</param>
// <param name="right">Right coordinate of frustum.</param>
// <param name="bottom">Bottom coordinate of frustum.</param>
// <param name="top">Top coordinate of frustum.</param>
// <param name="near">Near distance of frustum.</param>
// <param name="far">Far distance of frustum.</param>
// <returns>A frustum (3D rectangular region of space) matrix.</returns>
ViewMatrix.frustum = function(left, right, bottom, top, near, far) {
	var matrix = new Matrix(4, 4);

	matrix.elements[0] = (2.0 * near) / (right - left);
	matrix.elements[1] = 0.0;
	matrix.elements[2] = 0.0;
	matrix.elements[3] = 0.0;

	matrix.elements[4] = 0.0;
	matrix.elements[5] = (2.0 * near) / (top - bottom);
	matrix.elements[6] = 0.0;
	matrix.elements[7] = 0.0;

	matrix.elements[8] = (right + left) / (right - left);
	matrix.elements[9] = (top + bottom) / (top - bottom);
	matrix.elements[10] = -(far + near) / (far - near);
	matrix.elements[11] = -1.0;

	matrix.elements[12] = 0.0;
	matrix.elements[13] = 0.0;
	matrix.elements[14] = -(2.0 * far * near) / (far - near);
	matrix.elements[15] = 0.0;

	return matrix;
}
// Build an orthographic matrix with centre at (0,0).
// <param name="width">Width of the frustum.</param>
// <param name="height">Height of the frustum.</param>
// <param name="near">Near distance of frustum.</param>
// <param name="far">Far distance of frustum.</param>
// <returns>An orthographic matrix.</returns>
ViewMatrix.orthographic = function(width, height, near, far) {
	var matrix = new Matrix(4, 4);

	matrix.elements[0] = 1.0 / width;
	matrix.elements[1] = 0.0;
	matrix.elements[2] = 0.0;
	matrix.elements[3] = 0.0;

	matrix.elements[4] = 0.0;
	matrix.elements[5] = 1.0 / height;
	matrix.elements[6] = 0.0;
	matrix.elements[7] = 0.0;

	matrix.elements[8] = 0.0;
	matrix.elements[9] = 0.0;
	matrix.elements[10] = -2.0 / (far - near);
	matrix.elements[11] = 0.0;

	matrix.elements[12] = 0;
	matrix.elements[13] = 0;
	matrix.elements[14] = -near / (far - near);
	matrix.elements[15] = 1.0;

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
ViewMatrix.orthographicRect = function(left, right, bottom, top, near, far) {
	var matrix = new Matrix(4, 4);

	matrix.elements[0] = 2.0 / (right - left);
	matrix.elements[1] = 0.0;
	matrix.elements[2] = 0.0;
	matrix.elements[3] = 0.0;

	matrix.elements[4] = 0.0;
	matrix.elements[5] = 2.0 / (top - bottom);
	matrix.elements[6] = 0.0;
	matrix.elements[7] = 0.0;

	matrix.elements[8] = 0.0;
	matrix.elements[9] = 0.0;
	matrix.elements[10] = -2.0 / (far - near);
	matrix.elements[11] = 0.0;

	matrix.elements[12] = -(right + left) / (right - left);
	matrix.elements[13] = -(top + bottom) / (top - bottom);
	matrix.elements[14] = -(far + near) / (far - near);
	matrix.elements[15] = 1.0;

	return matrix;
}
// Build a perspective matrix.
// <param name="fovY">Angular pitch of frustum</param>
// <param name="aspect">Aspext ratio of frustum</param>
// <param name="near">Near distance of frustum</param>
// <param name="far">Far distance of frustum</param>
// <returns>A projection matrix</returns>
ViewMatrix.perspective = function(fovY, aspect, near, far) {
	var top = near * Math.tan(fovY * (Math.PI / 360.0));
	var bottom = -top;
	var left = bottom * aspect;
	var right = top * aspect;

	return this.frustum(left, right, bottom, top, near, far);
}
// Build a viewport matrix.
// <param name="width">Width of the viewport.</param>
// <param name="height">Height of the viewport.</param>
// <returns>A viewport matrix.</returns>
ViewMatrix.viewPort = function(x, y, width, height) {
	var matrix = new Matrix(4, 4);

	matrix.elements[0] = width * 0.5;
	matrix.elements[1] = 0.0;
	matrix.elements[2] = 0.0;
	matrix.elements[3] = 0.0;

	matrix.elements[4] = 0.0;
	matrix.elements[5] = height * 0.5;
	matrix.elements[6] = 0.0;
	matrix.elements[7] = 0.0;

	matrix.elements[8] = 0.0;
	matrix.elements[9] = 0.0;
	matrix.elements[10] = 1.0;
	matrix.elements[11] = 0.0;

	matrix.elements[12] = x + width * 0.5;
	matrix.elements[13] = y + height * 0.5;
	matrix.elements[14] = 0.0;
	matrix.elements[15] = 1.0;

	return matrix;
}