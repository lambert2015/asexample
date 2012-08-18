// This class created a cylinder mesh.
// <param name="numPoint">Number of points to create for this shape.</param>
// <param name="radius">Radius of the cylinder.</param>
// <param name="height">Height of the cylinder.</param>
function Cylinder(numPoint, radius, height) {

	// Setup inherited members.
	PolygonMesh.call(this);

	height *= 0.5;

	// Must have even number of points
	if ((numPoint % 2) != 0)
		++numPoint;

	// One centre point + points along the circle
	//Create(numPoint, numPoint * 3);
	this.create(numPoint, (numPoint - 2) * 3);

	// Points on shape
	for (var i = 0; i < numPoint; i += 2) {
		//var angle = (i / numPoint) * (2.0 * CMath.PI);
		var angle = (i / (numPoint - 2.0)) * (2.0 * Math.PI);
		var p1 = new Point(Math.cos(angle) * radius, Math.sin(angle) * radius, height);
		var p2 = new Point(p1.x, p1.y, -height);

		this.setPoint(i, p1);
		this.setPoint(i + 1, p2);

		//Point uv = new Point(i / (double)numPoint, 1);
		var uv = new Point(i / (numPoint - 2.0), 1);
		this.setUV(i, uv);
		this.setUV(i + 1, new Point(uv.x, 0));

		if (i < (numPoint - 2)) {
			this.indices[i * 3 + 0] = i;
			this.indices[i * 3 + 1] = i + 1;
			this.indices[i * 3 + 2] = i + 3;

			this.indices[i * 3 + 3] = i + 3;
			this.indices[i * 3 + 4] = i + 2;
			this.indices[i * 3 + 5] = i;
		}
	}

	// Set Normals
	this.createNormals();

	// Average normals along the seem
	if (numPoint > 2) {
		var endIndex = (numPoint * 3) - 6;
		this.normals[0] = (this.normals[0] + this.normals[endIndex + 0]) * 0.5;
		this.normals[1] = (this.normals[1] + this.normals[endIndex + 1]) * 0.5;
		this.normals[2] = (this.normals[2] + this.normals[endIndex + 2]) * 0.5;

		this.normals[3] = (this.normals[3] + this.normals[endIndex + 3]) * 0.5;
		this.normals[4] = (this.normals[4] + this.normals[endIndex + 4]) * 0.5;
		this.normals[5] = (this.normals[5] + this.normals[endIndex + 5]) * 0.5;

		this.normals[endIndex + 0] = this.normals[0];
		this.normals[endIndex + 1] = this.normals[1];
		this.normals[endIndex + 2] = this.normals[2];

		this.normals[endIndex + 3] = this.normals[3];
		this.normals[endIndex + 4] = this.normals[4];
		this.normals[endIndex + 5] = this.normals[5];
	}
}

// Prototypal Inheritance.
Cylinder.prototype = new PolygonMesh();
Cylinder.prototype.constructor = Cylinder; 