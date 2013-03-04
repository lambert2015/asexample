package org.angle3d.material.shader;

/**
 * ...
 * @author andy
 */
class UniformBindingHelp
{
	public var shaderType:ShaderType;

	public var name:String;

	public var bindType:Int;

	public function new(shaderType:ShaderType, name:String, bindType:Int)
	{
		this.shaderType = shaderType;
		this.name = name;
		this.bindType = bindType;
	}
}
