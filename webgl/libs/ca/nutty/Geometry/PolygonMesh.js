// <summary>
// This class contains a collection of vertices, uvs, normals, and indices
// that all defines the shape of a polyhedral object, constructed entirely
// of triangles.
// </summary>


// <summary>
// Constructor.
// </summary>
function PolygonMesh ()
{
	// <summary>
	// Stores a list of points (vertices, (x,y,z)) for this polygon.
	// </summary>
	this.VertexPoint = null;


	// <summary>
	// Stores the texture coordinate (u,v) for each vertex.
	// </summary>
	this.UV = null;


	// <summary>
	// Stores a list of normal vectors (x,y,z) for each vertex.
	// </summary>
	this.Normal = null;
	
	
	// <summary>
	// Stores a list of indices associated with this mesh.
	// </summary>
	this.Index = null;
}


// <summary>
// Create a new mesh with memory allocated for the specified number
// of points.
// </summary>
// <param name="numPoint">The number of points to allocate for this mesh.</param>
// <param name="numIndices">
//		The number of indices to allocate for this mesh. The number should also
//		include the number of edges for each polygon. For example, a triangle
//		has 3 edges, so the number of indices should equal = N * 3.
//	</param>
PolygonMesh.prototype.Create = function (numPoint, numIndices)
{
	this.VertexPoint = new Float32Array(numPoint * 3);
	this.UV = new Float32Array(numPoint * 2);
	this.Normal = new Float32Array(numPoint * 3);
	this.Index = new Uint16Array(numIndices);
}


// <summary>
// Calculates the normals for all polygons.
// </summary>
PolygonMesh.prototype.CreateNormals = function ()
{
	var numPolygon = 0;
	if ( this.Index != null )
		numPolygon = this.Index.length;
	else
		numPolygon = this.GetNumPoints() * 3;

	// Zero normals
	var numPoint = this.GetNumPoints() * 3;
	for (var i = 0; i < numPoint; ++i)
		this.Normal[i] = 0;

	// Sum normals
	for (var i = 0; i < numPolygon; i += 3)
	{
		var i1 = this.Index[i];
		var i2 = this.Index[i + 1];
		var i3 = this.Index[i + 2];
		
		var p1 = this.GetPoint(i1);
		var p2 = this.GetPoint(i2);
		var p3 = this.GetPoint(i3);

		var v1 = p1.Subtract(p2);
		var v2 = p2.Subtract(p3);
		var normal = v1.Cross(v2);

		this.SetNormal(i1, this.GetNormal(i1).Add(normal));
		this.SetNormal(i2, this.GetNormal(i2).Add(normal));
		this.SetNormal(i3, this.GetNormal(i3).Add(normal));
	}

	// Normalize normals
	for (var i = 0; i < numPolygon; ++i)
	{
		var index = this.Index[i];
		this.SetNormal(index, this.GetNormal(index).Normalize());
	}
}


// <summary>
// Returns the number of points in this polygon.
// </summary>
PolygonMesh.prototype.GetNumPoints = function ()
{
	return (this.VertexPoint != null) ? this.VertexPoint.length / 3 : 0;
}


// <summary>
// Returns the number of indices in this mesh.
// </summary>
PolygonMesh.prototype.GetNumIndices = function ()
{
	return (this.Index != null) ? this.Index.length : 0;
}


// <summary>
// Returns the point at the specified index.
// </summary>
// <param name="index">Index in polygon to retrieve the point for.</param>
// <returns>A reference to the point, otherwise null.</returns>
PolygonMesh.prototype.GetPoint = function (index)
{
	index *= 3;
	if ( (index + 2) < this.VertexPoint.length )
		return new Point(this.VertexPoint[index], this.VertexPoint[index + 1], this.VertexPoint[index + 2]);
	return null;
}


// <summary>
// Sets / updates the point at the specified index.
// </summary>
// <param name="point">Point to set into the polygon.</param>
PolygonMesh.prototype.SetPoint = function (index, point)
{
	index *= 3;
	if ( (index + 2) < this.VertexPoint.length )
	{
		this.VertexPoint[index    ] = point.x;
		this.VertexPoint[index + 1] = point.y;
		this.VertexPoint[index + 2] = point.z;
	}
}


// <summary>
// Returns the uv at the specified index.
// </summary>
// <param name="index">Index in polygon to retrieve the uv for.</param>
// <returns>A reference to the uv, otherwise null.</returns>
PolygonMesh.prototype.GetUV = function (index)
{
	index *= 2;
	if ( (index + 1) < this.UV.length )
		return new Point(this.UV[index], this.UV[index + 1]);
	return null;
}


// <summary>
// Sets / updates the uv at the specified index.
// </summary>
// <param name="uv">Texture coordinate for the point.</param>
PolygonMesh.prototype.SetUV = function (index, uv)
{
	index *= 2;
	if ( (index + 1) < this.UV.length )
	{
		this.UV[index    ] = uv.x;
		this.UV[index + 1] = uv.y;
	}
}


// <summary>
// Returns the normal at the specified index.
// </summary>
// <param name="index">Index in polygon to retrieve the normal for.</param>
// <returns>A reference to the normal, otherwise null.</returns>
PolygonMesh.prototype.GetNormal = function (index)
{
	index *= 3;
	if ( (index + 2) < this.Normal.length )
		return new Point(this.Normal[index], this.Normal[index + 1], this.Normal[index + 2]);
	return null;
}


// <summary>
// Sets / updates the point at the specified index.
// </summary>
// <param name="normal">Normal vector for the point.</param>
PolygonMesh.prototype.SetNormal = function (index, normal)
{
	index *= 3;
	if ( (index + 2) < this.Normal.length )
	{
		this.Normal[index    ] = normal.x;
		this.Normal[index + 1] = normal.y;
		this.Normal[index + 2] = normal.z;
	}
}