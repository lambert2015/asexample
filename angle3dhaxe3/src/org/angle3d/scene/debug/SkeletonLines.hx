package org.angle3d.scene.debug;

import org.angle3d.animation.Bone;
import org.angle3d.animation.Skeleton;
import org.angle3d.math.Vector3f;
import org.angle3d.scene.shape.WireframeLineSet;
import org.angle3d.scene.shape.WireframeShape;

//TODO 优化，不必每次都创建VertexBuffer
class SkeletonLines extends WireframeShape
{
	private var _skeleton:Skeleton;

	public function new(skeleton:Skeleton)
	{
		super();

		_skeleton = skeleton;

		updateGeometry();
	}

	public function updateGeometry(updateIndices:Bool = true):Void
	{
		clearSegment();

		var rootBones:Vector<Bone> = _skeleton.rootBones;
		for (var i:UInt = 0, il:UInt = rootBones.length; i < il; i++)
		{
			buildBoneLines(_skeleton.rootBones[i]);
		}

		build(updateIndices);
	}

	private function buildBoneLines(bone:Bone):Void
	{
		var parentPos:Vector3f = bone.getModelSpacePosition();

		var children:Vector<Bone> = bone.children;
		var size:UInt = children.length;
		for (var i:UInt = 0; i < size; i++)
		{
			var child:Bone = children[i];
			var childPos:Vector3f = child.getModelSpacePosition();
			addSegment(new WireframeLineSet(parentPos.x, parentPos.y, parentPos.z, childPos.x, childPos.y, childPos.z));

			buildBoneLines(child);
		}
	}
}
