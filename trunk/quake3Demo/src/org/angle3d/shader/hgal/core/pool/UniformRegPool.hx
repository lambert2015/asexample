package org.angle3d.shader.hgal.core.pool;
import flash.Vector;
import org.angle3d.shader.hgal.core.reg.Reg;
import org.angle3d.shader.ShaderType;

#if debug
import org.angle3d.utils.Assert;
#end

/**
 * 常量寄存器池
 * 首先需要收集所有的常数，然后才可以锁定其他类型的变量
 * @author andy
 */
//TODO 目前只接受3种类型，vec4,mat3,mat4，需要支持array
class UniformRegPool extends RegPool
{
	private var _pool:Vector<Int>;
	
	/**
	 * 寄存器最大值
	 */
	private var max:Int;
	
	private var _digits:Vector<Float>;
	
	private var shaderType:String;

	public function new(type:String) 
	{
		super();
		
		this.shaderType = type;
		
		max = (shaderType == ShaderType.VERTEX) ? 128 : 28;
		
		_pool = new Vector<Int>(max, true);
		
		_digits = new Vector<Float>();
		
		/**
		 * 默认加入一个0，主要是为了方便初始化临时变量寄存器
		 * 目前临时变量有多种类型，长度小于4的vec3,vec2,float类型初始化的时候
		 * 如果其所在寄存器vt0没有初始化的话，设置vt0.x = ...会出错
		 * 为了避免这种情况出现，在使用某个临时寄存器前，会给其所有属性赋值为0
		 * vt0.xyzw = vc0.x | vt0 = vc0.x
		 */
		//_digits.push(1.0);
	}
	
	/**
	 * 一次性注册所有Uniform
	 */
	override public function arrange():Void
	{
		//常量总是放在最前面
		registerDigits();
		
		super.arrange();
	}
	
	/**
	 * 在遍历主函数时主动添加常量到UniformPool中
	 * 添加常量
	 * @param	value
	 */
	public function addDigit(value:Float):Void
	{
		if (_digits.indexOf(value) == -1)
		{
			_digits.push(value);
		}
	}
	
	public function getDigitIndex(value:Float):Int
	{
		var index:Int = _digits.indexOf(value);
		return Std.int(index / 4);
	}
	
	public function getDigitComponent(value:Float):String
	{
		var index:Int = _digits.indexOf(value);
		var register:Int = Std.int(index / 4);
		var order:Int = index - register * 4;
		var str:String = "xyzw";
		return str.substr(order, 1);
	}
	
	/**
	 * 获得常量代表的agal name
	 * @param	value
	 * @return
	 */
	public function getDigitName(value:Float):String
	{
		var prex:String = (shaderType == ShaderType.VERTEX) ? "v" : "f";
		
		var index:Int = _digits.indexOf(value);
		
		#if debug
		Assert.assert(index > -1, "UniformPool中找不到常量");
		#end
		
		var register:Int = Std.int(index / 4);
		var order:Int = index - register * 4;
		
		var str:String = "xyzw";
		
		return prex + "c" + register + "." + str.substr(order, 1);
	}
	
	/**
	 * 返回常量数组，每4个分为一组,不够的补齐
	 * @return
	 */
	public function getDigits():Vector<Vector<Float>>
	{
		var len:Int = _digits.length;
		if (len == 0)
		{
			return null;
		}

		var result:Vector<Vector<Float>> = new Vector<Vector<Float>>();
			
		var ceil:Int = Math.ceil(len / 4);
		for (i in 0...ceil)
		{
			var list:Vector<Float> = new Vector<Float>(); 
			
			for (j in 0...4)
			{
				if (i * 4 + j < len)
				{
					list.push(_digits[j]);
				}
				else //不足的部分用0填充
				{
					list.push(0.0);
				}
			}
				
			result[i] = list;
		}
			
		return result;
	}
	
	/**
	 * 锁定常量占用的寄存器
	 */
    private function registerDigits():Void
	{
		//clear pool
		for (i in 0...max)
		{
			_pool[i] = 0;
		}
		
		var cl:Int = _digits.length;
		if (cl > 0)
		{
			var count:Int = Math.ceil(cl / 4);
			for ( i in 0...count)
			{
				_pool[i] = 1;
			}
		}
	}
	
	override public function clear():Void
	{
		super.clear();
		
		for (i in 0...max)
		{
			_pool[i] = 0;
		}
		
		_digits.length = 0;
	}
	
	/**
	 * 设置value寄存器位置
	 * @param	value 对应的临时变量
	 */
    override public function register(value:Reg):Void
	{
		#if debug
		Assert.assert(!value.isRegistered(), value.name + "不能注册多次");
        #end
		
		var size:Int = VarType.getRegisterCount(value.varType);
		for ( i in 0...max)
		{
			if (_pool[i] == 0 )
			{
				value.index = i;
				for (j in 0...size)
				{
					_pool[i+j] = 1;
				}
				return;
			}
		}
		
		#if debug
		Assert.assert(false, "未能找到下一个空闲位置，寄存器已满");
		#end
	}
}