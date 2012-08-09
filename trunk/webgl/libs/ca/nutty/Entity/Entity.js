
// An entity is an abstract object such as a mesh, light, or camera.
// Each entity points to a shared resource, with each entity containing specific
// transformation properties and an optional material associated with it.




// Constructor.

function Entity (entity)
{
	
	// Material assigned to this object.
	
	this.objectMaterial = (entity != null) ? new Material(entity.objectMaterial) : new Material();


	
	// Transformation matrix assigned to this object.
	// (Translation, Rotation, and Scale)
	
	this.objectMatrix = new Matrix();
	
	
	
	// Reference to the object.
	
	this.objectEntity = (entity != null) ? entity.objectEntity : null;
}



// Creates a new entity using the specified object entity.

Entity.create = function (objectEntity)
{
	var entity = new Entity();
	entity.objectEntity = objectEntity;
	
	return entity;
}