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
		public static const MAX_BONE_COUNT:int=32;

		//
		public var rootBone:Bone;

		private var mNumBones:int;
		private var mBoneList:Vector.<Bone>;
		private var mBoneMap:Dictionary;

		/**
		 * Contains the skinning matrices, multiplying it by a vertex effected by a bone
		 * will cause it to go to the animated position.
		 */
		private var mSkinningMatrixes:Vector.<Matrix4f>;

		/**
		 * Creates a skeleton from a bone list.
		 * The root bones are found automatically.
		 * <p>
		 * Note that using this constructor will cause the bones in the list
		 * to have their bind pose recomputed based on their local transforms.
		 *
		 * @param boneList The list of bones to manage by this Skeleton
		 */
		public function Skeleton(boneList:Vector.<Bone>)
		{
			this.mBoneList=boneList;
			mNumBones=boneList.length;

			createSkinningMatrices();

			buildBoneTree();
		}

		public function get numBones():int
		{
			return mNumBones;
		}

		/**
		 * 建立骨骼树结构，查找每个骨骼的父类
		 */
		private function buildBoneTree():void
		{
			mBoneMap=new Dictionary();
			for (var i:int=0; i < mNumBones; i++)
			{
				mBoneMap[mBoneList[i].name]=mBoneList[i];
			}

			for (var name:String in mBoneMap)
			{
				var bone:Bone=mBoneMap[name];
				if (bone.parentName == "")
				{
					rootBone=bone;
				}
				else
				{
					var parentBone:Bone=mBoneMap[bone.parentName];
					parentBone.addChild(bone);
				}
			}

			rootBone.update();
			rootBone.setBindingPose();
		}

		public function copy(source:Skeleton):void
		{
			//this.boneList = source.boneList.concat();
			//
			//rootBones = new Vector.<Bone>();
//			var length:int = this.boneList.length;
//			for (var i:int = 0; i < length; i++)
			//{
			//var b:Bone = boneList[i];
			//if (b.getParent() == null)
			//{
			//rootBones.push(b);
			//}
			//}
			//
			//createSkinningMatrices();
			//
			//var i:int = rootBones.length;
			//while (--i >= 0)
			//{
			//var rootBone:Bone = rootBones[i];
			//rootBone.update();
			//rootBone.setBindingPose();
			//}
		}

		private function createSkinningMatrices():void
		{
			mSkinningMatrixes=new Vector.<Matrix4f>(mNumBones, true);
			for (var i:int=0; i < mNumBones; i++)
			{
				mSkinningMatrixes[i]=new Matrix4f();
			}
		}

		/**
		 * Updates world transforms for all bones in this skeleton.
		 * Typically called after setting local animation transforms.
		 */
		public function update():void
		{
			rootBone.update();
		}

		/**
		 * Saves the current skeleton state as it's binding pose.
		 */
		public function setBindingPose():void
		{
			rootBone.setBindingPose();
		}

		/**
		 * Reset the skeleton to bind pose.
		 */
		public function reset():void
		{
			rootBone.reset();
		}

		/**
		 * Reset the skeleton to bind pose and updates the bones
		 */
		public function resetAndUpdate():void
		{
			rootBone.reset();
			rootBone.update();
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
			var bone:Bone=mBoneList[name];
			return mBoneList.indexOf(bone);
		}

		/**
		 * Compute the skining matrices for each bone of the skeleton that
		 * would be used to transform vertices of associated meshes
		 */
		public function computeSkinningMatrices():Vector.<Matrix4f>
		{
			var tempVar:TempVars=TempVars.getTempVars();

			for (var i:int=0; i < mNumBones; i++)
			{
				mBoneList[i].getOffsetTransform(mSkinningMatrixes[i], tempVar.quat1, tempVar.vect1, tempVar.vect2, tempVar.tempMat3);
			}

			tempVar.release();

			return mSkinningMatrixes;
		}
	}
}

