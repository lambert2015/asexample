// Matrices are column-major order.
function Matrix() {
	// An arbitrary sized matrix.
	this.elements = [];

	// Stores the number of rows.
	this.mNumRows = 4;

	// Stores the number of columns.
	this.mNumColumns = 4;

	// Stores the euler angles of this matrix.
	this.mRotation = new Point();

	// Stores the (x, y, z) scale values.
	this.mScale = new Point(1, 1, 1, 1);

	// Create identity matrix
	this.setIdentity();
}

// Add two matrices.
Matrix.prototype.add = function(matrix) {
	// Add
	var newMatrix = new Matrix(this.mNumRows, this.mNumColumns);
	var size = newMatrix.getSize();
	for (var i = 0; i < size; ++i)
		newMatrix.elements[i] = this.elements[i] + matrix.elements[i];
	return newMatrix;
}
// Subtract two matrices.
Matrix.prototype.subtract = function(matrix) {
	// Subtract
	var newMatrix = new Matrix(this.mNumRows, this.mNumColumns);
	var size = newMatrix.getSize();
	for (var i = 0; i < size; ++i)
		newMatrix.elements[i] = this.elements[i] - matrix2.elements[i];
	return newMatrix;
}
// Multiply two matrices.
Matrix.prototype.multiply = function(matrix) {
	// Multiply
	var newMatrix = new Matrix(this.mNumRows, this.mNumColumns);
	var size = newMatrix.getSize();
	for (var i = 0; i < size; ++i)
		newMatrix.elements[i] = 0;

	for (var i = 0; i < newMatrix.mNumRows; ++i) {
		var rowIndex = i * newMatrix.mNumColumns;
		for (var j = 0; j < newMatrix.mNumColumns; ++j) {
			for (var k = 0; k < newMatrix.mNumColumns; ++k) {
				newMatrix.elements[rowIndex + j] += (this.elements[rowIndex + k] * matrix.elements[k * newMatrix.mNumColumns + j]);
			}
		}
	}

	newMatrix.mScale.x = this.mScale.x * matrix.mScale.x;
	newMatrix.mScale.y = this.mScale.y * matrix.mScale.y;
	newMatrix.mScale.z = this.mScale.z * matrix.mScale.z;

	return newMatrix;
}
// Transpose a matrix.
Matrix.prototype.transpose = function(matrix) {
	// Transpose
	var transposeMatrix = new Matrix(this.mNumRows, this.mNumColumns);
	for (var i = 0; i < transposeMatrix.mNumRows; ++i) {
		for (var j = 0; j < transposeMatrix.mNumColumns; ++j) {
			transposeMatrix.setValue(i, j, matrix.elements[i + j * transposeMatrix.mNumColumns]);
		}
	}
	return transposeMatrix;
}
// Invert a 4x4 matrix quickly.
Matrix.prototype.inverse = function() {
	var matrix = new Matrix(4, 4);

	// Invert rotation (transpose 3x3 matrix)
	matrix.elements[0] = this.elements[0];
	matrix.elements[1] = this.elements[4];
	matrix.elements[2] = this.elements[8];

	matrix.elements[4] = this.elements[1];
	matrix.elements[5] = this.elements[5];
	matrix.elements[6] = this.elements[9];

	matrix.elements[8] = this.elements[2];
	matrix.elements[9] = this.elements[6];
	matrix.elements[10] = this.elements[10];

	matrix.mRotation.x = -this.mRotation.x;
	matrix.mRotation.y = -this.mRotation.y;
	matrix.mRotation.z = -this.mRotation.z;

	// Invert translation -(R dot T)
	matrix.elements[12] = -((matrix.elements[0] * this.elements[12]) + (matrix.elements[4] * this.elements[13]) + (matrix.elements[8] * this.elements[14]));
	matrix.elements[13] = -((matrix.elements[1] * this.elements[12]) + (matrix.elements[5] * this.elements[13]) + (matrix.elements[9] * this.elements[14]));
	matrix.elements[14] = -((matrix.elements[2] * this.elements[12]) + (matrix.elements[6] * this.elements[13]) + (matrix.elements[10] * this.elements[14]));

	// Invert scale
	matrix.mScale.x = 1.0 / this.mScale.x;
	matrix.mScale.y = 1.0 / this.mScale.y;
	matrix.mScale.z = 1.0 / this.mScale.z;
	matrix.mScale.w = 1;

	return matrix;
}
// Defines - Matrix Inverse
function SWAP_ROWS(a, b) {
	var tmp = a;
	a = b;
	b = tmp;
}

// Invert a 4x4 matrix properly.
//
// Mesa 3-D graphics library
// Code contributed by Jacques Leroy <jle@star.be>
// Copyright (C) 1999-2005  Brian Paul   All Rights Reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.

Matrix.prototype.slowInverse = function() {
	// Code contributed by Jacques Leroy <jle@star.be>
	// Code lifted from Brian Paul's Mesa freeware OpenGL implementation.

	// Compare rows and columns
	if ((this.mNumRows != 4) || (this.mNumColumns != 4))
		return this;

	// Inverse (4x4)
	var matrixInverse = new Matrix(4, 4);
	var mInverse = [];

	var m0, m1, m2, m3, s;
	var r0 = [];
	var r1 = [];
	var r2 = [];
	var r3 = [];

	r0[0] = this.elements[0 + 0 * 4];
	r0[1] = this.elements[0 + 1 * 4];
	r0[2] = this.elements[0 + 2 * 4];
	r0[3] = this.elements[0 + 3 * 4];
	r0[4] = 1.0;
	r0[5] = r0[6] = r0[7] = 0.0;

	r1[0] = this.elements[1 + 0 * 4];
	r1[1] = this.elements[1 + 1 * 4];
	r1[2] = this.elements[1 + 2 * 4];
	r1[3] = this.elements[1 + 3 * 4];
	r1[5] = 1.0;
	r1[4] = r1[6] = r1[7] = 0.0;

	r2[0] = this.elements[2 + 0 * 4];
	r2[1] = this.elements[2 + 1 * 4];
	r2[2] = this.elements[2 + 2 * 4];
	r2[3] = this.elements[2 + 3 * 4];
	r2[6] = 1.0;
	r2[4] = r2[5] = r2[7] = 0.0;

	r3[0] = this.elements[3 + 0 * 4];
	r3[1] = this.elements[3 + 1 * 4];
	r3[2] = this.elements[3 + 2 * 4];
	r3[3] = this.elements[3 + 3 * 4];
	r3[7] = 1.0;
	r3[4] = r3[5] = r3[6] = 0.0;

	// choose pivot - or die
	if (Math.abs(r3[0]) > Math.abs(r2[0]))
		SWAP_ROWS(r3, r2);
	if (Math.abs(r2[0]) > Math.abs(r1[0]))
		SWAP_ROWS(r2, r1);
	if (Math.abs(r1[0]) > Math.abs(r0[0]))
		SWAP_ROWS(r1, r0);
	if (0.0 == r0[0])
		return matrixInverse;

	// eliminate first variable
	m1 = r1[0] / r0[0];
	m2 = r2[0] / r0[0];
	m3 = r3[0] / r0[0];
	s = r0[1];
	r1[1] -= m1 * s;
	r2[1] -= m2 * s;
	r3[1] -= m3 * s;
	s = r0[2];
	r1[2] -= m1 * s;
	r2[2] -= m2 * s;
	r3[2] -= m3 * s;
	s = r0[3];
	r1[3] -= m1 * s;
	r2[3] -= m2 * s;
	r3[3] -= m3 * s;
	s = r0[4];
	if (s != 0.0) {
		r1[4] -= m1 * s;
		r2[4] -= m2 * s;
		r3[4] -= m3 * s;
	}
	s = r0[5];
	if (s != 0.0) {
		r1[5] -= m1 * s;
		r2[5] -= m2 * s;
		r3[5] -= m3 * s;
	}
	s = r0[6];
	if (s != 0.0) {
		r1[6] -= m1 * s;
		r2[6] -= m2 * s;
		r3[6] -= m3 * s;
	}
	s = r0[7];
	if (s != 0.0) {
		r1[7] -= m1 * s;
		r2[7] -= m2 * s;
		r3[7] -= m3 * s;
	}

	// choose pivot - or die
	if (Math.abs(r3[1]) > Math.abs(r2[1]))
		SWAP_ROWS(r3, r2);
	if (Math.abs(r2[1]) > Math.abs(r1[1]))
		SWAP_ROWS(r2, r1);
	if (0.0 == r1[1])
		return matrixInverse;

	// eliminate second variable
	m2 = r2[1] / r1[1];
	m3 = r3[1] / r1[1];
	r2[2] -= m2 * r1[2];
	r3[2] -= m3 * r1[2];
	r2[3] -= m2 * r1[3];
	r3[3] -= m3 * r1[3];
	s = r1[4];
	if (0.0 != s) {
		r2[4] -= m2 * s;
		r3[4] -= m3 * s;
	}
	s = r1[5];
	if (0.0 != s) {
		r2[5] -= m2 * s;
		r3[5] -= m3 * s;
	}
	s = r1[6];
	if (0.0 != s) {
		r2[6] -= m2 * s;
		r3[6] -= m3 * s;
	}
	s = r1[7];
	if (0.0 != s) {
		r2[7] -= m2 * s;
		r3[7] -= m3 * s;
	}

	// choose pivot - or die
	if (Math.abs(r3[2]) > Math.abs(r2[2]))
		SWAP_ROWS(r3, r2);
	if (0.0 == r2[2])
		return matrixInverse;

	// eliminate third variable
	m3 = r3[2] / r2[2];
	r3[3] -= m3 * r2[3];
	r3[4] -= m3 * r2[4];
	r3[5] -= m3 * r2[5];
	r3[6] -= m3 * r2[6];
	r3[7] -= m3 * r2[7];

	// last check
	if (0.0 == r3[3])
		return matrixInverse;

	// now back substitute row 3
	s = (1.0 / r3[3]);
	r3[4] *= s;
	r3[5] *= s;
	r3[6] *= s;
	r3[7] *= s;

	// now back substitute row 2
	m2 = r2[3];
	s = (1.0 / r2[2]);
	r2[4] = s * (r2[4] - r3[4] * m2);
	r2[5] = s * (r2[5] - r3[5] * m2);
	r2[6] = s * (r2[6] - r3[6] * m2);
	r2[7] = s * (r2[7] - r3[7] * m2);
	m1 = r1[3];
	r1[4] -= r3[4] * m1;
	r1[5] -= r3[5] * m1;
	r1[6] -= r3[6] * m1;
	r1[7] -= r3[7] * m1;
	m0 = r0[3];
	r0[4] -= r3[4] * m0;
	r0[5] -= r3[5] * m0;
	r0[6] -= r3[6] * m0;
	r0[7] -= r3[7] * m0;

	// now back substitute row 1
	m1 = r1[2];
	s = (1.0 / r1[1]);
	r1[4] = s * (r1[4] - r2[4] * m1);
	r1[5] = s * (r1[5] - r2[5] * m1);
	r1[6] = s * (r1[6] - r2[6] * m1);
	r1[7] = s * (r1[7] - r2[7] * m1);
	m0 = r0[2];
	r0[4] -= r2[4] * m0;
	r0[5] -= r2[5] * m0;
	r0[6] -= r2[6] * m0;
	r0[7] -= r2[7] * m0;

	// now back substitute row 0
	m0 = r0[1];
	s = (1.0 / r0[0]);
	r0[4] = s * (r0[4] - r1[4] * m0);
	r0[5] = s * (r0[5] - r1[5] * m0);
	r0[6] = s * (r0[6] - r1[6] * m0);
	r0[7] = s * (r0[7] - r1[7] * m0);

	mInverse[0 + 0 * 4] = r0[4];
	mInverse[0 + 1 * 4] = r0[5];
	mInverse[0 + 2 * 4] = r0[6];
	mInverse[0 + 3 * 4] = r0[7];
	mInverse[1 + 0 * 4] = r1[4];
	mInverse[1 + 1 * 4] = r1[5];
	mInverse[1 + 2 * 4] = r1[6];
	mInverse[1 + 3 * 4] = r1[7];
	mInverse[2 + 0 * 4] = r2[4];
	mInverse[2 + 1 * 4] = r2[5];
	mInverse[2 + 2 * 4] = r2[6];
	mInverse[2 + 3 * 4] = r2[7];
	mInverse[3 + 0 * 4] = r3[4];
	mInverse[3 + 1 * 4] = r3[5];
	mInverse[3 + 2 * 4] = r3[6];
	mInverse[3 + 3 * 4] = r3[7];

	// Copy inverse matrix
	for (var i = 0; i < 16; ++i)
		matrixInverse.elements[i] = mInverse[i];
	return matrixInverse;
}
// Points the matrix to look at the specified target.
// <param name="eye">Position of the matrix.</param>
// <param name="target">Target to look at.</param>
// <param name="up">Up-vector.</param>
Matrix.prototype.pointAt = function(eye, target, up) {
	// Up (Y-axis)
	if (up == null)
		up = new Point(0.0, 1.0, 0.0);

	// Forward (Z-axis)
	var forward = new Point(target.x - eye.x, target.y - eye.y, target.z - eye.z);
	forward.normalize();

	// Side (X-axis) = forward x up
	var left = forward.cross(up);
	left.normalize();

	// Up = side x forward
	up = left.cross(forward);

	// Update matrix
	this.elements[0] = left.x;
	this.elements[1] = left.y;
	this.elements[2] = left.z;
	this.elements[3] = 0.0;

	this.elements[4] = up.x;
	this.elements[5] = up.y;
	this.elements[6] = up.z;
	this.elements[7] = 0.0;

	this.elements[8] = -forward.x;
	this.elements[9] = -forward.y;
	this.elements[10] = -forward.z;
	this.elements[11] = 0.0;

	this.elements[12] = eye.x;
	this.elements[13] = eye.y;
	this.elements[14] = eye.z;
	this.elements[15] = 1.0;
}
// Translate this matrix by the specified values.
// <param name="x">X-axis translation.</param>
// <param name="y">Y-axis translation.</param>
// <param name="z">Z-axis translation.</param>
Matrix.prototype.translate = function(x, y, z) {
	this.elements[12] = x;
	this.elements[13] = y;
	this.elements[14] = z;
}
// Rotate this matrix by the specified values.
// <param name="x">X-axis rotation.</param>
// <param name="y">Y-axis rotation.</param>
// <param name="z">Z-axis rotation.</param>
Matrix.prototype.rotate = function(x, y, z) {
	this.mRotation.setPoint(x, y, z);

	var quat = new Quaternion();
	quat.rotate(x, y, z);
	quat.toMatrix(this.elements);
}
// Scale this matrix by the specified values.
// <param name="x">X-axis scale.</param>
// <param name="y">Y-axis scale.</param>
// <param name="z">Z-axis scale.</param>
Matrix.prototype.scale = function(x, y, z) {
	this.mScale.setPoint(x, y, z, 1);
}
// Set the identity matrix.
Matrix.prototype.setIdentity = function() {
	// Set diagonal to 1.0 and the rest to 0.0
	for (var i = 0; i < this.mNumRows; ++i) {
		for (var j = 0; j < this.mNumColumns; ++j) {
			if (j == i)
				this.elements[i * this.mNumColumns + j] = 1.0;
			else
				this.elements[i * this.mNumColumns + j] = 0.0;
		}
	}
}
// Returns the value at the specified row x column.
// <param name="row">Row'th index to retrieve.</param>
// <param name="column">Column'th index to retrieve.</param>
// <returns>The value at Row x Column.</returns>
Matrix.prototype.getValue = function(row, column) {
	return this.elements[row * this.mNumColumns + column];
}
// Sets a value at the specified row x column.
// <param name="row">Row'th index to set.</param>
// <param name="column">Column'th index to set.</param>
// <param name="value">Value to set at Row x Column.</param>
Matrix.prototype.setValue = function(row, column, value) {
	this.elements[row * this.mNumColumns + column] = value;
}

Matrix.prototype.getTranslation = function() {
	return new Point(this.elements[12], this.elements[13], this.elements[14]);
}

Matrix.prototype.getRotation = function() {
	return this.mRotation;
}

Matrix.prototype.getScale = function() {
	return this.mScale;
}