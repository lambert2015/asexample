package org.angle3d.material.hgal.core;

/**
 * 操作符
 * @author 
 */
class OpCode 
{
	public var name:String;
	public var emitCode : UInt;
	public var flags : UInt;
	public var numRegister : UInt;
	
	public var nicknames:Array<String>;

	/**
	 * 
	 * @param	name 名称
	 * @param	numRegister 参数数量
	 * @param	emitCode 
	 * @param	flags
	 * @param	nicknames 程序中可以使用原名或者昵称
	 */
	public function new(name:String, numRegister : UInt, emitCode : UInt, flags : UInt, nicknames:Array<String> = null)
	{
		this.name = name;
		this.numRegister = numRegister;
		this.emitCode = emitCode;
		this.flags = flags;
		this.nicknames = nicknames;
	}
	
	/**
	 * 只能在Fragment中使用
	 * @return
	 */
	public inline function isFragOnly():Bool
	{
		return (flags & OpCodeManager.OP_FRAG_ONLY) != 0;
	}
	
	/**
	 * 没有目标对象
	 * @return
	 */
	public inline function isNoDest():Bool
	{
		return (flags & OpCodeManager.OP_NO_DEST) != 0;
	}
	
	/**
	 * 
	 * @return
	 */
	public inline function isTexture():Bool
	{
		return (flags & OpCodeManager.OP_SPECIAL_TEX) != 0;
	}
	
}