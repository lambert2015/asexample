package org.angle3d.material.hgal.core.reg;
import org.angle3d.material.hgal.core.VarKind;
import org.angle3d.material.hgal.core.VarType;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.utils.Assert;

/**
 * ...
 * @author andy 
 */
class AttributeReg extends Reg
{

	public function new(type:String,name:String) 
	{
		super(ShaderType.VERTEX, VarKind.KIND_ATTRIBUTE, type, name);
		
		emitCode = 0x0;
		range = 7;
		flags = RegFlag.REG_READ;
	}
	
	override public function getPrefix():String
	{
		return "va";
	}
}