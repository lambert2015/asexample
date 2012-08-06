// <summary>
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
// </summary>


// <summary>
// This script is responsible for creating the scene entities for the demo.
// </summary>


// <summary>
// Constructor.
// </summary>
function GammaCorrectionSceneGen ()
{
}


// <summary>
// Function creates the VBO objects used in the scene.
// </summary>
GammaCorrectionSceneGen.Create = function ()
{
	// Array to store the list of entities in the scene.
	var entity = new Array();

	// Create scene content
	var sphereMesh = new Sphere(32, 32, 1.5, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.Create(sphereMesh);
	
	var cubeMesh = new Cube(4.0, 4.0, 6.0);
	// Invert cube normals because we're inside the cube
	for (var i = 0; i < cubeMesh.Normal.length; ++i)
		cubeMesh.Normal[i] = -cubeMesh.Normal[i];
	var cubeVbo = new GLVertexBufferObject();
	cubeVbo.Create(cubeMesh);
	
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.Create(rectMesh);
	
	
	// Create a sphere entity
	var sphereEntity = new Entity();
	sphereEntity.ObjectEntity = sphereVbo;
	sphereEntity.ObjectMaterial.Specular.SetPoint(0.0, 0.0, 0.0);
	sphereEntity.ObjectMatrix.Translate(0.0, -0.5, 0.0);
	sphereEntity.ObjectMatrix.Rotate(90.0, 0.0, 0.0);
	entity.push(sphereEntity);
	
	// Create a cube entity (room)
	var cubeEntity = new Entity();
	cubeEntity.ObjectEntity = cubeVbo;
	entity.push(cubeEntity);
	
	// Create rectangle entities (texture compare scene)
	var rectEntity1 = new Entity();
	rectEntity1.ObjectEntity = rectVbo;
	rectEntity1.ObjectMatrix.Translate(0.0, -0.5, 0.5);
	entity.push(rectEntity1);
	
	// Create rectangle entities for calibration testing
	var rectEntity2 = new Entity();
	rectEntity2.ObjectEntity = rectVbo;
	rectEntity2.ObjectMatrix.Translate(0.0, 0.4, 0.5);
	rectEntity2.ObjectMatrix.Scale(1.0, 0.1, 1.0);
	entity.push(rectEntity2);
	
	// Blacks Test
	var rectEntity3 = new Entity();
	rectEntity3.ObjectEntity = rectVbo;
	rectEntity3.ObjectMatrix.Translate(0.0, 0.1, 0.5);
	rectEntity3.ObjectMatrix.Scale(1.0, 0.1, 1.0);
	entity.push(rectEntity3);
	
	return entity;
}