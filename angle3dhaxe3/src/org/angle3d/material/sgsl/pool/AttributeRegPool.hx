package org.angle3d.material.sgsl.pool;


import org.angle3d.material.sgsl.node.reg.RegNode;
import org.angle3d.material.shader.ShaderProfile;
import org.angle3d.utils.Assert;
import flash.Vector;
/**
 * Attribute寄存器池
 * @author andy
 */
class AttributeRegPool extends RegPool
{
	private var _pool:Vector<Int>;

	public function new(profile:ShaderProfile)
	{
		super(profile);

		_pool = new Vector<Int>(mRegLimit);
	}

	override private function getRegLimit():Int
	{
		return 8;
	}

	override public function clear():Void
	{
		super.clear();
		for (i in 0...mRegLimit)
		{
			_pool[i] = 0;
		}
	}

	/**
	 * 设置value寄存器位置
	 * @param value 对应的变量
	 */
	override public function register(node:RegNode):Void
	{
		Assert.assert(!node.registered, node.name + "不能注册多次");

		for (i in 0...mRegLimit)
		{
			if (_pool[i] == 0)
			{
				node.index = i;
				_pool[i] = 1;
				return;
			}
		}


		Assert.assert(false, "未能找到下一个空闲位置，寄存器已满");
	}
}

