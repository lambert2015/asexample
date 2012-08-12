// This class creates a cube mesh.
// <param name="x">X-Axis extent of the cube.</param>
// <param name="y">Y-Axis extent of the cube.</param>
// <param name="z">Z-Axis extent of the cube.</param>
function Cube (x, y, z)
{
	
	// Setup inherited members.
	PolygonMesh.call();
	
	// One centre point + points along the circle
	this.create(8 + 2 + 2, 12 * 3);

	// Set points
	this.setPoint(0, new Point(-x, -y, -z));
	this.setPoint(1, new Point(x, -y, -z));
	this.setPoint(2, new Point(x, y, -z));
	this.setPoint(3, new Point(-x, y, -z));

	this.setPoint(4, new Point(-x, -y, z));
	this.setPoint(5, new Point(x, -y, z));
	this.setPoint(6, new Point(x, y, z));
	this.setPoint(7, new Point(-x, y, z));

	// Special points for top and bottom (fix uv)
	this.setPoint(8, new Point(-x, y, z));
	this.setPoint(9, new Point(x, y, z));
	this.setPoint(10, new Point(-x, -y, z));
	this.setPoint(11, new Point(x, -y, z));

	// Set uv
	this.setUV(0, new Point(0.0, 0.0));
	this.setUV(1, new Point(1.0, 0.0));
	this.setUV(2, new Point(1.0, 1.0));
	this.setUV(3, new Point(0.0, 1.0));

	this.setUV(4, new Point(1.0, 0.0));
	this.setUV(5, new Point(0.0, 0.0));
	this.setUV(6, new Point(0.0, 1.0));
	this.setUV(7, new Point(1.0, 1.0));

	// Special uv for top and bottom
	this.setUV(8, new Point(0.0, 0.0));
	this.setUV(9, new Point(1.0, 0.0));
	this.setUV(10, new Point(0.0, 1.0));
	this.setUV(11, new Point(1.0, 1.0));

	// Back				Left				// Bottom				// Front			// Right			//Top
	this.indices[0] = 0;this.indices[6] = 0;this.indices[12] = 0;this.indices[18] = 5;	this.indices[24] = 5;this.indices[30] = 9;
	this.indices[1] = 3;this.indices[7] = 4;this.indices[13] = 1;this.indices[19] = 6;	this.indices[25] = 1;this.indices[31] = 2;
	this.indices[2] = 2;this.indices[8] = 7;this.indices[14] = 11;this.indices[20] = 7;	this.indices[26] = 2;this.indices[32] = 3;

	this.indices[3] = 2;this.indices[9] = 7;this.indices[15] = 11;this.indices[21] = 7;	this.indices[27] = 2;this.indices[33] = 3;
	this.indices[4] = 1;this.indices[10] = 3;this.indices[16] = 10;this.indices[22] = 4;this.indices[28] = 6;this.indices[34] = 8;
	this.indices[5] = 0;this.indices[11] = 0;this.indices[17] = 0;this.indices[23] = 5;	this.indices[29] = 5;this.indices[35] = 9;

	// Set Normals
	for (var i = 0; i < 12; ++i)
	{
		var p = this.getPoint(i);
		p.x = (p.x < 0.0) ? -1.0 : 1.0;
		p.y = (p.y < 0.0) ? -1.0 : 1.0;
		p.z = (p.z < 0.0) ? -1.0 : 1.0;
		this.setNormal(i, p.normalize());
	}
}

// Prototypal Inheritance.
Cube.prototype = new PolygonMesh();
Cube.prototype.constructor = Cube;