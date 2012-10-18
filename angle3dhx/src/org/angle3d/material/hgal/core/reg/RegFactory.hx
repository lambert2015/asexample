package org.angle3d.material.hgal.core.reg;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.hgal.core.VarKind;
import org.angle3d.utils.Assert;

class RegFactory 
{
	/**
	 * 
	 * @param	shaderType
	 * @param	name
	 * @param	varKind
	 * @param	varType 类型 varKind为Texture可不写
	 * @return
	 */
	public static function create(shaderType:String, name:String, varKind:String, varType:String = null) : Reg
	{
		switch(varKind)
		{
			case VarKind.KIND_ATTRIBUTE:
				return new AttributeReg(varType, name);
			case VarKind.KIND_TEXTURE:
				return new TextureReg(name);
			case VarKind.KIND_TEMP:
				return new TempReg(shaderType, varType, name);
			case VarKind.KIND_UNIFORM:
				return new UniformReg(shaderType, varType, name);
			case VarKind.KIND_VARYING:
				return new VaryingReg(varType, name);
		}
		#if debug
			Assert.assert(false, varKind + "不是已知类型");
		#end
		return null;
	}
}