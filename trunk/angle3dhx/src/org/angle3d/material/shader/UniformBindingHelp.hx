package org.angle3d.material.shader;

/**
 * ...
 * @author andy
 */
class UniformBindingHelp 
{
	public var type:String;
	
	public var name:String;
	
	public var bind:Int;

	public function new(type:String,name:String,bind:Int) 
	{
		this.type = type;
		this.name = name;
		this.bind = bind;
	}
	
}