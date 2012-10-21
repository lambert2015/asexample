package org.angle3d.scene.billboard
{

	public class SimpleRect
	{
		public var left:Number;
		public var top:Number;
		public var right:Number;
		public var bottom:Number;

		public function SimpleRect()
		{
		}

		public function setTo(left:Number, right:Number, top:Number, bottom:Number):void
		{
			this.left = left;
			this.right = right;
			this.top = top;
			this.bottom = bottom;
		}

		public function get width():Number
		{
			return right - left;
		}

		public function get height():Number
		{
			return bottom - top;
		}
	}
}
