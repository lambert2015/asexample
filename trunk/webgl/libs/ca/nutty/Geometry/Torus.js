// <summary>
// This class creates a torus mesh.
// </summary>


// <summary>
// Constructor.
// </summary>
// <param name="numSegments">Number of horizontal segments to create.</param>
// <param name="numRings">Number of vertical rings to create.</param>
// <param name="radius">Radius of the tube.</param>
// <param name="distance">Distance from the centre of the torus to the centre of the tube.</param>
function Torus (numSegments, numRings, radius, distance)
{
	// <summary>
	// Setup inherited members.
	// </summary>
	PolygonMesh.call(this);
	
	
	// One centre point + points along the circle
	this.Create(numSegments * numRings, ((numSegments - 1) * 6) * (numRings - 1));

	// Range between 0 and 2PI
	var u;
	var v;

	var point = 0;
	var index = 0;

	for (var i = 0; i < numRings; ++i)
	{
		v = (i / (numRings - 1.0)) * (2.0 * Math.PI);

		// One ring (circle) in the torus
		for (var j = 0; j < numSegments; ++j)
		{
			u = (j / (numSegments - 1.0)) * (2.0 * Math.PI);

			var w = distance + (radius * Math.cos(v));
			var x = w * Math.cos(u);
			var y = w * Math.sin(u);
			var z = radius * Math.sin(v);

			this.SetPoint(point, new Point(x, y, z));
			this.SetUV(point, new Point(i / (numRings - 1.0), j / (numSegments - 1.0)));
			
			if ( (i < (numRings - 1)) && (j < (numSegments - 1)) )
			{
				this.Index[index    ] = point;
				this.Index[index + 1] = point + 1;
				this.Index[index + 2] = point + 1 + numSegments;

				this.Index[index + 3] = point + 1 + numSegments;
				this.Index[index + 4] = point + numSegments;
				this.Index[index + 5] = point;
				
				index += 6;
			}
			
			++point;
		}
	}
	
	// Set Normals
	this.CreateNormals();
	
	// Average normals along the seam
	var index2;
	for (var i = 0; i < numRings; ++i)
	{
		index = i * numSegments * 3;
		index2 = index + (numSegments - 1) * 3;

		this.Normal[index    ] = (this.Normal[index    ] + this.Normal[index2    ]) * 0.5;
		this.Normal[index + 1] = (this.Normal[index + 1] + this.Normal[index2 + 1]) * 0.5;
		this.Normal[index + 2] = (this.Normal[index + 2] + this.Normal[index2 + 2]) * 0.5;

		this.Normal[index2    ] = this.Normal[index];
		this.Normal[index2 + 1] = this.Normal[index + 1];
		this.Normal[index2 + 2] = this.Normal[index + 2];
	}

	// Average normals along the seam
	var endIndex = (numRings - 1) * numSegments * 3;
	for (var i = 0; i < numSegments; ++i)
	{
		index = i * 3;
		this.Normal[index    ] = (this.Normal[index    ] + this.Normal[index + endIndex    ]) * 0.5;
		this.Normal[index + 1] = (this.Normal[index + 1] + this.Normal[index + endIndex + 1]) * 0.5;
		this.Normal[index + 2] = (this.Normal[index + 2] + this.Normal[index + endIndex + 2]) * 0.5;

		this.Normal[index + endIndex    ] = this.Normal[index];
		this.Normal[index + endIndex + 1] = this.Normal[index + 1];
		this.Normal[index + endIndex + 2] = this.Normal[index + 2];
	}
}


// <summary>
// Prototypal Inheritance.
// </summary>
Torus.prototype = new PolygonMesh();
Torus.prototype.constructor = Torus;