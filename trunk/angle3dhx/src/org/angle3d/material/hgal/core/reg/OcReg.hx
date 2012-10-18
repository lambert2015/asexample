package org.angle3d.material.hgal.core.reg;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.hgal.core.VarKind;
import org.angle3d.material.hgal.core.VarType;

/**
 * output color
 * @author andy 
 */
class OcReg extends Reg
{
	public function new() 
	{
		super(ShaderType.FRAGMENT, VarKind.KIND_SPECIAL, VarType.TYPE_VEC4, "oc");
		
		index = 0;
		emitCode = 0x3;
		range = 0;
		flags = RegFlag.REG_WRITE;
	}
	
	override public function toAgal():String
	{
		return "oc";
	}
}