
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

function DepthOfFieldSceneGen ()
{
}



// Function creates the VBO objects used in the scene.

DepthOfFieldSceneGen.Create = function ()
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
	
	// Create the plane (ruler)
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.Create(rectMesh);
	
	// Create the sphere
	var sphereMesh = new Sphere(24, 24, 1.0, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.Create(sphereMesh);
	
	// Create the cyinders
	var cylinderMesh = new Cylinder(32.0, 0.5, 2.0);
	var cylinderVbo = new GLVertexBufferObject();
	cylinderVbo.Create(cylinderMesh);
	
	// Create entities
	var rulerEntity = new Entity();
	rulerEntity.objectEntity = rectVbo;
	rulerEntity.objectMatrix.Translate(0.0, 2.9, 0.0);
	rulerEntity.objectMatrix.Rotate(90.0, 90.0, 0.0);
	rulerEntity.objectMatrix.Scale(10.0, -1.0, 1.0);
	rulerEntity.objectMaterial.Ambient.setPoint(0.2, 0.2, 0.2);
	rulerEntity.objectMaterial.Diffuse.setPoint(0.8, 0.8, 0.8);
	rulerEntity.objectMaterial.Specular.setPoint(0.0, 0.0, 0.0);
	// Ruler texture is only 124 pixels high. Need to scale texture to fit rectangle.
	// Note: ruler texture is larger than normal in order to support mipmapping.
	rulerEntity.objectMaterial.TextureScale.y = 124.0 / 1024.0;
	entity.push(rulerEntity);
	
	var roomEntity = new Entity();
	roomEntity.objectEntity = cubeVbo;
	roomEntity.objectMatrix.Translate(0.0, 0.0, 0.0);
	roomEntity.objectMaterial.Diffuse.setPoint(0.8, 0.8, 0.8);
	roomEntity.objectMaterial.Specular.setPoint(0.0, 0.0, 0.0);
	entity.push(roomEntity);
	
	// DOF Objects
	for (var x = 0; x < 7; ++x)
	{
		var entityInstance = new Entity();
		entityInstance.objectEntity = cylinderVbo;
		entityInstance.objectMatrix.Translate((x - 4.0) * 2, -2.0, (x - 4.5) * 2);
		entityInstance.objectMatrix.Rotate(90.0, 0.0, 0.0);
		if ( x % 3 == 0 )
			entityInstance.objectMaterial.Diffuse.setPoint(((x + 7.0) / 7.0), 0.5, 0.5);
		else if ( x % 3 == 1 )
			entityInstance.objectMaterial.Diffuse.setPoint(0.5, ((x + 7.0) / 7.0), 0.5);
		else
			entityInstance.objectMaterial.Diffuse.setPoint(0.5, 0.5, ((x + 7.0) / 7.0));
		entityInstance.objectMaterial.Specular.setPoint(0.1, 0.1, 0.1);
		entityInstance.objectMaterial.Shininess = 6;
		entity.push(entityInstance);
	}
	
	// Create one more near the camera
	var entityInstance = new Entity();
	entityInstance.objectEntity = cylinderVbo;
	entityInstance.objectMatrix.Translate(-2.0, -2.0, 7.0);
	entityInstance.objectMatrix.Rotate(90.0, 0.0, 0.0);
	if ( x % 3 == 0 )
		entityInstance.objectMaterial.Diffuse.setPoint(((x + 7.0) / 7.0), 0.5, 0.5);
	else if ( x % 3 == 1 )
		entityInstance.objectMaterial.Diffuse.setPoint(0.5, ((x + 7.0) / 7.0), 0.5);
	else
		entityInstance.objectMaterial.Diffuse.setPoint(0.5, 0.5, ((x + 7.0) / 7.0));
	entityInstance.objectMaterial.Specular.setPoint(0.1, 0.1, 0.1);
	entityInstance.objectMaterial.Shininess = 6;
	entity.push(entityInstance);
	
	return entity;
}