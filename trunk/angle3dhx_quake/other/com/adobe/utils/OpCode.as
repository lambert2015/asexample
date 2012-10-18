package com.adobe.utils {

	public class OpCode {

		public var emitCode : uint;
		public var flags : uint;
		public var name : String;
		public var numRegister : uint;

		public function OpCode(name : String, numRegister : uint, emitCode : uint, flags : uint) {
			this.name = name;
			this.numRegister = numRegister;
			this.emitCode = emitCode;
			this.flags = flags;
		}

		/**
		 * 只能在fragment中使用
		 */
		public function isFragOnly() : Boolean {
			return (flags & 0x20) != 0; //(flags & OP_FRAG_ONLY) != 0;
		}

		/**
		 *
		 */
		public function noDest():Boolean
		{
			return (flags & 0x80) != 0;
		}

		public function isTexture():Boolean
		{
			return (flags & 0x8) != 0;
		}


		public function toString() : String {
			return "[OpCode name=\'" + name + "\', numRegister=" + numRegister + ", emitCode=" + emitCode + ", flags=" + flags + "]";
		}
	}
}

