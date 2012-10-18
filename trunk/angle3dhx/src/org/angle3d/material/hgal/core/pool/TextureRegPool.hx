package org.angle3d.material.hgal.core.pool;
import flash.Vector;
import org.angle3d.material.hgal.core.reg.Reg;

#if debug
import org.angle3d.utils.Assert;
#end

/**
 * 取样器寄存器池
 * @author andy
 */
class TextureRegPool extends RegPool
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
		
		for ( i in 0...8 )
		{
			if (_pool[i] == 0 )
			{
				value.index = i;
				_pool[i] = 1;
				return;
			}
		}
		
		#if debug
		Assert.assert(false, "未能找到下一个空闲位置，寄存器已满");
		#end
	}
}