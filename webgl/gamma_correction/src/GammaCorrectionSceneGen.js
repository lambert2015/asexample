// This script is responsible for creating the scene entities for the demo.

// Constructor.

function GammaCorrectionSceneGen() {
}

// Function creates the VBO objects used in the scene.

GammaCorrectionSceneGen.Create = function() {
	// Array to store the list of entities in the scene.
	var entity = [];

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
	sphereEntity.objectEntity = sphereVbo;
	sphereEntity.objectMaterial.Specular.setPoint(0.0, 0.0, 0.0);
	sphereEntity.objectMatrix.Translate(0.0, -0.5, 0.0);
	sphereEntity.objectMatrix.Rotate(90.0, 0.0, 0.0);
	entity.push(sphereEntity);

	// Create a cube entity (room)
	var cubeEntity = new Entity();
	cubeEntity.objectEntity = cubeVbo;
	entity.push(cubeEntity);

	// Create rectangle entities (texture compare scene)
	var rectEntity1 = new Entity();
	rectEntity1.objectEntity = rectVbo;
	rectEntity1.objectMatrix.Translate(0.0, -0.5, 0.5);
	entity.push(rectEntity1);

	// Create rectangle entities for calibration testing
	var rectEntity2 = new Entity();
	rectEntity2.objectEntity = rectVbo;
	rectEntity2.objectMatrix.Translate(0.0, 0.4, 0.5);
	rectEntity2.objectMatrix.Scale(1.0, 0.1, 1.0);
	entity.push(rectEntity2);

	// Blacks Test
	var rectEntity3 = new Entity();
	rectEntity3.objectEntity = rectVbo;
	rectEntity3.objectMatrix.Translate(0.0, 0.1, 0.5);
	rectEntity3.objectMatrix.Scale(1.0, 0.1, 1.0);
	entity.push(rectEntity3);

	return entity;
}