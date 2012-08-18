// This script is responsible for creating the scene entities for the demo.

// Constructor.

function RefractionSceneGen() {
}

// Function creates the VBO objects used in the scene.

RefractionSceneGen.Create = function() {
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
	for (var i = 0; i < 10; ++i) {
		var propEntity = new Entity();
		propEntity.objectEntity = sphereVbo;
		propEntity.objectMaterial.Ambient.setPoint(0.1, 0.1, 0.1);
		propEntity.objectMaterial.Diffuse.setPoint(0.8, 0.8, 0.8);
		propEntity.objectMaterial.Specular.setPoint(0.0, 0.0, 0.0);
		var scale = random.RandomFloat(0.25, 1.5);
		if (i == 0) {
			propEntity.objectMatrix.Translate(0.0, 0.0, -2.0);
			scale = 1.0;
		} else
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