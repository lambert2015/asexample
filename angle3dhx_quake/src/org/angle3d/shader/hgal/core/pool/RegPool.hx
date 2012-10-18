package org.angle3d.shader.hgal.core.pool;
import flash.Vector;
import org.angle3d.shader.hgal.core.reg.Reg;

/**
 * 寄存器池
 * @author andy 
 */
class RegPool 
{
    private var _regs:Vector<Reg>;
	
	public function new() 
	{
		_regs = new Vector<Reg>();
	}

	public function addReg(value:Reg):Void
	{
		if (_regs.indexOf(value) == -1)
		{
			_regs.push(value);
		}
	}
	
	public function getRegs():Vector<Reg>
	{
		return _regs;
	}
	
	public function clear():Void
	{
		_regs.length = 0;
	}
	
	public function arrange():Void
	{
		for (i in 0..._regs.length)
		{
			register(_regs[i]);
		}
	}
	
	/**
	 * 注册寄存器位置
	 * @param value
	 */
	public function register(value:Reg):Void
	{
		
	}
	
	/**
	 * 注销
	 * @param value
	 */
	public function logout(value:Reg):Void
	{
		
	}
	
}