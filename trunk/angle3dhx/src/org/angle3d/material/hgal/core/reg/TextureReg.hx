package org.angle3d.material.hgal.core.reg;
import org.angle3d.material.hgal.core.VarKind;
import org.angle3d.material.hgal.core.VarType;
import org.angle3d.material.shader.ShaderType;

/**
 * ...
 * @author andy 
 */
class TextureReg extends Reg
{
	public function new(name:String) 
	{
		super(ShaderType.FRAGMENT, VarKind.KIND_TEXTURE, VarType.TYPE_TEXTURE, name);
		
		emitCode = 0x5;
		range = 7;
		flags = RegFlag.REG_READ;
	}
	
	override public function getPrefix():String
	{
		return "fs";
	}
}