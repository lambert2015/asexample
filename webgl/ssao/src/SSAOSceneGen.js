
// Nutty Software Open WebGL Framework
// 
// Copyright (C) 2012 Nathaniel Meyer
// Nutty Software, http://www.nutty.ca
// All Rights Reserved.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//     1. The above copyright notice and this permission notice shall be included in all
//        copies or substantial portions of the Software.
//     2. Redistributions in binary or minimized form must reproduce the above copyright
//        notice and this list of conditions in the documentation and/or other materials
//        provided with the distribution.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.




// This script is responsible for creating the scene entities for the demo.




// Constructor.

function SSAOSceneGen ()
{
}



// Function creates the VBO objects used in the scene.

SSAOSceneGen.Create = function ()
{
	// Array to store the list of entities in the scene.
	var entity = new Array();

	// Create scene content
	var sphereMesh = new Sphere(32, 32, 1.0, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.Create(sphereMesh);
	
	var cubeMesh = new Cube(1.0, 1.0, 1.0);
	// Invert cube normals because we're inside the cube
	for (var i = 0; i < cubeMesh.Normal.length; ++i)
		cubeMesh.Normal[i] = -cubeMesh.Normal[i];
	var cubeVbo = new GLVertexBufferObject();
	cubeVbo.Create(cubeMesh);
	
	// Create torus knot 1
	var torusKnotMesh = new TorusKnot(2, 3, 64, 64, 0.1, 0.5);
	var torusKnotVbo = new GLVertexBufferObject();
	torusKnotVbo.Create(torusKnotMesh);
	
	// Create torus knot 2
	var torusKnotMesh2 = new TorusKnot(3, 8, 64, 64, 0.1, 0.5);
	var torusKnotVbo2 = new GLVertexBufferObject();
	torusKnotVbo2.Create(torusKnotMesh2);
	
	
	// Stack a bunch of spheres in the shape of a cone
	var count = 4;
	var current = count;
	var scale = 0.4;
	var spread = scale * 2.0;
	var halfCount = (current - 1.0) * 0.5 * spread;
	var ySpread = Math.sqrt(scale * scale * 2.0);
	for (var y = 0; y < count; ++y)
	{
		for (var z = 0; z < current; ++z)
		{
			for (var x = 0; x < current; ++x)
			{
				var sphereEntity = new Entity();
				sphereEntity.ObjectEntity = sphereVbo;
				sphereEntity.ObjectMaterial.Ambient.SetPoint(0.4, 0.4, 0.4);
				sphereEntity.ObjectMaterial.Specular.SetPoint(0.0, 0.0, 0.0);
				sphereEntity.ObjectMatrix.Translate(x * spread - halfCount, y * ySpread, z * spread - halfCount);
				sphereEntity.ObjectMatrix.Scale(scale, scale, scale);
				entity.push(sphereEntity);
			}
		}
		--current;
		if ( current == 0 )
			current = 1;
		halfCount = (current - 1.0) * 0.5 * spread;
	}
	
	// Create a cube entity (room)
	var cubeEntity = new Entity();
	cubeEntity.ObjectEntity = cubeVbo;
	cubeEntity.ObjectMatrix.Translate(0.0, 1.7, 0.0);
	cubeEntity.ObjectMatrix.Scale(4.0, 2.0, 4.0);
	entity.push(cubeEntity);
	
	// Create a torus knot entity
	var torusKnotEntity = new Entity();
	torusKnotEntity.ObjectEntity = torusKnotVbo;
	torusKnotEntity.ObjectMatrix.Translate(0.0, 1.5, 1.5);
	torusKnotEntity.ObjectMatrix.Scale(1.0, 1.0, 1.0);
	torusKnotEntity.ObjectMaterial.Ambient.SetPoint(0.4, 0.4, 0.4);
	entity.push(torusKnotEntity);
	
	// Create a torus knot entity
	var torusKnotEntity2 = new Entity();
	torusKnotEntity2.ObjectEntity = torusKnotVbo2;
	torusKnotEntity2.ObjectMatrix.Translate(0.0, 1.5, -1.5);
	torusKnotEntity2.ObjectMatrix.Scale(1.0, 1.0, 1.0);
	torusKnotEntity2.ObjectMaterial.Ambient.SetPoint(0.4, 0.4, 0.4);
	entity.push(torusKnotEntity2);
	
	return entity;
}