package org.angle3d.material.shader;


/**
 * ...
 * @author
 */
class ShaderVariable
{
	private var _name:String;

	private var _location:Int;

	private var _size:Int;

	public function new(name:String, size:Int)
	{
		_name = name;
		_size = size;
		_location = -1;
	}

	public var name(get, set):String;
	private function set_name(value:String):String
	{
		_name = value;
		return _name;
	}

	private function get_name():String
	{
		return _name;
	}

	public var size(get, set):Int;
	private function set_size(value:Int):Int
	{
		_size = value;
		return _size;
	}

	private function get_size():Int
	{
		return _size;
	}

	public var location(get, set):Int;
	private function set_location(location:Int):Int
	{
		_location = location;
	}

	private function get_location():Int
	{
		return _location;
	}
}

