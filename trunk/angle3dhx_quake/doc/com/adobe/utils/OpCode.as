package com.adobe.utils
{
	public class OpCode
	{
		public var emitCode:uint;
		public var flags:uint;
		public var name:String;
		public var numRegister:uint;

		public function OpCode(name:String, numRegister:uint, emitCode:uint, flags:uint)
		{
			this.name = name;
			this.numRegister = numRegister;
			this.emitCode = emitCode;
			this.flags = flags;
		}

		public function toString():String
		{
			return "[OpCode name=\'" + name + "\', numRegister=" + numRegister + ", emitCode=" + emitCode + ", flags=" + flags + "]";
		}
	}
}

