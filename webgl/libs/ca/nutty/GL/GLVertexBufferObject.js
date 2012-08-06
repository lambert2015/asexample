/// <summary>
/// Nutty Software Open WebGL Framework
/// 
/// Copyright (C) 2012 Nathaniel Meyer
/// Nutty Software, http://www.nutty.ca
/// All Rights Reserved.
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy of
/// this software and associated documentation files (the "Software"), to deal in
/// the Software without restriction, including without limitation the rights to
/// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
/// of the Software, and to permit persons to whom the Software is furnished to do
/// so, subject to the following conditions:
///     1. The above copyright notice and this permission notice shall be included in all
///        copies or substantial portions of the Software.
///     2. Redistributions in binary or minimized form must reproduce the above copyright
///        notice and this list of conditions in the documentation and/or other materials
///        provided with the distribution.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
/// </summary>


/// <summary>
/// This class provides high-level access to GL vertex buffer objects. It is a
/// container for a single mesh object.
/// </summary>


/// <summary>
/// Constructor.
/// <summary>
function GLVertexBufferObject ()
{
	/// <summary>
	/// Identifier assigned to the vertex object.
	/// <summary>
	this.VertexBuffer = null;


	/// <summary>
	/// Identifier assigned to the vertex uv object.
	/// <summary>
	this.UvBuffer = null;


	/// <summary>
	/// Identifier assigned to the vertex normal object.
	/// <summary>
	this.NormalBuffer = null;
	
	
	/// <summary>
	/// Identifier assigned to the vertex colour object.
	/// <summary>
	this.ColourBuffer = null;
	
	
	/// <summary>
	/// Identifier assigned to the vertex bone object.
	/// <summary>
	this.BoneBuffer = null;


	/// <summary>
	/// Identifier assigned to the vertex bone weight object.
	/// <summary>
	this.BoneWeightBuffer = null;


	/// <summary>
	/// Identifier assigned to the index object.
	/// <summary>
	this.IndexBuffer = null;
	
	
	/// <summary>
	/// Stores the buffer type.
	/// <summary>
	this.Type;


	/// <summary>
	/// Reference to the polygon mesh assigned to this VBO.
	/// <summary>
	this.Mesh = null;
}


/// <summary>
/// Possible vertex buffer object types.
/// <summary>
GLVertexBufferObject.BufferType =
{
	Static : 0,
	Dynamic : 1
};


/// <summary>
/// Create a new VBO.
/// <summary>
/// <param name="mesh">Mesh to create a VBO for.</param>
/// <param name="type">The type of vertex buffer object to create.</param>
/// <returns>True if the VBO was created successfully.</returns>
GLVertexBufferObject.prototype.Create = function (mesh, type)
{
	// Cleanup
	this.Release();
	
	
	this.Mesh = mesh;
	if ( (type == null) || (type == GLVertexBufferObject.BufferType.Static) )
		type = gl.STATIC_DRAW;
	else
		type = gl.DYNAMIC_DRAW;
	this.Type = type;
		

	// Create vertex buffer
	this.VertexBuffer = gl.createBuffer();
	if ( this.VertexBuffer == null )
	{
		this.Release();
		return false;
	}
	gl.bindBuffer(gl.ARRAY_BUFFER, this.VertexBuffer);
	//gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(mesh.VertexPoint), type);
	gl.bufferData(gl.ARRAY_BUFFER, mesh.VertexPoint, type);

	// Create uv buffer
	if ( mesh.UV != null )
	{
		this.UvBuffer = gl.createBuffer();
		if ( this.UvBuffer == null )
		{
			this.Release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.UvBuffer);
		//gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(mesh.UV), type);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.UV, type);
	}

	// Set normal buffer
	if ( mesh.Normal != null )
	{
		this.NormalBuffer = gl.createBuffer();
		if ( this.NormalBuffer == null )
		{
			this.Release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.NormalBuffer);
		//gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(mesh.Normal), type);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.Normal, type);
	}
	
	// Set colour buffer
	if ( mesh.Colour != null )
	{
		this.ColourBuffer = gl.createBuffer();
		if ( this.ColourBuffer == null )
		{
			this.Release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.ColourBuffer);
		//gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(mesh.Colour), type);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.Colour, type);
	}
	
	// Set bone buffer
	if ( mesh.Bone != null )
	{
		this.BoneBuffer = gl.createBuffer();
		if ( this.BoneBuffer == null )
		{
			this.Release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.BoneBuffer);
		//gl.bufferData(gl.ARRAY_BUFFER, new Uint16Array(mesh.Bone), type);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.Bone, type);
	}
	
	// Set bone weight buffer
	if ( mesh.BoneWeight != null )
	{
		this.BoneWeightBuffer = gl.createBuffer();
		if ( this.BoneWeightBuffer == null )
		{
			this.Release();
			return false;
		}
		gl.bindBuffer(gl.ARRAY_BUFFER, this.BoneWeightBuffer);
		//gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(mesh.BoneWeight), type);
		gl.bufferData(gl.ARRAY_BUFFER, mesh.BoneWeight, type);
	}
		
	if ( mesh.Index != null )
	{
		// Set index buffer
		this.IndexBuffer = gl.createBuffer();
		if ( this.IndexBuffer == null )
		{
			this.Release();
			return false;
		}
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.IndexBuffer);
		//gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(mesh.Index), type);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, mesh.Index, type);
	}

	return true;
}


/// <summary>
/// Removes the VBO from memory.
/// <summary>
GLVertexBufferObject.prototype.Release = function ()
{
	// Clenaup
	if ( this.VertexBuffer != null )
	{
		gl.deleteBuffer(this.VertexBuffer);
		this.VertexBuffer = null;
	}
	if ( this.UvBuffer != null )
	{
		gl.deleteBuffer(this.UvBuffer);
		this.UvBuffer = null;
	}
	if ( this.NormalBuffer != null )
	{
		gl.deleteBuffer(this.NormalBuffer);
		this.NormalBuffer = null;
	}
	if ( this.ColourBuffer != null )
	{
		gl.deleteBuffer(this.ColourBuffer);
		this.ColourBuffer = null;
	}
	if ( this.BoneBuffer != null )
	{
		gl.deleteBuffer(this.BoneBuffer);
		this.BoneBuffer = null;
	}
	if ( this.BoneWeightBuffer != null )
	{
		gl.deleteBuffer(this.BoneWeightBuffer);
		this.BoneWeightBuffer = null;
	}
	if ( this.IndexBuffer != null )
	{
		gl.deleteBuffer(this.IndexBuffer);
		this.IndexBuffer = null;
	}

	this.Mesh = null;
}


/// <summary>
/// Updates the vertex buffer with new vertex data.
/// <summary>
GLVertexBufferObject.prototype.UpdateVertexBuffer = function ()
{
	gl.bindBuffer(gl.ARRAY_BUFFER, this.VertexBuffer);
	//gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(this.Mesh.VertexPoint), this.Type);
	gl.bufferData(gl.ARRAY_BUFFER, this.Mesh.VertexPoint, this.Type);
}


/// <summary>
/// Updates the normal buffer with new normal data.
/// <summary>
GLVertexBufferObject.prototype.UpdateNormalBuffer = function ()
{
	gl.bindBuffer(gl.ARRAY_BUFFER, this.NormalBuffer);
	//gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(this.Mesh.Normal), this.Type);
	gl.bufferData(gl.ARRAY_BUFFER, this.Mesh.Normal, this.Type);
}


/// <summary>
/// Updates the vertex colour buffer with new colour data.
/// <summary>
GLVertexBufferObject.prototype.UpdateColourBuffer = function ()
{
	gl.bindBuffer(gl.ARRAY_BUFFER, this.ColourBuffer);
	//gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(this.Mesh.Colour), this.Type);
	gl.bufferData(gl.ARRAY_BUFFER, this.Mesh.Colour, this.Type);
}


/// <summary>
/// Updates the vertex colour buffer with new colour data.
/// <summary>
GLVertexBufferObject.prototype.UpdateBoneBuffer = function ()
{
	gl.bindBuffer(gl.ARRAY_BUFFER, this.BoneBuffer);
	//gl.bufferData(gl.ARRAY_BUFFER, new Uint16Array(this.Mesh.Bone), this.Type);
	gl.bufferData(gl.ARRAY_BUFFER, this.Mesh.Bone, this.Type);

	gl.bindBuffer(gl.ARRAY_BUFFER, this.BoneWeightBuffer);
	//gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(this.Mesh.BoneWeight), this.Type);
	gl.bufferData(gl.ARRAY_BUFFER, this.Mesh.BoneWeight, this.Type);
}


/// <summary>
/// Updates the index buffer with new index data.
/// <summary>
GLVertexBufferObject.prototype.UpdateIndex = function ()
{
	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.IndexBuffer);
	gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(this.Mesh.Index), this.Type);
}