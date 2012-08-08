
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




// This script is responsible for creating the scene rendered using shadow maps.




// Constructor.

function ShadowMapSceneGen ()
{
}



// Function creates the VBO objects used in the scene.

ShadowMapSceneGen.Create = function ()
{
	// Array to store the list of entities in the scene.
	var entity = new Array();

	// Create the room (box)
	var cubeMesh = new Cube(10.0, 3.0, 10.0);
	// Invert cube normals because we're inside the cube
	for (var i = 0; i < cubeMesh.Normal.length; ++i)
		cubeMesh.Normal[i] = -cubeMesh.Normal[i];
	var cubeVbo = new GLVertexBufferObject();
	cubeVbo.Create(cubeMesh);
	
	// Create the column (cylinder)
	var cylinderMesh = new Cylinder(32.0, 0.25, 6.0);
	var cylinderVbo = new GLVertexBufferObject();
	cylinderVbo.Create(cylinderMesh);
	
	// Create the central stand
	var cubeMeshStand = new Cube(1.0, 1.0, 1.0);
	var cubeStandVbo = new GLVertexBufferObject();
	cubeStandVbo.Create(cubeMeshStand);
	
	// Create the central marble
	var sphereMesh = new Sphere(24, 24, 1.0, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.Create(sphereMesh);
	
	// Create entities
	var roomEntity = new Entity();
	roomEntity.ObjectEntity = cubeVbo;
	roomEntity.ObjectMatrix.Translate(0.0, 0.0, 0.0);
	roomEntity.ObjectMaterial.Diffuse.SetPoint(0.8, 0.8, 0.8);
	roomEntity.ObjectMaterial.Specular.SetPoint(0.0, 0.0, 0.0);
	entity.push(roomEntity);
	
	// 4 column entities
	for (var x = -1; x <= 1; x += 2)
	{
		for (var z = -1; z <= 1; z += 2)
		{
			var columnEntity = new Entity();
			columnEntity.ObjectEntity = cylinderVbo;
			columnEntity.ObjectMatrix.Translate(x * 3.5, 0.0, z * 3.5);
			columnEntity.ObjectMatrix.Rotate(90.0, 0.0, 0.0);
			columnEntity.ObjectMaterial.Diffuse.SetPoint(0.6, 0.6, 0.6);
			columnEntity.ObjectMaterial.Specular.SetPoint(0.1, 0.1, 0.1);
			columnEntity.ObjectMaterial.Shininess = 6;
			entity.push(columnEntity);
		}
	}
	
	// Central stand
	var cubeStandEntity = new Entity();
	cubeStandEntity.ObjectEntity = cubeStandVbo;
	cubeStandEntity.ObjectMatrix.Translate(0.0, -2.0, 0.0);
	cubeStandEntity.ObjectMatrix.Scale(0.5, 1.0, 0.5);
	cubeStandEntity.ObjectMaterial.Diffuse.SetPoint(0.8, 0.8, 0.8);
	cubeStandEntity.ObjectMaterial.Specular.SetPoint(0.0, 0.0, 0.0);
	entity.push(cubeStandEntity);
	
	// Central marble
	var sphereEntity = new Entity();
	sphereEntity.ObjectEntity = sphereVbo;
	sphereEntity.ObjectMatrix.Translate(0.0, -0.5, 0.0);
	sphereEntity.ObjectMatrix.Scale(0.5, 0.5, 0.5);
	sphereEntity.ObjectMaterial.Diffuse.SetPoint(0.8, 0.4, 0.4);
	sphereEntity.ObjectMaterial.Specular.SetPoint(0.4, 0.4, 0.4);
	sphereEntity.ObjectMaterial.Shininess = 32;
	entity.push(sphereEntity);
	
	return entity;
}