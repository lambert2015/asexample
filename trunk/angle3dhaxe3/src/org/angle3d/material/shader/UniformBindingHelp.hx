package org.angle3d.material.shader;

/**
 * ...
 * @author andy
 */
class UniformBindingHelp
{
	public var shaderType:String;

	public var name:String;

	public var bindType:Int;

	public function new(shaderType:String, name:String, bindType:Int)
	{
		this.shaderType = shaderType;
		this.name = name;
		this.bindType = bindType;
	}
}
