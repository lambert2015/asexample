// This class provides storage of ResourceItem objects.
function ResourceManager() {
	// Store a collection of ResourceItem objects.
	this.items = [];
}

// Add an item to the list.
// <param name="item">Item to add.</param>
ResourceManager.prototype.add = function(item) {
	this.items.push(item);
}
// Finds the resource with the specified name.
// <param name="name">Name of the resource item to find.</param>
// <returns>Reference to the resource item if found, otherwise 0.</returns>
ResourceManager.prototype.find = function(name) {
	for (var i = 0; i < this.items.length; ++i) {
		if (this.items[i].name == name)
			return this.items[i];
	}
	return null;
}