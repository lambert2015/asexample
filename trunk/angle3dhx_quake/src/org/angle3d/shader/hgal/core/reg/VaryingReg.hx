package org.angle3d.shader.hgal.core.reg;
import org.angle3d.shader.ShaderType;
import org.angle3d.shader.hgal.core.VarKind;

/**
 * ...
 * @author andy 
 */

class VaryingReg extends Reg
{
	public function new(type:String,name:String) 
	{
		super(ShaderType.VERTEX, VarKind.KIND_VARYING, type, name);
		
		emitCode = 0x4;
		range = 7;
		flags = RegFlag.REG_READ | RegFlag.REG_WRITE;
	}
	
	override public function getPrefix():String
	{
		return "v";
	}
}