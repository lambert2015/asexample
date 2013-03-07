package org.angle3d.animation
{

	import flash.utils.Dictionary;

	import org.angle3d.math.Matrix4f;
	import org.angle3d.utils.TempVars;

	/**
	 * Skeleton is a convenience public class for managing a bone hierarchy.
	 * Skeleton updates the world transforms to reflect the current local
	 * animated matrixes.
	 * A Skeleton can only one rootBone
	 *
	 * @author andy
	 */
	public class Skeleton
	{
		/**
		 * 最大骨骼数量
		 * 一个Shader按目前方法最大能支持128/3 = 42个骨骼
		 * 但是要考虑到透视矩阵以及一些其他功能，因此只定义最多32个
		 */
		public static const MAX_BONE_COUNT:int = 32;

		//
		public var rootBones:Vector<Bone>;

		private var mBoneList:Vector<Bone>;
		private var mBoneMap:Dictionary;

		/**
		 * Contains the skinning matrices, multiplying it by a vertex effected by a bone
		 * will cause it to go to the animated position.
		 */
		private var mSkinningMatrixes:Vector<Matrix4f>;

		/**
		 * Creates a skeleton from a bone list.
		 * The root bones are found automatically.
		 * <p>
		 * Note that using this constructor will cause the bones in the list
		 * to have their bind pose recomputed based on their local transforms.
		 *
		 * @param boneList The list of bones to manage by this Skeleton
		 */
		public function Skeleton(boneList:Vector<Bone>)
		{
			this.mBoneList = boneList;
			createSkinningMatrices();
			buildBoneTree();
		}

		public function get numBones():uint
		{
			return mBoneList.length;
		}

		public function get boneList():Vector<Bone>
		{
			return mBoneList;
		}

		/**
		 * 建立骨骼树结构，查找每个骨骼的父类
		 */
		private function buildBoneTree():Void
		{
			mBoneMap = new Dictionary();
			var count:uint = mBoneList.length;
			for (var i:uint = 0; i < count; i++)
			{
				mBoneMap[mBoneList[i].name] = mBoneList[i];
			}

			rootBones = new Vector<Bone>();
			for (var name:String in mBoneMap)
			{
				var bone:Bone = mBoneMap[name];
				if (bone.parentName == null || bone.parentName == "")
				{
					rootBones.push(bone);
				}
				else
				{
					var parentBone:Bone = mBoneMap[bone.parentName];
					parentBone.addChild(bone);
				}
			}

			count = rootBones.length;
			for (i = 0; i < count; i++)
			{
				rootBones[i].update();
				rootBones[i].setBindingPose();
			}
		}

		public function copy(source:Skeleton):Void
		{
//			var sourceList:Vector<Bone> = source.boneList;
//
//			this.mBoneList = new Vector<Bone>();
//			var count:int = sourceList.length;
//			for (var i:int = 0; i < count; i++)
//			{
//				mBoneList[i] = sourceList[i].clone();
//			}
//
//			createSkinningMatrices();
//			buildBoneTree();
		}

		private function createSkinningMatrices():Void
		{
			var count:uint = mBoneList.length;
			mSkinningMatrixes = new Vector<Matrix4f>(count, true);
			for (var i:uint = 0; i < count; i++)
			{
				mSkinningMatrixes[i] = new Matrix4f();
			}
		}

		/**
		 * Updates world transforms for all bones in this skeleton.
		 * Typically called after setting local animation transforms.
		 */
		public function update():Void
		{
			var count:uint = rootBones.length;
			for (var i:uint = 0; i < count; i++)
			{
				rootBones[i].update();
			}
		}

		/**
		 * Saves the current skeleton state as it's binding pose.
		 */
		public function setBindingPose():Void
		{
			var count:uint = rootBones.length;
			for (var i:uint = 0; i < count; i++)
			{
				rootBones[i].setBindingPose();
			}
		}

		/**
		 * Reset the skeleton to bind pose.
		 */
		public function reset():Void
		{
			var count:uint = rootBones.length;
			for (var i:uint = 0; i < count; i++)
			{
				rootBones[i].reset();
			}
		}

		/**
		 * Reset the skeleton to bind pose and updates the bones
		 */
		public function resetAndUpdate():Void
		{
			var count:uint = rootBones.length;
			for (var i:uint = 0; i < count; i++)
			{
				rootBones[i].reset();
				rootBones[i].update();
			}
		}

		/**
		 * return a bone for the given index
		 * @param index
		 * @return
		 */
		public function getBoneAt(index:int):Bone
		{
			return mBoneList[index];
		}

		/**
		 * returns the bone with the given name
		 * @param name
		 * @return
		 */
		public function getBoneByName(name:String):Bone
		{
			return mBoneMap[name];
		}

		/**
		 * returns the bone index of the given bone
		 * @param bone
		 * @return
		 */
		public function getBoneIndex(bone:Bone):int
		{
			return mBoneList.indexOf(bone);
		}

		/**
		 * returns the bone index of the bone that has the given name
		 * @param name
		 * @return
		 */
		public function getBoneIndexByName(name:String):int
		{
			var bone:Bone = mBoneList[name];
			return mBoneList.indexOf(bone);
		}

		/**
		 * Compute the skining matrices for each bone of the skeleton that
		 * would be used to transform vertices of associated meshes
		 */
		public function computeSkinningMatrices():Vector<Matrix4f>
		{
			var tempVar:TempVars = TempVars.getTempVars();

			var count:uint = mBoneList.length;
			for (var i:int = 0; i < count; i++)
			{
				mBoneList[i].getOffsetTransform(mSkinningMatrixes[i], tempVar.quat1, tempVar.vect1, tempVar.vect2, tempVar.tempMat3);
			}

			tempVar.release();

			return mSkinningMatrixes;
		}
	}
}

