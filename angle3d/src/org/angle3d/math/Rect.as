package org.angle3d.math
{

	public class Rect
	{
		private var _left : Number;
		private var _right : Number;
		private var _top : Number;
		private var _bottom : Number;

		private var _width : Number;
		private var _height : Number;

		public function Rect(left : Number, right : Number, bottom : Number, top : Number)
		{
			_left = left;
			_right = right;
			_bottom = bottom;
			_top = top;

			_computeWidth();
			_computeHeight();
		}

		public function copyFrom(rect : Rect) : void
		{
			_left = rect.left;
			_right = rect.right;
			_bottom = rect.bottom;
			_top = rect.top;

			_computeWidth();
			_computeHeight();
		}

		public function setTo(left : Number, right : Number, bottom : Number, top : Number) : void
		{
			_left = left;
			_right = right;
			_bottom = bottom;
			_top = top;

			_computeWidth();
			_computeHeight();
		}

		public function clone() : Rect
		{
			return new Rect(_left, _right, _top, _right);
		}

		public function set left(value : Number) : void
		{
			_left = value;

			_computeWidth();
		}

		public function set right(value : Number) : void
		{
			_right = value;

			_computeWidth();
		}

		public function set top(value : Number) : void
		{
			_top = value;

			_computeHeight();
		}

		public function set bottom(value : Number) : void
		{
			_bottom = value;

			_computeHeight();
		}

		private function _computeWidth() : void
		{
			_width = _right - _left;
		}

		private function _computeHeight() : void
		{
			_height = _top - _bottom;
		}

		public function get left() : Number
		{
			return _left;
		}

		public function get right() : Number
		{
			return _right;
		}

		public function get top() : Number
		{
			return _top;
		}

		public function get bottom() : Number
		{
			return _bottom;
		}

		public function get width() : Number
		{
			return _width;
		}

		public function get height() : Number
		{
			return _height;
		}
	}
}
