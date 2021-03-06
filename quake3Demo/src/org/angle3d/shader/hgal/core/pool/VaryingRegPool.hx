package org.angle3d.shader.hgal.core.pool;
import flash.Vector;
import org.angle3d.shader.hgal.core.reg.Reg;

#if debug
import org.angle3d.utils.Assert;
#end

/**
 * 变化寄存器池
 * @author andy
 */
class VaryingRegPool extends RegPool
{
	private var _pool:Vector<Int>;

	public function new() 
	{
		super();
		_pool = new Vector<Int>(8, true);
	}
	
	override public function clear():Void
	{
		super.clear();
		
		for (i in 0...8)
		{
			_pool[i] = 0;
		}
	}

	/**
	 * 设置tVar寄存器位置
	 * @param	tVar 对应的临时变量
	 */
    override public function register(value:Reg):Void
	{
		#if debug
		Assert.assert(!value.isRegistered(), value.name + "不能注册多次");
		#end
		
		//TODO 应该尽量避免传递Mat4,Mat3，大部分情况下没必要
		var size:Int = VarType.getRegisterCount(value.varType);
		for ( i in 0...8 )
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