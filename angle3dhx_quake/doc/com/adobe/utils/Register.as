package com.adobe.utils
{
	public class Register
	{
		public var emitCode:uint;
		public var name:String;
		public var longName:String;
		public var flags:uint;
		public var range:uint;

		public function Register(name:String, longName:String, emitCode:uint, range:uint, flags:uint)
		{
			this.name = name;
			this.longName = longName;
			this.emitCode = emitCode;
			this.range = range;
			this.flags = flags;
		}

		public function toString():String
		{
			return "[Register name=\'" + name + "\', longName=\"" + longName + "\", emitCode=" + emitCode + ", range=" + range + ", flags=" + flags + "]";
		}
	}
}

