// This class creates a rectangular mesh.
// <param name="x">X-Axis extent of the rectangle.</param>
// <param name="y">Y-Axis extent of the rectangle.</param>
function Rectangle (x, y)
{
	
	// Setup inherited members.
	PolygonMesh.call();
	
	
	// Create two triangles
	this.create(4, 6);

	// Set points
	this.setPoint(0, new Point(-x, -y));
	this.setPoint(1, new Point(x, -y));
	this.setPoint(2, new Point(x, y));
	this.setPoint(3, new Point(-x, y));

	// Set uv
	this.setUV(0, new Point(0.0, 0.0));
	this.setUV(1, new Point(1.0, 0.0));
	this.setUV(2, new Point(1.0, 1.0));
	this.setUV(3, new Point(0.0, 1.0));

	// Set indices
	this.indices[0] = 0;
	this.indices[1] = 1;
	this.indices[2] = 2;

	this.indices[3] = 2;
	this.indices[4] = 3;
	this.indices[5] = 0;

	// Set Normals
	this.createNormals();
}

// Prototypal Inheritance.
Rectangle.prototype = new PolygonMesh();
Rectangle.prototype.constructor = Rectangle;