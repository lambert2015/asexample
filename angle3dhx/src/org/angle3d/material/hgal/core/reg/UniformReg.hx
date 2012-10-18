package org.angle3d.material.hgal.core.reg;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.hgal.core.VarKind;
import org.angle3d.utils.Assert;

/**
 * ...
 * @author andy 
 */

class UniformReg extends Reg
{
	public function new(shaderType:String,type:String,name:String) 
	{
		super(shaderType, VarKind.KIND_UNIFORM, type, name);
		
		emitCode = 0x1;
		
		range = shaderType == ShaderType.VERTEX ? 127 : 27;
		flags = RegFlag.REG_READ;
		
		//#if debug
		//Assert.assert(type == VarType.TVec4 || type == VarType.TMAT4 || type == VarType.TMAT3, "UniformVar只能使用Vec4,Mat3,Mat4类型");
		//#end
	}

	override public function getPrefix():String
	{
		return shaderType == ShaderType.VERTEX ? "vc" : "fc";
	}
}