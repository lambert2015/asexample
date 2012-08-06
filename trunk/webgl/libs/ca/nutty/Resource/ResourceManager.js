// <summary>
// This class provides storage of ResourceItem objects.
// </summary>


// <summary>
// Constructor.
// </summary>
function ResourceManager ()
{
	// <summary>
	// Store a collection of ResourceItem objects.
	// </summary>
	this.Item = new Array();
}


// <summary>
// Add an item to the list.
// </summary>
// <param name="item">Item to add.</param>
ResourceManager.prototype.Add = function (item)
{
	this.Item.push(item);
}


// <summary>
// Finds the resource with the specified name.
// </summary>
// <param name="name">Name of the resource item to find.</param>
// <returns>Reference to the resource item if found, otherwise 0.</returns>
ResourceManager.prototype.Find = function (name)
{
	for (var i = 0; i < this.Item.length; ++i)
	{
		if ( this.Item[i].Name == name )
			return this.Item[i];
	}
	return null;
}