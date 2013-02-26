package org.angle3d.shader;

/**
 * ...
 * @author 
 */
class ShaderVar 
{
	public var name:String;
	
	private var location:Int;
	
	private var size:Int;

	public function new(name:String,size:Int) 
	{
		this.name = name;
		this.size = size;
		location = -1;
	}
	
	public function setSize(size:Int):Void
	{
        this.size = size;
    }

    public function getSize():Int
	{
        return size;
    }
	
	public function setLocation(location:Int):Void
	{
        this.location = location;
    }

    public function getLocation():Int
	{
        return location;
    }
}