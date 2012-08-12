// This script is responsible for creating the scene entities for the demo.
function DepthOfFieldSceneGen ()
{
}



// Function creates the VBO objects used in the scene.

DepthOfFieldSceneGen.create = function ()
{
	// Array to store the list of entities in the scene.
	var entity = [];

	// create the room (box)
	var cubeMesh = new Cube(10.0, 3.0, 10.0);
	// Invert cube normals because we're inside the cube
	for (var i = 0; i < cubeMesh.normals.length; ++i)
		cubeMesh.normals[i] = -cubeMesh.normals[i];
	var cubeVbo = new GLVertexBufferObject();
	cubeVbo.create(cubeMesh);
	
	// create the plane (ruler)
	var rectMesh = new Rectangle(1.0, 1.0);
	var rectVbo = new GLVertexBufferObject();
	rectVbo.create(rectMesh);
	
	// create the sphere
	var sphereMesh = new Sphere(24, 24, 1.0, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.create(sphereMesh);
	
	// create the cyinders
	var cylinderMesh = new Cylinder(32.0, 0.5, 2.0);
	var cylinderVbo = new GLVertexBufferObject();
	cylinderVbo.create(cylinderMesh);
	
	// create entities
	var rulerEntity = new Entity();
	rulerEntity.objectEntity = rectVbo;
	rulerEntity.objectMatrix.translate(0.0, 2.9, 0.0);
	rulerEntity.objectMatrix.rotate(90.0, 90.0, 0.0);
	rulerEntity.objectMatrix.scale(10.0, -1.0, 1.0);
	rulerEntity.objectMaterial.ambient.setPoint(0.2, 0.2, 0.2);
	rulerEntity.objectMaterial.diffuse.setPoint(0.8, 0.8, 0.8);
	rulerEntity.objectMaterial.specular.setPoint(0.0, 0.0, 0.0);
	// Ruler texture is only 124 pixels high. Need to scale texture to fit rectangle.
	// Note: ruler texture is larger than normal in order to support mipmapping.
	rulerEntity.objectMaterial.textureScale.y = 124.0 / 1024.0;
	entity.push(rulerEntity);
	
	var roomEntity = new Entity();
	roomEntity.objectEntity = cubeVbo;
	roomEntity.objectMatrix.translate(0.0, 0.0, 0.0);
	roomEntity.objectMaterial.diffuse.setPoint(0.8, 0.8, 0.8);
	roomEntity.objectMaterial.specular.setPoint(0.0, 0.0, 0.0);
	entity.push(roomEntity);
	
	// DOF Objects
	for (var x = 0; x < 7; ++x)
	{
		var entityInstance = new Entity();
		entityInstance.objectEntity = cylinderVbo;
		entityInstance.objectMatrix.translate((x - 4.0) * 2, -2.0, (x - 4.5) * 2);
		entityInstance.objectMatrix.rotate(90.0, 0.0, 0.0);
		if ( x % 3 == 0 )
			entityInstance.objectMaterial.diffuse.setPoint(((x + 7.0) / 7.0), 0.5, 0.5);
		else if ( x % 3 == 1 )
			entityInstance.objectMaterial.diffuse.setPoint(0.5, ((x + 7.0) / 7.0), 0.5);
		else
			entityInstance.objectMaterial.diffuse.setPoint(0.5, 0.5, ((x + 7.0) / 7.0));
		entityInstance.objectMaterial.specular.setPoint(0.1, 0.1, 0.1);
		entityInstance.objectMaterial.shininess = 6;
		entity.push(entityInstance);
	}
	
	// create one more near the camera
	var entityInstance = new Entity();
	entityInstance.objectEntity = cylinderVbo;
	entityInstance.objectMatrix.translate(-2.0, -2.0, 7.0);
	entityInstance.objectMatrix.rotate(90.0, 0.0, 0.0);
	if ( x % 3 == 0 )
		entityInstance.objectMaterial.diffuse.setPoint(((x + 7.0) / 7.0), 0.5, 0.5);
	else if ( x % 3 == 1 )
		entityInstance.objectMaterial.diffuse.setPoint(0.5, ((x + 7.0) / 7.0), 0.5);
	else
		entityInstance.objectMaterial.diffuse.setPoint(0.5, 0.5, ((x + 7.0) / 7.0));
	entityInstance.objectMaterial.specular.setPoint(0.1, 0.1, 0.1);
	entityInstance.objectMaterial.shininess = 6;
	entity.push(entityInstance);
	
	return entity;
}