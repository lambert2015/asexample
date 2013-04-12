/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 * @author mikael emtinger / http://gomo.se/
 * @author jonobr1 / http://jonobr1.com/
 */

THREE.Mesh = function(geometry, material) {

	THREE.Object3D.call(this);

	this.geometry = geometry;
	this.material = (material !== undefined ) ? material : new THREE.MeshBasicMaterial({
		color : Math.random() * 0xffffff,
		wireframe : true
	});

	if (this.geometry !== undefined) {
		if (this.geometry.boundingSphere === null) {
			this.geometry.computeBoundingSphere();
		}
		this.updateMorphTargets();
	}
};

THREE.Mesh.prototype = Object.create(THREE.Object3D.prototype);

THREE.Mesh.prototype.updateMorphTargets = function() {

	var size = this.geometry.morphTargets.length;
	if (size > 0) {

		this.morphTargetBase = -1;
		this.morphTargetForcedOrder = [];
		this.morphTargetInfluences = [];
		this.morphTargetDictionary = {};

		for (var m = 0; m < size; m++) {
			this.morphTargetInfluences.push(0);
			this.morphTargetDictionary[this.geometry.morphTargets[m].name] = m;
		}
	}
};

THREE.Mesh.prototype.getMorphTargetIndexByName = function(name) {

	if (this.morphTargetDictionary[name] !== undefined) {
		return this.morphTargetDictionary[name];
	}

	console.log("THREE.Mesh.getMorphTargetIndexByName: morph target " + name + " does not exist. Returning 0.");

	return 0;

};

THREE.Mesh.prototype.clone = function(object) {

	if (object === undefined)
		object = new THREE.Mesh(this.geometry, this.material);

	THREE.Object3D.prototype.clone.call(this, object);

	return object;

};
