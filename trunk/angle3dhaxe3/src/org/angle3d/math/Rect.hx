package org.angle3d.math;

class Rect
{
	private var mLeft:Float;
	private var mRight:Float;
	private var mTop:Float;
	private var mBottom:Float;

	private var mWidth:Float;
	private var mHeight:Float;

	public function new(left:Float, right:Float, bottom:Float, top:Float)
	{
		mLeft = left;
		mRight = right;
		mBottom = bottom;
		mTop = top;

		_computeWidth();
		_computeHeight();
	}

	public function copyFrom(rect:Rect):Void
	{
		mLeft = rect.left;
		mRight = rect.right;
		mBottom = rect.bottom;
		mTop = rect.top;

		_computeWidth();
		_computeHeight();
	}

	public function setTo(left:Float, right:Float, bottom:Float, top:Float):Void
	{
		mLeft = left;
		mRight = right;
		mBottom = bottom;
		mTop = top;

		_computeWidth();
		_computeHeight();
	}

	public function clone():Rect
	{
		return new Rect(mLeft, mRight, mTop, mRight);
	}

	public var left(get, set):Float;
	public var right(get, set):Float;
	public var top(get, set):Float;
	public var bottom(get, set):Float;
	private function set_left(value:Float):Float
	{
		mLeft = value;

		_computeWidth();
		
		return mLeft;
	}

	private function set_right(value:Float):Float
	{
		mRight = value;

		_computeWidth();
		
		return mRight;
	}

	private function set_top(value:Float):Float
	{
		mTop = value;

		_computeHeight();
		
		return mTop;
	}

	private function set_bottom(value:Float):Float
	{
		mBottom = value;

		_computeHeight();
		
		return mBottom;
	}

	private function _computeWidth():Void
	{
		mWidth = mRight - mLeft;
	}

	private function _computeHeight():Void
	{
		mHeight = mTop - mBottom;
	}

	private function get_left():Float
	{
		return mLeft;
	}

	private function get_right():Float
	{
		return mRight;
	}

	private function get_top():Float
	{
		return mTop;
	}

	private function get_bottom():Float
	{
		return mBottom;
	}

	public var width(get, null):Float;
	public var height(get, null):Float;
	private function get_width():Float
	{
		return mWidth;
	}

	private function get_height():Float
	{
		return mHeight;
	}
}
