package org.angle3d.math
{

	public class Rect
	{
		private var mLeft:Number;
		private var mRight:Number;
		private var mTop:Number;
		private var mBottom:Number;

		private var mWidth:Number;
		private var mHeight:Number;

		public function Rect(left:Number, right:Number, bottom:Number, top:Number)
		{
			mLeft=left;
			mRight=right;
			mBottom=bottom;
			mTop=top;

			_computeWidth();
			_computeHeight();
		}

		public function copyFrom(rect:Rect):void
		{
			mLeft=rect.left;
			mRight=rect.right;
			mBottom=rect.bottom;
			mTop=rect.top;

			_computeWidth();
			_computeHeight();
		}

		public function setTo(left:Number, right:Number, bottom:Number, top:Number):void
		{
			mLeft=left;
			mRight=right;
			mBottom=bottom;
			mTop=top;

			_computeWidth();
			_computeHeight();
		}

		public function clone():Rect
		{
			return new Rect(mLeft, mRight, mTop, mRight);
		}

		public function set left(value:Number):void
		{
			mLeft=value;

			_computeWidth();
		}

		public function set right(value:Number):void
		{
			mRight=value;

			_computeWidth();
		}

		public function set top(value:Number):void
		{
			mTop=value;

			_computeHeight();
		}

		public function set bottom(value:Number):void
		{
			mBottom=value;

			_computeHeight();
		}

		private function _computeWidth():void
		{
			mWidth=mRight - mLeft;
		}

		private function _computeHeight():void
		{
			mHeight=mTop - mBottom;
		}

		public function get left():Number
		{
			return mLeft;
		}

		public function get right():Number
		{
			return mRight;
		}

		public function get top():Number
		{
			return mTop;
		}

		public function get bottom():Number
		{
			return mBottom;
		}

		public function get width():Number
		{
			return mWidth;
		}

		public function get height():Number
		{
			return mHeight;
		}
	}
}
