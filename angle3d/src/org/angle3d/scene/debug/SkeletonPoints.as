package org.angle3d.scene.debug
{
	import flash.display3D.Context3DCompareMode;

	import org.angle3d.animation.Bone;
	import org.angle3d.animation.Skeleton;
	import org.angle3d.material.MaterialColorFill;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.shape.Cube;

	public class SkeletonPoints extends Node
	{
		private var _size:Number;
		private var _skeleton:Skeleton;

		private var points:Vector.<Geometry>;

		private var material:MaterialColorFill;

		public function SkeletonPoints(name:String, skeleton:Skeleton, size:Number)
		{
			super(name);

			_skeleton = skeleton;
			_size = size;

			material = new MaterialColorFill(0x00ff00);
			material.technique.renderState.applyDepthTest = true;
			material.technique.renderState.depthTest = true;
			material.technique.renderState.compareMode = Context3DCompareMode.ALWAYS;

			points = new Vector.<Geometry>();

			var boneCount:int = _skeleton.numBones;
			for (var i:int = 0; i < boneCount; i++)
			{
				var node:Geometry = new Geometry(_skeleton.boneList[i].name, new Cube(_size, _size, _size));
				node.setMaterial(material);
				this.attachChild(node);
				points[i] = node;
			}
		}

		public function updateGeometry():void
		{
			var boneCount:int = _skeleton.numBones;
			for (var i:int = 0; i < boneCount; i++)
			{
				var bone:Bone = _skeleton.getBoneAt(i);
				var node:Geometry = points[i];
				node.translation = bone.getModelSpacePosition();
			}
		}
	}
}
