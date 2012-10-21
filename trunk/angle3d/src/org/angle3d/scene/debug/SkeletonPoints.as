package org.angle3d.scene.debug
{
	import flash.display3D.Context3DCompareMode;

	import org.angle3d.animation.Bone;
	import org.angle3d.animation.Skeleton;
	import org.angle3d.material.MaterialFill;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.shape.Sphere;

	public class SkeletonPoints extends Node
	{
		private var _radius:Number;
		private var _skeleton:Skeleton;

		private var points:Vector.<SphereNode>;

		private var material:MaterialFill;

		public function SkeletonPoints(name:String, skeleton:Skeleton, radius:Number)
		{
			super(name);
			this._skeleton = skeleton;
			this._radius = radius;

			material = new MaterialFill(0x00ff00);
			material.technique.renderState.applyDepthTest = true;
			material.technique.renderState.depthTest = true;
			material.technique.renderState.compareMode = Context3DCompareMode.ALWAYS;

			points = new Vector.<SphereNode>();

			var boneCount:int = _skeleton.numBones;
			for (var i:int = 0; i < boneCount; i++)
			{
				var node:SphereNode = new SphereNode("sphere" + i, radius, 8, 8);
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
				var node:SphereNode = points[i];
				node.setTranslation(bone.getModelSpacePosition());
			}
		}
	}
}
