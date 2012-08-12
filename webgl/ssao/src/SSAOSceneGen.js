// This script is responsible for creating the scene entities for the demo.
function SSAOSceneGen ()
{
}

// Function creates the VBO objects used in the scene.
SSAOSceneGen.create = function ()
{
	// Array to store the list of entities in the scene.
	var entity = [];

	// create scene content
	var sphereMesh = new Sphere(32, 32, 1.0, 0.0);
	var sphereVbo = new GLVertexBufferObject();
	sphereVbo.create(sphereMesh);
	
	var cubeMesh = new Cube(1.0, 1.0, 1.0);
	// Invert cube normals because we're inside the cube
	for (var i = 0; i < cubeMesh.normals.length; ++i)
		cubeMesh.normals[i] = -cubeMesh.normals[i];
	var cubeVbo = new GLVertexBufferObject();
	cubeVbo.create(cubeMesh);
	
	// create torus knot 1
	var torusKnotMesh = new TorusKnot(2, 3, 64, 64, 0.1, 0.5);
	var torusKnotVbo = new GLVertexBufferObject();
	torusKnotVbo.create(torusKnotMesh);
	
	// create torus knot 2
	var torusKnotMesh2 = new TorusKnot(3, 8, 64, 64, 0.1, 0.5);
	var torusKnotVbo2 = new GLVertexBufferObject();
	torusKnotVbo2.create(torusKnotMesh2);
	
	
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
				sphereEntity.objectEntity = sphereVbo;
				sphereEntity.objectMaterial.ambient.setPoint(0.4, 0.4, 0.4);
				sphereEntity.objectMaterial.specular.setPoint(0.0, 0.0, 0.0);
				sphereEntity.objectMatrix.translate(x * spread - halfCount, y * ySpread, z * spread - halfCount);
				sphereEntity.objectMatrix.scale(scale, scale, scale);
				entity.push(sphereEntity);
			}
		}
		--current;
		if ( current == 0 )
			current = 1;
		halfCount = (current - 1.0) * 0.5 * spread;
	}
	
	// create a cube entity (room)
	var cubeEntity = new Entity();
	cubeEntity.objectEntity = cubeVbo;
	cubeEntity.objectMatrix.translate(0.0, 1.7, 0.0);
	cubeEntity.objectMatrix.scale(4.0, 2.0, 4.0);
	entity.push(cubeEntity);
	
	// create a torus knot entity
	var torusKnotEntity = new Entity();
	torusKnotEntity.objectEntity = torusKnotVbo;
	torusKnotEntity.objectMatrix.translate(0.0, 1.5, 1.5);
	torusKnotEntity.objectMatrix.scale(1.0, 1.0, 1.0);
	torusKnotEntity.objectMaterial.ambient.setPoint(0.4, 0.4, 0.4);
	entity.push(torusKnotEntity);
	
	// create a torus knot entity
	var torusKnotEntity2 = new Entity();
	torusKnotEntity2.objectEntity = torusKnotVbo2;
	torusKnotEntity2.objectMatrix.translate(0.0, 1.5, -1.5);
	torusKnotEntity2.objectMatrix.scale(1.0, 1.0, 1.0);
	torusKnotEntity2.objectMaterial.ambient.setPoint(0.4, 0.4, 0.4);
	entity.push(torusKnotEntity2);
	
	return entity;
}