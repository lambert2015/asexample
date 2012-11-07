package org.angle3d.material.sgsl.pool
{

	import org.angle3d.material.sgsl.node.reg.RegNode;

	/**
	 * 寄存器池
	 * @author andy
	 */
	public class RegPool
	{
		protected var _regs:Vector.<RegNode>;

		public function RegPool()
		{
			_regs = new Vector.<RegNode>();
		}

		public function addReg(value:RegNode):void
		{
			if (_regs.indexOf(value) == -1)
			{
				_regs.push(value);
			}
		}

		public function getRegs():Vector.<RegNode>
		{
			return _regs;
		}

		public function clear():void
		{
			_regs.length = 0;
		}

		public function build():void
		{
			var count:int = _regs.length;
			for (var i:int = 0; i < count; i++)
			{
				register(_regs[i]);
			}
		}

		/**
		 * 注册寄存器位置
		 * @param value
		 */
		public function register(node:RegNode):void
		{

		}

		/**
		 * 注销
		 * @param value
		 */
		public function logout(node:RegNode):void
		{

		}
	}
}

