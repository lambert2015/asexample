package org.angle3d.material.sgsl.pool;

import flash.Vector;
import org.angle3d.material.sgsl.node.reg.RegNode;
import org.angle3d.material.sgsl.node.reg.UniformReg;
import org.angle3d.material.shader.ShaderProfile;
import org.angle3d.material.shader.ShaderType;
import org.angle3d.utils.Assert;
using org.angle3d.utils.ArrayUtil;
/**
 * 目前只接受vec4,mat3,mat4和对应的数组类型
 * 常量寄存器池
 * 首先需要收集所有的常数，然后才可以锁定其他类型的变量
 * @author andy
 */
class UniformRegPool extends RegPool
{
	private var _pool:Vector<Int>;

	private var _constants:Array<Float>;

	private var shaderType:ShaderType;

	public function new(profile:ShaderProfile, shaderType:ShaderType)
	{
		this.shaderType = shaderType;

		super(profile);

		_pool = new Vector<Int>(mRegLimit);

		_constants = new Array<Float>();
	}

	override private function getRegLimit():Int
	{
		if (shaderType == ShaderType.VERTEX)
		{
			#if flash11_8
			if (mProfile == ShaderProfile.BASELINE_EXTENDED)
			{
				return 250;
			}
			#end
			
			{
				return 128;
			}
		}
		else
		{
			#if flash11_8
			if (mProfile == ShaderProfile.BASELINE_EXTENDED)
			{
				return 64;
			}
			#end
			
			{
				return 28;
			}
		}
	}

	/**
	 * 一次性注册所有Uniform
	 */
	override public function build():Void
	{
		//常量总是放在最前面
		registerConstants();

		super.build();
	}

	/**
	 * 在遍历主函数时主动添加常量到UniformPool中
	 * 添加常量
	 * @param	value
	 */
	public function addConstant(value:Float):Void
	{
		if (!_constants.contain(value))
		{
			_constants.push(value);
		}
	}

	public function getConstantIndex(value:Float):Int
	{
		var index:Int = _constants.indexOf(value);
		return Std.int(index / 4);
	}

	public function getConstantMask(value:Float):String
	{
		var index:Int = _constants.indexOf(value);
		var register:Int = Std.int(index / 4);
		var order:Int = index - register * 4;
		var str:String = "xyzw";
		return str.substr(order, 1);
	}

	/**
	 * 返回常量数组，每4个分为一组,不够的补齐
	 * @return
	 */
	public function getConstants():Array<Array<Float>>
	{
		var cLength:Int = _constants.length;
		if (cLength == 0)
		{
			return null;
		}

		var count:Int = Math.ceil(cLength / 4);
		var result:Array<Array<Float>> = new Array<Array<Float>>();
		for (i in 0...count)
		{
			var list:Array<Float> = new Array<Float>();
			for (j in 0...4)
			{
				if (i * 4 + j < cLength)
				{
					list[j] = _constants[j];
				}
				else //不足的部分用0填充
				{
					list[j] = 0.0;
				}
			}
			result[i] = list;
		}

		return result;
	}

	/**
	 * 锁定常量占用的寄存器
	 */
	private function registerConstants():Void
	{
		//clear pool
		for (i in 0...mRegLimit)
		{
			_pool[i] = 0;
		}

		var cLength:Int = _constants.length;
		if (cLength > 0)
		{
			var count:Int = Math.ceil(cLength / 4);
			for (i in 0...count)
			{
				_pool[i] = 1;
			}
		}
	}

	override public function clear():Void
	{
		super.clear();

		for (i in 0...mRegLimit)
		{
			_pool[i] = 0;
		}

		_constants = [];
	}

	/**
	 * 设置value寄存器位置
	 * @param value
	 */
	override public function register(node:RegNode):Void
	{
		var uniformReg:UniformReg = cast(node, UniformReg);

		Assert.assert(uniformReg != null && !uniformReg.registered, uniformReg.name + "不能注册多次");

		var size:Int = Std.int(uniformReg.size / 4);
		for (i in 0...mRegLimit)
		{
			if (_pool[i] == 0)
			{
				uniformReg.index = i;
				for (j in 0...size)
				{
					_pool[i + j] = 1;
				}
				return;
			}
		}

		Assert.assert(false, "未能找到下一个空闲位置，寄存器已满");
	}
}

