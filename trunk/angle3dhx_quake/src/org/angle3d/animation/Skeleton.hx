package org.angle3d.animation;
import flash.Vector;
import org.angle3d.math.Matrix4f;

/**
 * <code>Skeleton</code> is a convenience class for managing a bone hierarchy.
 * Skeleton updates the world transforms to reflect the current local
 * animated matrixes.
 * 
 * @author Kirill Vainer
 */
class Skeleton 
{
	private var rootBones:Vector<Bone>;
	private var boneList:Vector<Bone>;
	
	/**
     * Contains the skinning matrices, multiplying it by a vertex effected by a bone
     * will cause it to go to the animated position.
     */
    private var skinningMatrixes:Vector<Matrix4f>;

	/**
     * Creates a skeleton from a bone list. 
     * The root bones are found automatically.
     * <p>
     * Note that using this constructor will cause the bones in the list
     * to have their bind pose recomputed based on their local transforms.
     * 
     * @param boneList The list of bones to manage by this Skeleton
     */
	public function new(boneList:Vector<Bone>) 
	{
		this.boneList = boneList;
		
		rootBones = new Vector<Bone>();
		for (i in 0...this.boneList.length)
		{
			var b:Bone = boneList[i];
			if (b.getParent() == null)
			{
				rootBones.push(b);
			}
		}
		
		createSkinningMatrices();
		
		var i:Int = rootBones.length;
		while (--i >= 0)
		{
			var rootBone:Bone = rootBones[i];
			rootBone.update();
			rootBone.setBindingPose();
		}
	}
	
	public function copy(source:Skeleton):Void
	{
		//this.boneList = source.boneList.concat();
		//
		//rootBones = new Vector<Bone>();
		//for (i in 0...this.boneList.length)
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
		//var i:Int = rootBones.length;
		//while (--i >= 0)
		//{
			//var rootBone:Bone = rootBones[i];
			//rootBone.update();
			//rootBone.setBindingPose();
		//}
	}
	
	private function createSkinningMatrices():Void
	{
        skinningMatrixes = new Vector<Matrix4f>(boneList.length,true);
        for (i in 0...skinningMatrixes.length) 
		{
            skinningMatrixes[i] = new Matrix4f();
        }
    }
	
	private function recreateBoneStructure(sourceRoot:Bone):Bone
	{
        var targetRoot:Bone = getBoneByName(sourceRoot.getName());
        var children:Vector<Bone> = sourceRoot.getChildren();
        for (i in 0...children.length)
		{
            var sourceChild:Bone = children[i];
            // find my version of the child
            var targetChild:Bone = getBoneByName(sourceChild.getName());
            targetRoot.addChild(targetChild);
            recreateBoneStructure(sourceChild);
        }

        return targetRoot;
    }
	
	/**
     * Updates world transforms for all bones in this skeleton.
     * Typically called after setting local animation transforms.
     */
	public function updateWorldVectors():Void
	{
		var i:Int = rootBones.length;
		while (--i >= 0)
		{
			rootBones[i].update();
		}
	}
	
	/**
     * Saves the current skeleton state as it's binding pose.
     */
	public function setBindingPose():Void
	{
		var i:Int = rootBones.length;
		while (--i >= 0)
		{
			rootBones[i].setBindingPose();
		}
	}
	
	/**
     * Reset the skeleton to bind pose.
     */
	public function reset():Void
	{
		var i:Int = rootBones.length;
		while (--i >= 0)
		{
			rootBones[i].reset();
		}
	}
	
	/**
     * Reset the skeleton to bind pose and updates the bones
     */
	public function resetAndUpdate():Void
	{
		var i:Int = rootBones.length;
		while (--i >= 0)
		{
			var rootBone:Bone = rootBones[i];
			rootBone.reset();
			rootBone.update();
		}
	}
	
	/**
     * returns the array of all root bones of this skeleton
     * @return 
     */
	public function getRoots():Vector<Bone>
	{
		return rootBones;
	}
	
	/**
     * return a bone for the given index
     * @param index
     * @return 
     */
	public function getBone(index:Int):Bone
	{
		return boneList[index];
	}
	
	/**
     * returns the bone with the given name
     * @param name
     * @return 
     */
	public function getBoneByName(name:String):Bone
	{
		for (i in 0...boneList.length)
		{
			if (boneList[i].getName() == name)
			{
				return boneList[i];
			}
		}
		
		return null;
	}
	
	/**
     * returns the bone index of the given bone
     * @param bone
     * @return 
     */
	public function getBoneIndex(bone:Bone):Int
	{
		return boneList.indexOf(bone);
	}
	
	/**
     * returns the bone index of the bone that has the given name
     * @param name
     * @return 
     */
	public function getBoneIndexByName(name:String):Int
	{
		for (i in 0...boneList.length)
		{
			if (boneList[i].getName() == name)
			{
				return i;
			}
		}
		
		return -1;
	}
	
	/**
     * Compute the skining matrices for each bone of the skeleton that would be used to transform vertices of associated meshes
     * @return 
     */
	public function computeSkinningMatrices():Vector<Matrix4f>
	{
		for (i in 0...boneList.length)
		{
			//boneList[i].getOffsetTransform(skinningMatrixes[i]);
		}
		return skinningMatrixes;
	}
	
	/**
     * returns the number of bones of this skeleton
     * @return 
     */
	public function getBoneCount():Int
	{
		return boneList.length;
	}
}