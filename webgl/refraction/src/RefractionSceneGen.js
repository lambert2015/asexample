
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

function RefractionSceneGen ()
{
}



// Function creates the VBO objects used in the scene.

RefractionSceneGen.Create = function ()
{
	// Array to store the list of entities in the scene.
	var entity = [];

	// Create scene VBOs
	var sphereMesh = new Sphere(32, 32, 1.0, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.Create(sphereMesh);
	
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.Create(rectMesh);
	
	var cubeMesh = new Cube(1.0, 1.0, 1.0);
	var cubeVbo = new GLVertexBufferObject();
	cubeVbo.Create(cubeMesh);
	
	// Create ground entity
	var groundEntity = new Entity();
	groundEntity.objectEntity = rectVbo;
	groundEntity.objectMaterial.Ambient.setPoint(0.2, 0.2, 0.2);
	groundEntity.objectMaterial.Diffuse.setPoint(0.8, 0.8, 0.8);
	groundEntity.objectMaterial.Specular.setPoint(0.0, 0.0, 0.0);
	groundEntity.objectMaterial.TextureScale.setPoint(10.0, 10.0);
	groundEntity.objectMatrix.Translate(0.0, -1.0, 0.0);
	groundEntity.objectMatrix.Rotate(-90.0, 0.0, 0.0);
	groundEntity.objectMatrix.Scale(50.0, 50.0, 1.0);
	entity.push(groundEntity);
	
	// Random spheres
	var random = new RandomGenerator();
	random.Seed(0);
	for (var i = 0; i < 10; ++i)
	{
		var propEntity = new Entity();
		propEntity.objectEntity = sphereVbo;
		propEntity.objectMaterial.Ambient.setPoint(0.1, 0.1, 0.1);
		propEntity.objectMaterial.Diffuse.setPoint(0.8, 0.8, 0.8);
		propEntity.objectMaterial.Specular.setPoint(0.0, 0.0, 0.0);
		var scale = random.RandomFloat(0.25, 1.5);
		if ( i == 0 )
		{
			propEntity.objectMatrix.Translate(0.0, 0.0, -2.0);
			scale = 1.0;
		}
		else
			propEntity.objectMatrix.Translate(random.RandomFloat(-30.0, 30.0), (scale - 1.0), -2.0 - i * 3.0);
		//propEntity.objectMatrix.Rotate(-90.0, 0.0, 0.0);
		propEntity.objectMatrix.Scale(scale, scale, scale);
		entity.push(propEntity);
	}
	
	// Create heat entity that will show the heat haze (not actually drawn)
	var heatEntity = new Entity();
	heatEntity.objectEntity = rectVbo;
	heatEntity.objectMatrix.Translate(0.0, 0.0, 0.0);
	heatEntity.objectMatrix.Rotate(0.0, 0.0, 0.0);
	heatEntity.objectMatrix.Scale(256.0, 2.0, 1.0);
	entity.push(heatEntity);
	
	// Create skybox (will use cubemaps)
	var skyboxEntity = new Entity();
	skyboxEntity.objectEntity = cubeVbo;
	skyboxEntity.objectMatrix.Scale(512.0, 512.0, 512.0);
	entity.push(skyboxEntity);
	
	return entity;
}