package org.angle3d.material.sgsl.pool
{

	import org.angle3d.material.sgsl.node.reg.RegNode;
	import org.angle3d.utils.Assert;

	/**
	 * 取样器寄存器池
	 * @author andy
	 */
	public class TextureRegPool extends RegPool
	{
		private var _pool:Vector.<int>;
		private var _maxCount:int;

		public function TextureRegPool()
		{
			super();
			_maxCount = 8;
			_pool = new Vector.<int>(_maxCount, true);
		}

		override public function clear():void
		{
			super.clear();
			for (var i:int = 0; i < _maxCount; i++)
			{
				_pool[i] = 0;
			}
		}

		/**
		 * 设置value寄存器位置
		 * @param value 对应的临时变量
		 */
		override public function register(node:RegNode):void
		{
			CF::DEBUG
			{
				Assert.assert(!node.registered, node.name + "不能注册多次");
			}

			for (var i:int = 0; i < _maxCount; i++)
			{
				if (_pool[i] == 0)
				{
					node.index = i;
					_pool[i] = 1;
					return;
				}
			}

			CF::DEBUG
			{
				Assert.assert(false, "未能找到下一个空闲位置，寄存器已满");
			}
		}
	}
}

