package org.angle3d.scene.debug
{
	import org.angle3d.animation.Bone;
	import org.angle3d.animation.Skeleton;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.shape.WireframeLineSet;
	import org.angle3d.scene.shape.WireframeShape;

	//TODO 优化，不必每次都创建VertexBuffer
	public class SkeletonLines extends WireframeShape
	{
		private var _skeleton:Skeleton;

		public function SkeletonLines(skeleton:Skeleton)
		{
			super();

			_skeleton = skeleton;

			updateGeometry();
		}

		public function updateGeometry(updateIndices:Boolean = true):void
		{
			clearSegment();

			writeBoneLine(_skeleton.rootBone);

			build(updateIndices);
		}

		private function writeBoneLine(bone:Bone):void
		{
			var parentPos:Vector3f = bone.getModelSpacePosition();

			var children:Vector.<Bone> = bone.children;
			var size:int = children.length;

			if (size > 0)
			{
				for (var i:int = 0; i < size; i++)
				{
					var child:Bone = children[i];
					var childPos:Vector3f = child.getModelSpacePosition();
					addSegment(new WireframeLineSet(parentPos.x, parentPos.y, parentPos.z, childPos.x, childPos.y, childPos.z));

					writeBoneLine(child);
				}
			}
		}
	}
}
