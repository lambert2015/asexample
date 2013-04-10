THREE.RenderInfo = function() {

	this.memory = {
		programs : 0,
		geometries : 0,
		textures : 0
	};

	this.render = {
		calls : 0,
		vertices : 0,
		faces : 0,
		points : 0
	};
}