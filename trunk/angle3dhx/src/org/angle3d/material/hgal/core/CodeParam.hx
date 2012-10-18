package org.angle3d.material.hgal.core;
import flash.Lib;
import org.angle3d.material.hgal.core.pool.UniformRegPool;
import org.angle3d.material.hgal.core.reg.AttributeReg;
import org.angle3d.material.hgal.core.reg.Reg;
import org.angle3d.material.hgal.core.reg.TempReg;
import org.angle3d.utils.Assert;

/**
 * 函数中的参数
 * vt0.xyz
 * mat[0].xxz
 * mat[va0.x+5].xyz
 * mat[va0.x].xyz
 */
class CodeParam 
{
    public var reg:Reg;
	
	//.(xyz)
	private var _swizzle:Array<String>;
	public var swizzle(__getSwizzle, __setSwizzle):Array<String>;
	
	public var access:Access;
	
	public var texFlag:TexFlag;

	public function new() 
    {
		reg = null;
		access = null;
		texFlag = null;
	}
	
	private function __getSwizzle():Array<String>
	{
		if (Std.is(reg, TempReg) && VarType.needOffset(reg.varType))
		{
			var tempVar:TempReg = Lib.as(reg, TempReg);
			if (_swizzle != null && _swizzle.length > 0)
			{
				//转换属性为真正的值(t_color.xyz -> vt0.yzw)
				return tempVar.getRealSwizzles(_swizzle);
			}
			else
			{
				//没有写属性，自动加上所有属性
				return tempVar.getSwizzles();
			}
		}
		else if(_swizzle == null)
		{
			var list:Array<String> = ["x", "y", "z", "w"];
			if (Std.is(reg, AttributeReg))
			{
				var typeSize:Int = VarType.getLength(reg.varType);
				if (typeSize < 2)
				{
					return list.splice(0, typeSize);
				}
				//else
				//{
					//return list;
				//}
			}
			return null;
		}
		else
		{
			return _swizzle;
		}
	}
	
	private function __setSwizzle(swiz:Array<String>):Array<String>
	{
		_swizzle = swiz;
		return swiz;
	}
	
	public function isTexture():Bool
	{
		return texFlag != null;
	}
	
	public function isRelative():Bool
	{
		return access != null && access.reg != null;
	}
	
	public function setTexFlag(flags:Array<String>):Void
	{
		texFlag = new TexFlag();
		texFlag.parseFlags(flags);
	}
	
	/**
	 * 检查代码是否合法
	 * @return
	 */
	#if debug
	public function checkValid():Void
	{
		Assert.assert(reg != null, "variable不为null,isDigit should be false");
			
		if (_swizzle != null && _swizzle.length > 0)
		{
			Assert.assert(_swizzle.length <= 4, "变量的属性长度最大为4,但是却为" + _swizzle.length);
			
			Assert.assert(_swizzle.length <= reg.size, _swizzle + "的长度超过了变量属性最大长度" + reg.size);
		}
	}
	#end
	
	
	public function toAgal(pool:UniformRegPool):String
	{
		//寄存器名
		var agal:String = "";
		if (VarType.isMat(reg.varType) && access != null && access.reg == null)
		{
			#if debug
			var max:Int = (reg.varType == VarType.TYPE_MAT3) ? 3 : 4;
			Assert.assert(access.offset >= 0 && access.offset < max, "index应该在0和" + max + "之间，但却等于" + access.offset);
			#end
			
			//矩阵跨越多个寄存器，此时取其中一行时就需要重新查找对应的名称
			var registerIndex:Int = reg.index + access.offset;	
			agal = reg.getPrefix() + registerIndex;
		}
		else
		{
			agal = reg.toAgal();
		}
		
		//属性名
		var prop:String = "";
		
		var list:Array<String> = swizzle;
		if (list != null)
		{
			prop = "." + list.join("");
		}
		
		// fs0<2d,....>
		if (texFlag != null)
		{
			return agal + prop + " " + texFlag.toAgal();
		}

		//vt0 + .xyz
		return agal + prop;
	}
}