// <summary>
// This class stores a single resource item.
// </summary>


// <summary>
// Constructor.
// </summary>
// <param name="name">Unique name assigned to this resource.</param>
// <param name="item">Reference to the resource item to assign.</param>
// <param name="uri">URI to download the resource.</param>
function ResourceItem (name, item, uri)
{
	// <summary>
	// Stores a unique name assigned to this resource.
	// </summary>
	this.Name = name;


	// <summary>
	// Stores a reference to the resource item.
	// </summary>
	this.Item = item;
	
	
	// <summary>
	// Stores the uri to download this item.
	// </summary>
	this.Uri = uri;
}