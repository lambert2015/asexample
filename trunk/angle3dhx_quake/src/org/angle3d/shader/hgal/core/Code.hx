package org.angle3d.shader.hgal.core;
import flash.Lib;
import flash.Vector;
import org.angle3d.shader.hgal.core.pool.UniformRegPool;
import org.angle3d.shader.hgal.core.reg.TempReg;
import org.angle3d.shader.hgal.core.reg.Reg;
import org.angle3d.shader.ShaderType;
import org.angle3d.utils.Assert;
import flash.Vector;
/**
 * 一行语句
 * t_dot = dp3(normal.xyz,normal.xyz)
 * 
 * 最终生成的语句类似于
 * dp3 vt0.x vc0.xyz vc0.xyz
 * @author andy 
 */
class Code 
{
	private var _opCode:OpCode;//操作符
	public var opCode(__getOpCode, __setOpcode):OpCode;
	
	/**
	 * 赋值目标变量不能是常数,attribute,texture,uniform,只能是op,oc,varying或者临时变量
	 * varying只有在vertex中能够赋值
	 * 
	 * 目标类型为Mat4时需要特别注意，例如以下情况：
	 * t_mat4 = c_modelProjection  //由于t_mat4占用了4个地址，因此最终生成agal时需要转换为4句
	 * vt0 = vc0
	 * vt1 = vc1
	 * vt2 = vc2
	 * vt3 = vc3
	 * @param	value
	 */
	public var dest:CodeParam;//赋值目标，可能没有
	
	private var _params:Vector<CodeParam>;//函数中的参数

	public var shaderType:String;

	public function new(shaderType:String) 
	{
		this.shaderType = shaderType;
		
		_params = new Vector<CodeParam>();
	}
	
	public function getParams():Vector<CodeParam>
	{
		return _params;
	}
	
	/**
	 * 检查代码是否合法
	 * @return
	 */
	#if debug
	public function checkValid():Void
	{
		//检查使用范围
		if (_opCode.isFragOnly())
		{
			Assert.assert(shaderType == ShaderType.FRAGMENT, _opCode.name + "只能在Fragment中使用");
		}
		
		//检查target对象
		//此code不能有dest
		if (_opCode.isNoDest())
		{
			Assert.assert(dest == null, _opCode.name + "没有赋值对象");
		}
		else
		{
			Assert.assert(dest != null, "Dest不能为null");

			Assert.assert(dest.reg != null, "赋值目标的reg不能是null");
			
			Assert.assert(dest.reg.varKind != VarKind.KIND_UNIFORM, "赋值目标的variable不能是Uniform");
			
			if (shaderType == ShaderType.FRAGMENT)
			{
				Assert.assert(dest.reg.varKind != VarKind.KIND_VARYING, "Fragment中varying变量不能修改，只能读取");
				
				Assert.assert(dest.reg.varKind != VarKind.KIND_TEXTURE, "Fragment中texture变量不能修改，只能读取");
			}
			
			dest.checkValid();
		}
		
		var count:Int = 0;
		if (!_opCode.isNoDest())
		{
			count += 1;
		}
		count += _params.length;
		
		//检查参数数量
		Assert.assert(Std.int(_opCode.numRegister) == count, _opCode.name + "的参数长度和该Code不同");
		
		for (i in 0..._params.length)
		{
			_params[i].checkValid();
		}
	}
	#end
	
	public function addParam(value:CodeParam):Void
	{
		_params.push(value);
	}
	
	public function toAgal(pool:UniformRegPool):String
	{
		if (_opCode == OpCodeManager.getInstance().getCode("mov")) //vt0 = vt1
		{
			var source0:CodeParam = _params[0];
			
			//不准矩阵或者数组直接赋值
			//没有带属性时
			//t_mat = c_mat相当于4个语句
			//if (VarType.isMat(dest.reg.varType) && 
			    //dest.access  == null &&
				//VarType.isMat(source0.reg.varType) && 
			    //source0.access  == null )
			//{
				//#if debug
				//Assert.assert(dest.reg.varType == source0.reg.varType, "target和source0类型不同");
				//#end
				//
				//var d_reg:Int = dest.reg.index;	
				//var s_reg:Int = source0.reg.index;	
				//var d_prex:String = dest.reg.getPrefix();
				//var s_prex:String = source0.reg.getPrefix();
				//
				//var count:Int = dest.reg.varType == VarType.TMAT3 ? 3 : 4;
				//var result:String = "";
				//for (i in 0...count)
				//{
					//result += "mov " + d_prex + (d_reg + i) + " " + s_prex + (s_reg + i);
				//}
				//return result;
			//}
			//else
			//{
				return "mov " + dest.toAgal(pool) + " " + source0.toAgal(pool);
			//}
		}
		else if (_opCode.name == "kil")
		{
			return "kil " + _params[0].toAgal(pool);
		}
		else  //一个或者多个参数
		{
			return _opCode.name + " " + dest.toAgal(pool) + " " + _getParamsAgal(pool);
		}
	}
	
	private function __setOpcode(value:OpCode):OpCode
	{
		//null时代表使用mov
		if (value == null)
		{
			value = OpCodeManager.getInstance().getCode("mov");
		}
		_opCode = value;
		
		return _opCode;
	}
	
	private function __getOpCode():OpCode
	{
		return _opCode;
	}
	
	private function _getParamsAgal(pool:UniformRegPool):String
	{
		var list:Array<String> = [];
		for (i in 0..._params.length)
		{
			list.push(_params[i].toAgal(pool));
		}
		
		return list.join(" ");
	}
	
	
	/**
	 * 获得所有临时变量
	 * @return
	 */
	public function getTempRegs():Vector<TempReg>
	{
		var list:Vector<TempReg> = new Vector<TempReg>();
		if (dest != null && dest.reg != null && Std.is(dest.reg,TempReg))
		{
			list.push(Lib.as(dest.reg, TempReg));
		}
		
		for (i in 0..._params.length)
		{
			var reg:Reg = _params[i].reg;
			if (reg != null && Std.is(reg,TempReg))
			{
				list.push(Lib.as(reg, TempReg));
			}
		}
		
		return list;
	}
	
}