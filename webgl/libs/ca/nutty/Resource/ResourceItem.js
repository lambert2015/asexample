// This class stores a single resource item.
// <param name="name">Unique name assigned to this resource.</param>
// <param name="item">Reference to the resource item to assign.</param>
// <param name="uri">URI to download the resource.</param>
function ResourceItem (name, item, uri)
{
	
	// Stores a unique name assigned to this resource.
	this.name = name;

	// Stores a reference to the resource item.
	this.item = item;
	
	// Stores the uri to download this item.
	this.uri = uri;
}