package org.angle3d.material.hgal.core.pool;
import flash.Lib;
import flash.Vector;
import flash.Vector;
import org.angle3d.material.hgal.core.reg.TempReg;
import org.angle3d.material.hgal.core.reg.Reg;

#if debug
import org.angle3d.utils.Assert;
#end

/**
 * 使用一个临时变量前，首先需要对其寄存器所在位置初始化,否则会报错
 * 例如定义一个变量t_size,寄存器位置为0，使用t_size值前需要设置整个vt0的值
 * 目前采用最简单的方法就是设置vt0.xyzw = 0.0,常量0.0存入uniform中
 * 可以试试当有常量时就用第一个常量填充，而不需要再添加一个0.0常量
 * 临时变量寄存器池
 * @author andy
 */
class TempRegPool extends RegPool
{
	private var _pool:Vector<Int>;
	
	private var _maxReg:Int;
	
	public function new() 
	{
		super();
		_pool = new Vector<Int>(4 * 8, true);
		_maxReg = 0;
	}
	
	override public function clear():Void
	{
		super.clear();
		for (i in 0...32)
		{
			_pool[i] = 0;
		}
		_maxReg = 0;
	}
	
	override public function arrange():Void
	{
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
		
		var size:Int = VarType.getLength(value.varType);
		#if debug
		Assert.assert(size > 0, "size至少要大于0");
		#end
		
		var tVar:TempReg = Lib.as(value, TempReg);
		
		//除了矩阵外，其他类型的临时变量不能跨越寄存器，只能存在于某个寄存器中
		
		//小于3时，可以在任意位置寻找
		if (size < 3)
		{
			for (i in 0...8)
			{
				var array:Vector<TempFree> = _getFreeAt(i);
				for (m in 0...array.length)
				{
					//空闲空间大于等于需要的大小
					if (array[m].size >= size)
					{
						_registerVar(tVar, i, array[m].offset, size);
						return;
					}
				}
			}
		}
		//==3时，
		//因为nrm函数不容许使用w,所以只能找前3位是空余的寄存器
		else if (size == 3)
		{
			for (i in 0...8)
			{
				var array:Vector<TempFree> = _getFreeAt(i);
				for (m in 0...array.length)
				{
					var free:TempFree = array[m];
					//空闲空间大于等于需要的大小,并且无偏移
					if (free.size >= size && free.offset == 0)
					{
						_registerVar(tVar, i, free.offset, size);
						return;
					}
				}
			}
		}
		else
		{
			//vec4,mat3,mat4
			var matLength:Int = Std.int(size / 4);
			
			//防止出界
			var range:Int = 9 - matLength;
			for (i in 0...range)
			{
				//连续多个寄存器可用
				if (isFrees(i, i + matLength))
				{
					_registerVar(tVar, i, 0, size);
					return;
				}
			}
		}
		
		#if debug
		Assert.assert(false, "未能找到空闲位置，寄存器已满");
		#end
	}
	
	/**
	 * 注册一个临时变量
	 * @param	tVar
	 * @param	index 起始寄存器位置
	 * @param	offset 偏移量
	 * @param	size 需要注册的寄存器大小
	 */
	private function _registerVar(tVar:TempReg,index:Int,offset:Int,size:Int):Void
	{
		tVar.index = index;
		tVar.offset = offset;
		_registerPool(index * 4 + offset, size);
	}
	
	/**
	 * 获得已经注册掉的寄存器数量
	 * @return
	 */
	public function getMaxReg():Int
	{
		return _maxReg;
	}
	
	/**
	 * 注册某一段位置
	 * @param	start 起始点 绝对起始点
	 * @param	size 长度
	 */
	private function _registerPool(start:Int, size:Int):Void
	{
		var end:Int = start + size;
		for (i in start...end)
		{
			setRegistered(i);
		}
	}
	
	/**
	 * 是否已注册
	 * @param	pos
	 * @return
	 */
	private inline function isRegistered(pos:Int):Bool
	{
		return _pool[pos] == 1;
	}
	
	/**
	 * 注册某个位置
	 * @param	pos
	 */
	private inline function setRegistered(pos:Int):Void
	{
		_pool[pos] = 1;
		
		//设置最大注册
		if (pos >= _maxReg * 4)
		{
			_maxReg = Math.ceil((pos+1) / 4);
		}
	}
	
	/**
	 * 取消注册某个位置
	 * @param	pos
	 */
	private inline function clearRegistered(pos:Int):Void
	{
		_pool[pos] = 0;
	}
	
	/**
	 * 获取某个寄存器连续的空闲位置(一个寄存器中可能会有2个空闲空间)
	 * @param	index
	 * @return Array 每两位代表一个连续空间，分别表示起始位置和大小
	 */
	private function _getFreeAt(index:Int):Vector<TempFree>
	{
		index *= 4;
		
		var list:Vector<TempFree> = new Vector<TempFree>();
		
		var tempFree:TempFree = null;
		
		//是否是空闲地址
		var isFirst:Bool = true;
		var freeSize:Int = 0;
		
		for (j in 0...4)
		{
			//此地址空闲
			if (_pool[index + j] == 0)
			{
				if (isFirst)
				{
					//写入起始位置
					tempFree = new TempFree();
					tempFree.offset = j;
					list.push(tempFree);
					isFirst = false;
				}
				freeSize++;
			}
			else
			{
				//freeSize > 0代表之前有个连续空闲空间，加入其大小
				if (freeSize > 0)
				{
					tempFree.size = freeSize;
				}
				isFirst = true;
				freeSize = 0;
			}
		}
		
		//设置最后一个连续空间的大小
		if (freeSize > 0)
		{
			tempFree.size = freeSize;
		}
			
		return list;
	}
	
	/**
	 * 某个寄存器是否完全空闲
	 * @param	index
	 * @return
	 */
	private function isRegisterFree(index:Int):Bool
	{
		index *= 4;
		
		var value:Int = 0;
		for (i in 0...4)
		{
			value += _pool[index + i];
		}
		
		return (value == 0);
	}
	
	/**
	 * 
	 * @param	start 开始寄存器位置
	 * @param	end 结束寄存器位置
	 * @return
	 */
	private function isFrees(start:Int,end:Int):Bool
	{
		for (i in start...end)
		{
			if (!isRegisterFree(i))
			{
				return false;
			}
		}
		return true;
	}
	
	/**
	 * 释放tVar占用的寄存器位置
	 * @param	tVar
	 */
	override public function logout(value:Reg):Void
	{
		var tVar:TempReg = Lib.as(value, TempReg);
		
		#if debug
		Assert.assert(tVar != null, value.name + "不是临时变量");
		#end
		
		var start:Int = tVar.index * 4 + tVar.offset;
		var length:Int = start + tVar.size;
		for (i in start...length)
		{
			clearRegistered(i);
		}
	}
	
	/**
	 * 测试用
	 * @return
	 */
	public function toString():String
	{
		var str:String = "TempRegisterPool\n[\n ";
		for (i in 0...8)
		{
			var line:String = "";
			for (j in 0...4)
			{
				line += _pool[i * 4 + j] + "\t";
			}
			str += line + "\n";
		}
		return str;
	}
	
}

class TempFree
{
	public var offset:Int;
	public var size:Int;
	
	public function new()
	{
		
	}
}