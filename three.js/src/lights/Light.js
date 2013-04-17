/**
 * @author mrdoob / http://mrdoob.com/
 * @author alteredq / http://alteredqualia.com/
 */
THREE.LightType = {};
THREE.LightType.Ambient = 1;
THREE.LightType.Point = 2;
THREE.LightType.Spot = 3;
THREE.LightType.Directional = 4;
THREE.LightType.Area = 5;
THREE.LightType.Hemisphere = 6;

THREE.Light = function(hex,type) {

	THREE.Object3D.call(this);

	this.color = new THREE.Color(hex);
	this.type = type;
};

THREE.Light.prototype = Object.create(THREE.Object3D.prototype);

THREE.Light.prototype.clone = function(light) {

	if (light === undefined)
		light = new THREE.Light();

	THREE.Object3D.prototype.clone.call(this, light);

	light.color.copy(this.color);
	light.type = this.type;

	return light;

};
