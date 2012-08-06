// <summary>
// An entity is an abstract object such as a mesh, light, or camera.
// Each entity points to a shared resource, with each entity containing specific
// transformation properties and an optional material associated with it.
// </summary>


// <summary>
// Constructor.
// </summary>
function Entity (entity)
{
	// <summary>
	// Material assigned to this object.
	// </summary>
	this.ObjectMaterial = (entity != null) ? new Material(entity.ObjectMaterial) : new Material();


	// <summary>
	// Transformation matrix assigned to this object.
	// (Translation, Rotation, and Scale)
	// </summary>
	this.ObjectMatrix = new Matrix();
	
	
	// <summary>
	// Reference to the object.
	// </summary>
	this.ObjectEntity = (entity != null) ? entity.ObjectEntity : null;
}


// <summary>
// Creates a new entity using the specified object entity.
// </summary>
Entity.Create = function (objectEntity)
{
	var entity = new Entity();
	entity.ObjectEntity = objectEntity;
	
	return entity;
}