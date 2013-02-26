package org.angle3d.shader.hgal.core;

/**
 * 自定义OpCode,最终编译时会转换为原生OpCode
 * @author andy
 */

class CustomOpCode 
{
	public var name:String;
	public var numRegister : UInt;

	public function new(name:String, numRegister:UInt)
	{
		this.name = name;
		this.numRegister = numRegister;
	}
	
}