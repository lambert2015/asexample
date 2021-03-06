package org.angle3d.animation;


import org.angle3d.material.Material;
import org.angle3d.math.Matrix4f;
import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.scene.Geometry;
import org.angle3d.scene.Node;
import org.angle3d.scene.control.AbstractControl;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.SkinnedMesh;
import org.angle3d.scene.mesh.SkinnedSubMesh;
import org.angle3d.scene.mesh.VertexBuffer;
import org.angle3d.utils.TempVars;
import flash.Vector;
/**
 * The Skeleton control deforms a model according to a skeleton,
 * It handles the computation of the deformation matrices and performs
 * the transformations on the mesh
 *
 */
class SkeletonControl extends AbstractControl
{
	/**
	 * The skeleton of the model
	 */
	private var mSkeleton:Skeleton;

	/**
	 * Used to track when a mesh was updated. Meshes are only updated
	 * if they are visible in at least one camera.
	 */
	private var mWasMeshUpdated:Bool;

	private var mMesh:SkinnedMesh;

	private var mMaterial:Material;

	private var mSkinningMatrices:Vector<Float>;
	private var mNumBones:Int;

	private var mGeometry:Geometry;

	/**
	 * Creates a skeleton control.
	 * The list of targets will be acquired automatically when
	 * the control is attached to a node.
	 *
	 * @param skeleton the skeleton
	 */
	public function new(geometry:Geometry, skeleton:Skeleton)
	{
		super();

		mWasMeshUpdated = false;

		mGeometry = geometry;
		mMesh = cast(mGeometry.getMesh(), SkinnedMesh);
		mSkeleton = skeleton;

		mNumBones = skeleton.numBones;
		mSkinningMatrices = new Vector<Float>(Skeleton.MAX_BONE_COUNT * 12);
	}

	public function getSkeleton():Skeleton
	{
		return mSkeleton;
	}

	override private function controlRender(rm:RenderManager, vp:ViewPort):Void
	{
		if (!mWasMeshUpdated)
		{
			//CPU计算骨骼动画
//				resetToBind(); // reset_morph meshes to bind pose
//
//				var offsetMatrices:Vector<Matrix4f> = skeleton.computeSkinningMatrices();
//				var count:Int = mesh.subMeshList.length;
//				for (var i:Int = 0; i < count; i++)
//				{
//					softwareSkinUpdate(mesh.subMeshList[i] as SkinnedSubMesh, offsetMatrices);
//				}

			//GPU 计算骨骼动画
			var offsetMatrices:Vector<Matrix4f> = mSkeleton.computeSkinningMatrices();
			var mat:Matrix4f;
			var i12:Int;
			for (i in 0...mNumBones)
			{
				mat = offsetMatrices[i];

				i12 = i * 12;

				mSkinningMatrices[i12] = mat.m00;
				mSkinningMatrices[i12 + 1] = mat.m01;
				mSkinningMatrices[i12 + 2] = mat.m02;
				mSkinningMatrices[i12 + 3] = mat.m03;

				mSkinningMatrices[i12 + 4] = mat.m10;
				mSkinningMatrices[i12 + 5] = mat.m11;
				mSkinningMatrices[i12 + 6] = mat.m12;
				mSkinningMatrices[i12 + 7] = mat.m13;

				mSkinningMatrices[i12 + 8] = mat.m20;
				mSkinningMatrices[i12 + 9] = mat.m21;
				mSkinningMatrices[i12 + 10] = mat.m22;
				mSkinningMatrices[i12 + 11] = mat.m23;
			}

			mMaterial = mGeometry.getMaterial();
			if (mMaterial != null)
				mMaterial.skinningMatrices = mSkinningMatrices;

			mWasMeshUpdated = true;
		}
	}

	public function getAttachmentsNode(boneName:String):Node
	{
		var b:Bone = mSkeleton.getBoneByName(boneName);
		if (b == null)
		{
			return null;
		}

		var node:Node = b.getAttachmentsNode();
		cast(_spatial,Node).attachChild(node);
		return node;
	}


	override private function controlUpdate(tpf:Float):Void
	{
		mWasMeshUpdated = false;
	}

	//------------------------------CPU计算骨骼动画---------------------------------------------//

	private function resetToBind():Void
	{
		var count:Int = mMesh.subMeshList.length;
		for (i in 0...count)
		{
			var subMesh:SkinnedSubMesh = cast(mMesh.subMeshList[i], SkinnedSubMesh);

			var buffer:VertexBuffer = subMesh.getVertexBuffer(BufferType.BIND_POSE_POSITION);
			var posBuffer:VertexBuffer = subMesh.getVertexBuffer(BufferType.POSITION);

			posBuffer.updateData(buffer.getData());
		}
	}

	/**
	 * Update the mesh according to the given transformation matrices
	 * @param mesh then mesh
	 * @param offsetMatrices the transformation matrices to apply
	 */
	private function softwareSkinUpdate(subMesh:SkinnedSubMesh, offsetMatrices:Vector<Matrix4f>):Void
	{
		var tb:VertexBuffer = subMesh.getVertexBuffer(BufferType.TANGENT);
		if (tb == null)
		{
			//if there are no tangents use the classic skinning
			applySkinning(subMesh, offsetMatrices);
		}
		else
		{
			//if there are tangents use the skinning with tangents
			applySkinningTangents(subMesh, offsetMatrices, tb);
		}
	}

	private function applySkinning(subMesh:SkinnedSubMesh, offsetMatrices:Vector<Matrix4f>):Void
	{
		// NOTE: This code assumes the vertex buffer is in bind pose
		// resetToBind() has been called this frame
		var vb:VertexBuffer = subMesh.getVertexBuffer(BufferType.POSITION);
		var positions:Vector<Float> = vb.getData();

		var nb:VertexBuffer = subMesh.getVertexBuffer(BufferType.NORMAL);
		var normals:Vector<Float> = nb.getData();

		var ib:VertexBuffer = subMesh.getVertexBuffer(BufferType.BONE_INDICES);
		var boneIndices:Vector<Float> = ib.getData();

		var wb:VertexBuffer = subMesh.getVertexBuffer(BufferType.BONE_WEIGHTS);
		var boneWeights:Vector<Float> = wb.getData();

		var vars:TempVars = TempVars.getTempVars();

		var skinPositions:Vector<Float> = new Vector<Float>(positions.length);
		var skinNormals:Vector<Float> = new Vector<Float>(normals.length);

		var skinMat:Matrix4f = new Matrix4f();

		var idxWeights:Int = -1;
		var vertexCount:Int = Std.int(positions.length / 3);
		// apply skinning transform for each effecting bone
		for (i in 0...vertexCount)
		{
			var i3:Int = i * 3;

			var vtx:Float = positions[i3];
			var vty:Float = positions[i3 + 1];
			var vtz:Float = positions[i3 + 2];

			var nmx:Float = normals[i3];
			var nmy:Float = normals[i3 + 1];
			var nmz:Float = normals[i3 + 2];

			var rx:Float = 0, ry:Float = 0, rz:Float = 0, rnx:Float = 0, rny:Float = 0, rnz:Float = 0;

			//两种方式，一种是执行4次矩阵运算
//				for (var w:Int = 0; w < 4; w++)
//				{
//					idxWeights++;
//
//					var weight:Float = boneWeights[idxWeights];
//
//					var matIndex:Int = boneIndices[idxWeights];
//
//					//没有忽略
//					if (matIndex < 0 || weight == 0)
//					{
//						continue;
//					}
//
//					var mat:Matrix4f = offsetMatrices[matIndex];
//
//					rx += (mat.m00 * vtx + mat.m01 * vty + mat.m02 * vtz + mat.m03) * weight;
//					ry += (mat.m10 * vtx + mat.m11 * vty + mat.m12 * vtz + mat.m13) * weight;
//					rz += (mat.m20 * vtx + mat.m21 * vty + mat.m22 * vtz + mat.m23) * weight;
//
//					rnx += (mat.m00 * nmx + mat.m01 * nmy + mat.m02 * nmz) * weight;
//					rny += (mat.m10 * nmx + mat.m11 * nmy + mat.m12 * nmz) * weight;
//					rnz += (mat.m20 * nmx + mat.m21 * nmy + mat.m22 * nmz) * weight;
//				}

			//另外一种是先合并为一个矩阵，再进行矩阵运算，类似于Shader里面的方法
			//应该要快不少
			skinMat.makeZero();
			for (w in 0...4)
			{
				idxWeights++;

				var weight:Float = boneWeights[idxWeights];

				var matIndex:Int = Std.int(boneIndices[idxWeights]);

				//没有忽略
				if (matIndex < 0 || weight == 0)
				{
					continue;
				}

				var mat:Matrix4f = offsetMatrices[matIndex];

				skinMat.m00 += mat.m00 * weight;
				skinMat.m01 += mat.m01 * weight;
				skinMat.m02 += mat.m02 * weight;
				skinMat.m03 += mat.m03 * weight;

				skinMat.m10 += mat.m10 * weight;
				skinMat.m11 += mat.m11 * weight;
				skinMat.m12 += mat.m12 * weight;
				skinMat.m13 += mat.m13 * weight;

				skinMat.m20 += mat.m20 * weight;
				skinMat.m21 += mat.m21 * weight;
				skinMat.m22 += mat.m22 * weight;
				skinMat.m23 += mat.m23 * weight;
			}

			rx = (skinMat.m00 * vtx + skinMat.m01 * vty + skinMat.m02 * vtz + skinMat.m03);
			ry = (skinMat.m10 * vtx + skinMat.m11 * vty + skinMat.m12 * vtz + skinMat.m13);
			rz = (skinMat.m20 * vtx + skinMat.m21 * vty + skinMat.m22 * vtz + skinMat.m23);

			rnx = (skinMat.m00 * nmx + skinMat.m01 * nmy + skinMat.m02 * nmz + skinMat.m03);
			rny = (skinMat.m10 * nmx + skinMat.m11 * nmy + skinMat.m12 * nmz + skinMat.m13);
			rnz = (skinMat.m20 * nmx + skinMat.m21 * nmy + skinMat.m22 * nmz + skinMat.m23);

			skinPositions[i3] = rx;
			skinPositions[i3 + 1] = ry;
			skinPositions[i3 + 2] = rz;

			skinNormals[i3] = rnx;
			skinNormals[i3 + 1] = rny;
			skinNormals[i3 + 2] = rnz;
		}


		vars.release();

		vb.updateData(skinPositions);
		nb.updateData(skinNormals);
	}

	/**
	 * Specific method for skinning with tangents to aVoid cluttering the classic skinning calculation with
	 * null checks that would slow down the process even if tangents don't have to be computed.
	 * Also the iteration has additional indexes since tangent has 4 components instead of 3 for pos and norm
	 * @param maxWeightsPerVert maximum number of weights per vertex
	 * @param mesh the mesh
	 * @param offsetMatrices the offsetMaytrices to apply
	 * @param tb the tangent vertexBuffer
	 */
	private function applySkinningTangents(subMesh:SkinnedSubMesh, offsetMatrices:Vector<Matrix4f>, tb:VertexBuffer):Void
	{
		// NOTE: This code assumes the vertex buffer is in bind pose
		// resetToBind() has been called this frame
		var vb:VertexBuffer = subMesh.getVertexBuffer(BufferType.POSITION);
		var positions:Vector<Float> = vb.getData();

		var nb:VertexBuffer = subMesh.getVertexBuffer(BufferType.NORMAL);
		var normals:Vector<Float> = nb.getData();

		var tangents:Vector<Float> = tb.getData();

		var ib:VertexBuffer = subMesh.getVertexBuffer(BufferType.BONE_INDICES);
		var boneIndices:Vector<Float> = ib.getData();

		var wb:VertexBuffer = subMesh.getVertexBuffer(BufferType.BONE_WEIGHTS);
		var boneWeights:Vector<Float> = wb.getData();

		var idxWeights:Int = -1;

		var vars:TempVars = TempVars.getTempVars();

		var skinPositions:Vector<Float> = new Vector<Float>(positions.length);
		var skinNormals:Vector<Float> = new Vector<Float>(normals.length);
		var skinTangents:Vector<Float> = new Vector<Float>(tangents.length);

		var vertexCount:Int = Std.int(positions.length / 3);
		// iterate vertices and apply skinning transform for each effecting bone
		for (i in 0...vertexCount)
		{
			var i3:Int = i * 3;

			var vtx:Float = positions[i3];
			var vty:Float = positions[i3 + 1];
			var vtz:Float = positions[i3 + 2];

			var nmx:Float = normals[i3];
			var nmy:Float = normals[i3 + 1];
			var nmz:Float = normals[i3 + 2];

			var tnx:Float = tangents[i3];
			var tny:Float = tangents[i3 + 1];
			var tnz:Float = tangents[i3 + 2];

			var rx:Float = 0, ry:Float = 0, rz:Float = 0, rnx:Float = 0, rny:Float = 0, rnz:Float = 0, rtx:Float = 0, rty:Float = 0, rtz:Float = 0;

			for (w in 0...4)
			{
				idxWeights++;

				var weight:Float = boneWeights[idxWeights];

				var matIndex:Int = Std.int(boneIndices[idxWeights]);
				//没有忽略
				if (matIndex < 0 || weight == 0)
				{
					continue;
				}

				var mat:Matrix4f = offsetMatrices[matIndex];

				rx += (mat.m00 * vtx + mat.m01 * vty + mat.m02 * vtz + mat.m03) * weight;
				ry += (mat.m10 * vtx + mat.m11 * vty + mat.m12 * vtz + mat.m13) * weight;
				rz += (mat.m20 * vtx + mat.m21 * vty + mat.m22 * vtz + mat.m23) * weight;

				rnx += (mat.m00 * nmx + mat.m01 * nmy + mat.m02 * nmz) * weight;
				rny += (mat.m10 * nmx + mat.m11 * nmy + mat.m12 * nmz) * weight;
				rnz += (mat.m20 * nmx + mat.m21 * nmy + mat.m22 * nmz) * weight;

				rtx += (mat.m00 * tnx + mat.m01 * tny + mat.m02 * tnz) * weight;
				rty += (mat.m10 * tnx + mat.m11 * tny + mat.m12 * tnz) * weight;
				rtz += (mat.m20 * tnx + mat.m21 * tny + mat.m22 * tnz) * weight;
			}

			skinPositions[i3] = rx;
			skinPositions[i3 + 1] = ry;
			skinPositions[i3 + 2] = rz;

			skinNormals[i3] = rnx;
			skinNormals[i3 + 1] = rny;
			skinNormals[i3 + 2] = rnz;

			skinTangents[i3] = rtx;
			skinTangents[i3 + 2] = rty;
			skinTangents[i3 + 2] = rtz;
		}


		vars.release();

		vb.updateData(skinPositions);
		nb.updateData(skinNormals);
		tb.updateData(skinTangents);
	}

}

