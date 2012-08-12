// This class contains a collection of vertices, uvs, normals, and indices
// that all defines the shape of a polyhedral object, constructed entirely
// of triangles.
function PolygonMesh ()
{
	// Stores a list of points (vertices, (x,y,z)) for this polygon.
	this.vertices = null;

	// Stores the texture coordinate (u,v) for each vertex.
	this.uvs = null;

	// Stores a list of normal vectors (x,y,z) for each vertex.
	this.normals = null;
	
	// Stores a list of indices associated with this mesh.
	this.indices = null;
}

// Create a new mesh with memory allocated for the specified number
// of points.
// <param name="numPoint">The number of points to allocate for this mesh.</param>
// <param name="numIndices">
//		The number of indices to allocate for this mesh. The number should also
//		include the number of edges for each polygon. For example, a triangle
//		has 3 edges, so the number of indices should equal = N * 3.
//	</param>
PolygonMesh.prototype.create = function (numPoint, numIndices)
{
	this.vertices = new Float32Array(numPoint * 3);
	this.uvs = new Float32Array(numPoint * 2);
	this.normals = new Float32Array(numPoint * 3);
	this.indices = new Uint16Array(numIndices);
}

// Calculates the normals for all polygons.
PolygonMesh.prototype.createNormals = function ()
{
	var numPolygon = 0;
	if ( this.indices != null )
		numPolygon = this.indices.length;
	else
		numPolygon = this.getNumPoints() * 3;

	// Zero normals
	var numPoint = this.getNumPoints() * 3;
	for (var i = 0; i < numPoint; ++i)
		this.normals[i] = 0;

	// Sum normals
	for (var i = 0; i < numPolygon; i += 3)
	{
		var i1 = this.indices[i];
		var i2 = this.indices[i + 1];
		var i3 = this.indices[i + 2];
		
		var p1 = this.getPoint(i1);
		var p2 = this.getPoint(i2);
		var p3 = this.getPoint(i3);

		var v1 = p1.subtract(p2);
		var v2 = p2.subtract(p3);
		var normal = v1.cross(v2);

		this.setNormal(i1, this.getNormal(i1).add(normal));
		this.setNormal(i2, this.getNormal(i2).add(normal));
		this.setNormal(i3, this.getNormal(i3).add(normal));
	}

	// normalize normals
	for (var i = 0; i < numPolygon; ++i)
	{
		var index = this.indices[i];
		this.setNormal(index, this.getNormal(index).normalize());
	}
}

// Returns the number of points in this polygon.
PolygonMesh.prototype.getNumPoints = function ()
{
	return (this.vertices != null) ? this.vertices.length / 3 : 0;
}

// Returns the number of indices in this mesh.
PolygonMesh.prototype.getNumIndices = function ()
{
	return (this.indices != null) ? this.indices.length : 0;
}

// Returns the point at the specified index.
// <param name="index">Index in polygon to retrieve the point for.</param>
// <returns>A reference to the point, otherwise null.</returns>
PolygonMesh.prototype.getPoint = function (index)
{
	index *= 3;
	if ( (index + 2) < this.vertices.length )
		return new Point(this.vertices[index], this.vertices[index + 1], this.vertices[index + 2]);
	return null;
}

// Sets / updates the point at the specified index.
// <param name="point">Point to set into the polygon.</param>
PolygonMesh.prototype.setPoint = function (index, point)
{
	index *= 3;
	if ( (index + 2) < this.vertices.length )
	{
		this.vertices[index    ] = point.x;
		this.vertices[index + 1] = point.y;
		this.vertices[index + 2] = point.z;
	}
}

// Returns the uv at the specified index.
// <param name="index">Index in polygon to retrieve the uv for.</param>
// <returns>A reference to the uv, otherwise null.</returns>
PolygonMesh.prototype.getUV = function (index)
{
	index *= 2;
	if ( (index + 1) < this.uvs.length )
		return new Point(this.uvs[index], this.uvs[index + 1]);
	return null;
}

// Sets / updates the uv at the specified index.
// <param name="uv">Texture coordinate for the point.</param>
PolygonMesh.prototype.setUV = function (index, uv)
{
	index *= 2;
	if ( (index + 1) < this.uvs.length )
	{
		this.uvs[index    ] = uv.x;
		this.uvs[index + 1] = uv.y;
	}
}

// Returns the normal at the specified index.
// <param name="index">Index in polygon to retrieve the normal for.</param>
// <returns>A reference to the normal, otherwise null.</returns>
PolygonMesh.prototype.getNormal = function (index)
{
	index *= 3;
	if ( (index + 2) < this.normals.length )
		return new Point(this.normals[index], this.normals[index + 1], this.normals[index + 2]);
	return null;
}

// Sets / updates the point at the specified index.
// <param name="normal">Normal vector for the point.</param>
PolygonMesh.prototype.setNormal = function (index, normal)
{
	index *= 3;
	if ( (index + 2) < this.normals.length )
	{
		this.normals[index    ] = normal.x;
		this.normals[index + 1] = normal.y;
		this.normals[index + 2] = normal.z;
	}
}