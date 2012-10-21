package org.angle3d.collision.bin
{

	/**
	 * Bounding Interval Hierarchy.
	 * Based on:
	 *
	 * Instant Ray Tracing: The Bounding Interval Hierarchy
	 * By Carsten Wächter and Alexander Keller
	 */
	public class BIHNode
	{
		private var leftIndex:int;
		private var rightIndex:int;

		private var left:BIHNode;
		private var right:BIHNode;

		private var leftPlane:Number;
		private var rightPlane:Number;
		private var axis:int;

		public function BIHNode(left:int, right:int)
		{
			this.leftIndex=left;
			this.rightIndex=right;
			axis=3; //indicates leaf
		}

		public function getLeftChild():BIHNode
		{
			return left;
		}

		public function setLeftChild(left:BIHNode):void
		{
			this.left=left;
		}

		public function getLeftPlane():Number
		{
			return leftPlane;
		}

		public function setLeftPlane(leftPlane:Number):void
		{
			this.leftPlane=leftPlane;
		}

		public function getRightChild():BIHNode
		{
			return right;
		}

		public function setRightChild(right:BIHNode):void
		{
			this.right=right;
		}

		public function getRightPlane():Number
		{
			return rightPlane;
		}

		public function setRightPlane(rightPlane:Number):void
		{
			this.rightPlane=rightPlane;
		}
	}
}

