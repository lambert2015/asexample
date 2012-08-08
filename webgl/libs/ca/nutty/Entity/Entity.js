
// An entity is an abstract object such as a mesh, light, or camera.
// Each entity points to a shared resource, with each entity containing specific
// transformation properties and an optional material associated with it.




// Constructor.

function Entity (entity)
{
	
	// Material assigned to this object.
	
	this.ObjectMaterial = (entity != null) ? new Material(entity.ObjectMaterial) : new Material();


	
	// Transformation matrix assigned to this object.
	// (Translation, Rotation, and Scale)
	
	this.ObjectMatrix = new Matrix();
	
	
	
	// Reference to the object.
	
	this.ObjectEntity = (entity != null) ? entity.ObjectEntity : null;
}



// Creates a new entity using the specified object entity.

Entity.Create = function (objectEntity)
{
	var entity = new Entity();
	entity.ObjectEntity = objectEntity;
	
	return entity;
}