package org.angle3d.material.sgsl.pool;


import org.angle3d.material.sgsl.node.reg.RegNode;

/**
 * 寄存器池
 * @author andy
 */
class RegPool
{
	private var mRegLimit:Int;

	private var mProfile:String;

	private var mRegs:Vector<RegNode>;

	public function new(profile:String)
	{
		this.profile = profile;

		mRegLimit = getRegLimit();
		mRegs = new Vector<RegNode>();
	}

	private function getRegLimit():uint
	{
		return 0;
	}

	public function set profile(value:String):Void
	{
		mProfile = value;
	}

	public function addReg(value:RegNode):Void
	{
		if (mRegs.indexOf(value) == -1)
		{
			mRegs.push(value);
		}
	}

	public function getRegs():Vector<RegNode>
	{
		return mRegs;
	}

	public function clear():Void
	{
		mRegs.length = 0;
	}

	public function build():Void
	{
		var count:Int = mRegs.length;
		for (var i:Int = 0; i < count; i++)
		{
			register(mRegs[i]);
		}
	}

	/**
	 * 注册寄存器位置
	 * @param value
	 */
	public function register(node:RegNode):Void
	{

	}

	/**
	 * 注销
	 * @param value
	 */
	public function logout(node:RegNode):Void
	{

	}
}
