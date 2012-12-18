package org.angle3d.material.sgsl2.pool
{

	import org.angle3d.material.sgsl.node.reg.RegNode;

	/**
	 * 寄存器池
	 * @author andy
	 */
	public class RegPool
	{
		protected var mRegLimit:int;

		protected var mProfile:String;

		protected var mRegs:Vector.<RegNode>;

		public function RegPool(profile:String)
		{
			this.profile = profile;

			mRegLimit = getRegLimit();
			mRegs = new Vector.<RegNode>();
		}

		protected function getRegLimit():uint
		{
			return 0;
		}

		public function set profile(value:String):void
		{
			mProfile = value;
		}

		public function addReg(value:RegNode):void
		{
			if (mRegs.indexOf(value) == -1)
			{
				mRegs.push(value);
			}
		}

		public function getRegs():Vector.<RegNode>
		{
			return mRegs;
		}

		public function clear():void
		{
			mRegs.length = 0;
		}

		public function build():void
		{
			var count:int = mRegs.length;
			for (var i:int = 0; i < count; i++)
			{
				register(mRegs[i]);
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

