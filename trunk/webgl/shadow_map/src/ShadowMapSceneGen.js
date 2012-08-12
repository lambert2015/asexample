// This script is responsible for creating the scene rendered using shadow maps.

function ShadowMapSceneGen ()
{
}

// Function creates the VBO objects used in the scene.
ShadowMapSceneGen.create = function ()
{
	// Array to store the list of entities in the scene.
	var entity = [];

	// Create the room (box)
	var cubeMesh = new Cube(10.0, 3.0, 10.0);
	// Invert cube normals because we're inside the cube
	for (var i = 0; i < cubeMesh.normals.length; ++i)
		cubeMesh.normals[i] = -cubeMesh.normals[i];
		
	var cubeVbo = new GLVertexBufferObject();
	cubeVbo.create(cubeMesh);
	
	// Create the column (cylinder)
	var cylinderMesh = new Cylinder(32.0, 0.25, 6.0);
	var cylinderVbo = new GLVertexBufferObject();
	cylinderVbo.create(cylinderMesh);
	
	// Create the central stand
	var cubeMeshStand = new Cube(1.0, 1.0, 1.0);
	var cubeStandVbo = new GLVertexBufferObject();
	cubeStandVbo.create(cubeMeshStand);
	
	// Create the central marble
	var sphereMesh = new Sphere(24, 24, 1.0, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.create(sphereMesh);
	
	// Create entities
	var roomEntity = new Entity();
	roomEntity.objectEntity = cubeVbo;
	roomEntity.objectMatrix.translate(0.0, 0.0, 0.0);
	roomEntity.objectMaterial.diffuse.setPoint(0.8, 0.8, 0.8);
	roomEntity.objectMaterial.specular.setPoint(0.0, 0.0, 0.0);
	entity.push(roomEntity);
	
	// 4 column entities
	for (var x = -1; x <= 1; x += 2)
	{
		for (var z = -1; z <= 1; z += 2)
		{
			var columnEntity = new Entity();
			columnEntity.objectEntity = cylinderVbo;
			columnEntity.objectMatrix.translate(x * 3.5, 0.0, z * 3.5);
			columnEntity.objectMatrix.rotate(90.0, 0.0, 0.0);
			columnEntity.objectMaterial.diffuse.setPoint(0.6, 0.6, 0.6);
			columnEntity.objectMaterial.specular.setPoint(0.1, 0.1, 0.1);
			columnEntity.objectMaterial.shininess = 6;
			entity.push(columnEntity);
		}
	}
	
	// Central stand
	var cubeStandEntity = new Entity();
	cubeStandEntity.objectEntity = cubeStandVbo;
	cubeStandEntity.objectMatrix.translate(0.0, -2.0, 0.0);
	cubeStandEntity.objectMatrix.scale(0.5, 1.0, 0.5);
	cubeStandEntity.objectMaterial.diffuse.setPoint(0.8, 0.8, 0.8);
	cubeStandEntity.objectMaterial.specular.setPoint(0.0, 0.0, 0.0);
	entity.push(cubeStandEntity);
	
	// Central marble
	var sphereEntity = new Entity();
	sphereEntity.objectEntity = sphereVbo;
	sphereEntity.objectMatrix.translate(0.0, -0.5, 0.0);
	sphereEntity.objectMatrix.scale(0.5, 0.5, 0.5);
	sphereEntity.objectMaterial.diffuse.setPoint(0.8, 0.4, 0.4);
	sphereEntity.objectMaterial.specular.setPoint(0.4, 0.4, 0.4);
	sphereEntity.objectMaterial.shininess = 32;
	entity.push(sphereEntity);
	
	return entity;
}