/// <summary>
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
/// Basic lighting vertex shader.
/// </summary>


/// <summary>
/// Material source structure.
/// <summary>
struct MaterialSource
{
	vec3 Ambient;
	vec4 Diffuse;
	vec3 Specular;
	float Shininess;
	vec2 TextureOffset;
	vec2 TextureScale;
};


/// <summary>
/// Attributes.
/// <summary>
attribute vec3 Vertex;
attribute vec2 Uv;
attribute vec3 Normal;


/// <summary>
/// Uniform variables.
/// <summary>
uniform mat4 ProjectionMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ModelMatrix;
uniform vec3 ModelScale;

uniform MaterialSource Material;


/// <summary>
/// Varying variables.
/// <summary>
varying vec4 vWorldVertex;
varying vec3 vWorldNormal;
varying vec2 vUv;
varying vec3 vViewVec;


/// <summary>
/// Vertex shader entry.
/// <summary>
void main ()
{
	// Transform the vertex
	vWorldVertex = ModelMatrix * vec4(Vertex * ModelScale, 1.0);
	vec4 viewVertex = ViewMatrix * vWorldVertex;
	gl_Position = ProjectionMatrix * viewVertex;
	
	// Setup the UV coordinates
	vUv = Material.TextureOffset + (Uv * Material.TextureScale);
	
	// Rotate normal
	vWorldNormal = normalize(mat3(ModelMatrix) * Normal);
	
	// Calculate view vector (for specular lighting)
	vViewVec = normalize(-viewVertex.xyz);
}