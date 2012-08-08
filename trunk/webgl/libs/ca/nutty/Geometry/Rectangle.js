
// This class creates a rectangular mesh.




// Constructor.

// <param name="x">X-Axis extent of the rectangle.</param>
// <param name="y">Y-Axis extent of the rectangle.</param>
function Rectangle (x, y)
{
	
	// Setup inherited members.
	
	PolygonMesh.call();
	
	
	// Create two triangles
	this.Create(4, 6);

	// Set points
	this.SetPoint(0, new Point(-x, -y));
	this.SetPoint(1, new Point(x, -y));
	this.SetPoint(2, new Point(x, y));
	this.SetPoint(3, new Point(-x, y));

	// Set uv
	this.SetUV(0, new Point(0.0, 0.0));
	this.SetUV(1, new Point(1.0, 0.0));
	this.SetUV(2, new Point(1.0, 1.0));
	this.SetUV(3, new Point(0.0, 1.0));

	// Set indices
	this.Index[0] = 0;
	this.Index[1] = 1;
	this.Index[2] = 2;

	this.Index[3] = 2;
	this.Index[4] = 3;
	this.Index[5] = 0;

	// Set Normals
	this.CreateNormals();
}



// Prototypal Inheritance.

Rectangle.prototype = new PolygonMesh();
Rectangle.prototype.constructor = Rectangle;