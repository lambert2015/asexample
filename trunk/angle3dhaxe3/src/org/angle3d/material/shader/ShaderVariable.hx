package org.angle3d.material.shader
{

	/**
	 * ...
	 * @author
	 */
	class ShaderVariable
	{
		protected var _name:String;

		protected var _location:Int;

		protected var _size:Int;

		public function ShaderVariable(name:String, size:Int)
		{
			_name = name;
			_size = size;
			_location = -1;
		}

		public function set name(value:String):Void
		{
			_name = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set size(value:Int):Void
		{
			_size = value;
		}

		public function get size():Int
		{
			return _size;
		}

		public function set location(location:Int):Void
		{
			_location = location;
		}

		public function get location():Int
		{
			return _location;
		}
	}
}

