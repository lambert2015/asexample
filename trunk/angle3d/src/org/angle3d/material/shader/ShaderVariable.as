package org.angle3d.material.shader
{

	/**
	 * ...
	 * @author
	 */
	public class ShaderVariable
	{
		protected var _name:String;

		protected var _location:int;

		protected var _size:int;

		public function ShaderVariable(name:String, size:int)
		{
			_name=name;
			_size=size;
			_location=-1;
		}

		public function set name(value:String):void
		{
			_name=value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set size(value:int):void
		{
			_size=value;
		}

		public function get size():int
		{
			return _size;
		}

		public function set location(location:int):void
		{
			_location=location;
		}

		public function get location():int
		{
			return _location;
		}
	}
}

