// This class provides high-level access to GL vertex buffer objects. It is a
// container for a single mesh object.
function GLVertexBufferObject ()
{
	// Identifier assigned to the vertex object.
	this.vertexBuffer = null;

	// Identifier assigned to the vertex uv object.
	this.uvBuffer = null;

	// Identifier assigned to the vertex normal object.
	this.normalBuffer = null;

	// Identifier assigned to the vertex colour object.
	this.colourBuffer = null;

	// Identifier assigned to the vertex bone object.
	this.boneBuffer = null;

	// Identifier assigned to the vertex bone weight object.
	this.boneWeightBuffer = null;
	
	// Identifier assigned to the index object.
	this.indexBuffer = null;

	// Stores the buffer type.
	this.type;

	// Reference to the polygon mesh assigned to this VBO.
	this.mesh = null;
}

// Possible vertex buffer object types.
GLVertexBufferObject.BufferType =
{
	Static : 0,
	Dynamic : 1
};

// Create a new VBO.
// <param name="mesh">Mesh to create a VBO for.</param>
// <param name="type">The type of vertex buffer object to create.</param>
// <returns>True if the VBO was created successfully.</returns>
GLVertexBufferObject.prototype.create = function (mesh, type)
{
	// Cleanup
	this.release();
	
	this.mesh = mesh;
	if ( (type == null) || (type == GLVertexBufferObject.BufferType.Static) )
		type = gl.STATIC_DRAW;
	else
		type = gl.DYNAMIC_DRAW;
		
	this.type = type;
		

	// Create vertex buffer
	this.vertexBuffer = gl.createBuffer();
	if ( this.vertexBuffer == null )
	{
		this.release();
		return false;
	}
	gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, mesh.vertices, type);

	// Create uv buffer
	if ( mesh.uvs != null )
	{
		this.uvBuffer = gl.createBuffer();
		if ( this.uvBuffer == null )
		{
			this.release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.uvBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.uvs, type);
	}

	// Set normal buffer
	if ( mesh.normals != null )
	{
		this.normalBuffer = gl.createBuffer();
		if ( this.normalBuffer == null )
		{
			this.release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.normalBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.normals, type);
	}
	
	// Set colour buffer
	if ( mesh.colours != null )
	{
		this.colourBuffer = gl.createBuffer();
		if ( this.colourBuffer == null )
		{
			this.release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.colourBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.colours, type);
	}
	
	// Set bone buffer
	if ( mesh.bones != null )
	{
		this.boneBuffer = gl.createBuffer();
		if ( this.boneBuffer == null )
		{
			this.release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.boneBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.bones, type);
	}
	
	// Set bone weight buffer
	if ( mesh.boneWeights != null )
	{
		this.boneWeightBuffer = gl.createBuffer();
		if ( this.boneWeightBuffer == null )
		{
			this.release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.boneWeightBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.boneWeights, type);
	}
		
	if ( mesh.indices != null )
	{
		// Set index buffer
		this.indexBuffer = gl.createBuffer();
		if ( this.indexBuffer == null )
		{
			this.release();
			return false;
		}
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, mesh.indices, type);
	}

	return true;
}

// Removes the VBO from memory.
GLVertexBufferObject.prototype.release = function ()
{
	// Clenaup
	if ( this.vertexBuffer != null )
	{
		gl.deleteBuffer(this.vertexBuffer);
		this.vertexBuffer = null;
	}
	if ( this.uvBuffer != null )
	{
		gl.deleteBuffer(this.uvBuffer);
		this.uvBuffer = null;
	}
	if ( this.normalBuffer != null )
	{
		gl.deleteBuffer(this.normalBuffer);
		this.normalBuffer = null;
	}
	if ( this.colourBuffer != null )
	{
		gl.deleteBuffer(this.colourBuffer);
		this.colourBuffer = null;
	}
	if ( this.boneBuffer != null )
	{
		gl.deleteBuffer(this.boneBuffer);
		this.boneBuffer = null;
	}
	if ( this.boneWeightBuffer != null )
	{
		gl.deleteBuffer(this.boneWeightBuffer);
		this.boneWeightBuffer = null;
	}
	if ( this.indexBuffer != null )
	{
		gl.deleteBuffer(this.indexBuffer);
		this.indexBuffer = null;
	}

	this.mesh = null;
}

// Updates the vertex buffer with new vertex data.
GLVertexBufferObject.prototype.updateVertexBuffer = function ()
{
	gl.bindBuffer(gl.ARRAY_BUFFER, this.vertexBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, this.mesh.vertices, this.type);
}

// Updates the normal buffer with new normal data.
GLVertexBufferObject.prototype.updateNormalBuffer = function ()
{
	gl.bindBuffer(gl.ARRAY_BUFFER, this.normalBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, this.mesh.normals, this.type);
}

// Updates the vertex colour buffer with new colour data.
GLVertexBufferObject.prototype.updateColourBuffer = function ()
{
	gl.bindBuffer(gl.ARRAY_BUFFER, this.colourBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, this.mesh.colours, this.type);
}

// Updates the vertex colour buffer with new colour data.
GLVertexBufferObject.prototype.updateBoneBuffer = function ()
{
	gl.bindBuffer(gl.ARRAY_BUFFER, this.boneBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, this.mesh.bones, this.type);

	gl.bindBuffer(gl.ARRAY_BUFFER, this.boneWeightBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, this.mesh.boneWeights, this.type);
}

// Updates the index buffer with new index data.
GLVertexBufferObject.prototype.updateIndexBuffer = function ()
{
	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
	gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, this.mesh.indices, this.type);
}