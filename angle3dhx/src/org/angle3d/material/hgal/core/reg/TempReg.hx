package org.angle3d.material.hgal.core.reg;
import flash.Vector;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.material.hgal.core.VarKind;
import org.angle3d.material.hgal.core.VarType;
import org.angle3d.utils.Assert;

/**
 * 临时变量
 * @author andy 
 */
class TempReg extends Reg
{
	/**
	 * 寄存器中的偏移量(0-3)
	 */
	public var offset:Int;

	public function new(shaderType:String,type:String,name:String) 
	{
		super(shaderType, VarKind.KIND_TEMP, type, name);
		
		emitCode = 0x2;
		range = 7;
		flags = RegFlag.REG_WRITE | RegFlag.REG_READ;
		
		offset = 0;
		
		#if debug
		Assert.assert(type != VarType.TYPE_TEXTURE, "Texture类型不能用于TempVar");
		#end
	}
	
	override public function getPrefix():String
	{
		return shaderType == ShaderType.VERTEX ? "vt" : "ft";
	}
	
	/**
	 * 能包含的所有swizzle
	 * @return
	 */
	public function getSwizzles():Array<String>
	{
		return ["x", "y", "z", "w"].slice(offset, offset + size);
	}
	
	/**
	 * 真正的swizzle
	 * @param	list
	 * @return
	 */
	public function getRealSwizzles(list:Array<String>):Array<String>
	{
		var arr:Array<String> = ["x", "y", "z", "w"];
		
		var newPropss:Array<String> = [];
		for (i in 0...list.length)
		{
			//真正的位置是原来的位置加上偏移位置
			var index:Int = untyped arr.indexOf(list[i]) + offset;
			newPropss.push(arr[index]);
		}
		
		return newPropss;
	}
}