// This class creates a cone mesh.

// <param name="numPoint">Number of points to create for this shape.</param>
// <param name="radius">Radius of the circle.</param>
// <param name="height">Height of the cone.</param>
function Cone (numPoint, radius, height)
{
	// Setup inherited members.
	PolygonMesh.call(this);
	
	// One centre point + points along the circle
	this.create(numPoint + 1, numPoint * 3);

	// Centre point
	this.setPoint(0, new Point(0.0, 0.0, height));
	this.setUV(0, new Point(0.5, 0.5));

	// Points on shape
	for (var i = 0; i < numPoint; ++i)
	{
		var angle = (i / numPoint) * (2.0 * Math.PI);
		this.setPoint(i + 1, new Point(Math.cos(angle) * radius, Math.sin(angle) * radius));
		this.setUV(i + 1, new Point((Math.cos(angle) + 1.0) * 0.5, (Math.sin(angle) + 1.0) * 0.5));

		this.indices[i * 3 + 0] = 0;
		if ( i == (numPoint - 1) )
		{
			this.indices[i * 3 + 1] = i + 1;
			this.indices[i * 3 + 2] = 1;
		}
		else
		{
			this.indices[i * 3 + 1] = i + 1;
			this.indices[i * 3 + 2] = i + 2;
		}
	}

	// Set Normals
	this.createNormals();
}

// Prototypal Inheritance.
Cone.prototype = new PolygonMesh();
Cone.prototype.constructor = Cone;