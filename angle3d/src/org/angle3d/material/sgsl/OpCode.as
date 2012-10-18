package org.angle3d.material.sgsl
{

	/**
	 * 操作符
	 * @author
	 */
	internal class OpCode
	{
		public var emitCode : uint;
		public var flags : uint;
		public var numRegister : uint;

		public var names : Array;

		/**
		 *
		 * @param	names 名称
		 * @param	numRegister 参数数量
		 * @param	emitCode
		 * @param	flags
		 */
		public function OpCode(names : Array, numRegister : uint, emitCode : uint, flags : uint)
		{
			this.names = names;
			this.numRegister = numRegister;
			this.emitCode = emitCode;
			this.flags = flags;
		}

		/**
		 * 只能在Fragment中使用
		 * @return
		 */
		public function isFragOnly() : Boolean
		{
			return (flags & OpCodeManager.OP_FRAG_ONLY) != 0;
		}
	}
}

