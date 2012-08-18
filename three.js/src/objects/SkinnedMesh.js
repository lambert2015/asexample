/**
 * @author mikael emtinger / http://gomo.se/
 * @author alteredq / http://alteredqualia.com/
 */

THREE.SkinnedMesh = function(geometry, material, useVertexTexture) {

	THREE.Mesh.call(this, geometry, material);

	//

	this.useVertexTexture = useVertexTexture !== undefined ? useVertexTexture : true;

	// init bones

	this.identityMatrix = new THREE.Matrix4();

	this.bones = [];
	this.boneMatrices = [];

	var b, bone, gbone, p, q, s;

	if (this.geometry.bones !== undefined) {

		for ( b = 0; b < this.geometry.bones.length; b++) {

			gbone = this.geometry.bones[b];

			p = gbone.pos;
			q = gbone.rotq;
			s = gbone.scl;

			bone = this.addBone();

			bone.name = gbone.name;
			bone.position.set(p[0], p[1], p[2]);
			bone.quaternion.set(q[0], q[1], q[2], q[3]);
			bone.useQuaternion = true;

			if (s !== undefined) {

				bone.scale.set(s[0], s[1], s[2]);

			} else {

				bone.scale.set(1, 1, 1);

			}

		}

		for ( b = 0; b < this.bones.length; b++) {

			gbone = this.geometry.bones[b];
			bone = this.bones[b];

			if (gbone.parent === -1) {

				this.add(bone);

			} else {

				this.bones[gbone.parent].add(bone);

			}

		}

		//

		var nBones = this.bones.length;

		if (this.useVertexTexture) {

			// layout (1 matrix = 4 pixels)
			//	RGBA RGBA RGBA RGBA (=> column1, column2, column3, column4)
			//  with  8x8  pixel texture max   16 bones  (8 * 8  / 4)
			//  	 16x16 pixel texture max   64 bones (16 * 16 / 4)
			//  	 32x32 pixel texture max  256 bones (32 * 32 / 4)
			//  	 64x64 pixel texture max 1024 bones (64 * 64 / 4)

			var size;

			if (nBones > 256)
				size = 64;
			else if (nBones > 64)
				size = 32;
			else if (nBones > 16)
				size = 16;
			else
				size = 8;

			this.boneTextureWidth = size;
			this.boneTextureHeight = size;

			this.boneMatrices = new Float32Array(this.boneTextureWidth * this.boneTextureHeight * 4);
			// 4 floats per RGBA pixel
			this.boneTexture = new THREE.DataTexture(this.boneMatrices, this.boneTextureWidth, this.boneTextureHeight, THREE.RGBAFormat, THREE.FloatType);
			this.boneTexture.minFilter = THREE.NearestFilter;
			this.boneTexture.magFilter = THREE.NearestFilter;
			this.boneTexture.generateMipmaps = false;
			this.boneTexture.flipY = false;

		} else {

			this.boneMatrices = new Float32Array(16 * nBones);

		}

		this.pose();

	}

};

THREE.SkinnedMesh.prototype = Object.create(THREE.Mesh.prototype);

THREE.SkinnedMesh.prototype.addBone = function(bone) {

	if (bone === undefined) {

		bone = new THREE.Bone(this);

	}

	this.bones.push(bone);

	return bone;

};

THREE.SkinnedMesh.prototype.updateMatrixWorld = function(force) {

	this.matrixAutoUpdate && this.updateMatrix();

	// update matrixWorld

	if (this.matrixWorldNeedsUpdate || force) {

		if (this.parent) {

			this.matrixWorld.multiply(this.parent.matrixWorld, this.matrix);

		} else {

			this.matrixWorld.copy(this.matrix);

		}

		this.matrixWorldNeedsUpdate = false;

		force = true;

	}

	// update children

	for (var i = 0, l = this.children.length; i < l; i++) {

		var child = this.children[i];

		if ( child instanceof THREE.Bone) {

			child.update(this.identityMatrix, false);

		} else {

			child.updateMatrixWorld(true);

		}

	}

	// flatten bone matrices to array

	var b, bl = this.bones.length, ba = this.bones, bm = this.boneMatrices;

	for ( b = 0; b < bl; b++) {

		ba[b].skinMatrix.flattenToArrayOffset(bm, b * 16);

	}

	if (this.useVertexTexture) {

		this.boneTexture.needsUpdate = true;

	}

};

/*
 * Pose
 */

THREE.SkinnedMesh.prototype.pose = function() {

	this.updateMatrixWorld(true);

	var bim, bone, boneInverses = [];

	for (var b = 0; b < this.bones.length; b++) {

		bone = this.bones[b];

		var inverseMatrix = new THREE.Matrix4();
		inverseMatrix.getInverse(bone.skinMatrix);

		boneInverses.push(inverseMatrix);

		bone.skinMatrix.flattenToArrayOffset(this.boneMatrices, b * 16);

	}

	// project vertices to local

	if (this.geometry.skinVerticesA === undefined) {

		this.geometry.skinVerticesA = [];
		this.geometry.skinVerticesB = [];

		var orgVertex, vertex;

		for (var i = 0; i < this.geometry.skinIndices.length; i++) {

			orgVertex = this.geometry.vertices[i];

			var indexA = this.geometry.skinIndices[i].x;
			var indexB = this.geometry.skinIndices[i].y;

			vertex = new THREE.Vector3(orgVertex.x, orgVertex.y, orgVertex.z);
			this.geometry.skinVerticesA.push(boneInverses[indexA].multiplyVector3(vertex));

			vertex = new THREE.Vector3(orgVertex.x, orgVertex.y, orgVertex.z);
			this.geometry.skinVerticesB.push(boneInverses[indexB].multiplyVector3(vertex));

			// todo: add more influences

			// normalize weights

			if (this.geometry.skinWeights[i].x + this.geometry.skinWeights[i].y !== 1) {

				var len = (1.0 - (this.geometry.skinWeights[i].x + this.geometry.skinWeights[i].y ) ) * 0.5;
				this.geometry.skinWeights[i].x += len;
				this.geometry.skinWeights[i].y += len;

			}

		}

	}

};
