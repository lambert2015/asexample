/**
 * @author alteredq / http://alteredqualia.com
 */

THREE.WebGLRenderTargetCube = function(width, height, options) {

	THREE.WebGLRenderTarget.call(this, width, height, options);

	// PX 0, NX 1, PY 2, NY 3, PZ 4, NZ 5
	this.activeCubeFace = 0;
};

THREE.WebGLRenderTargetCube.prototype = Object.create(THREE.WebGLRenderTarget.prototype);
