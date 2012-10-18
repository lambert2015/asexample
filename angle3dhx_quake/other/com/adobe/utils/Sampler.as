package com.adobe.utils
{
	public class Sampler
	{
		public var flag:uint;
		public var mask:uint;
		public var name:String;

		public function Sampler(name:String, flag:uint, mask:uint)
		{
			this.name = name;
			this.flag = flag;
			this.mask = mask;
		}

		public function toString():String
		{
			return "[Sampler name=\'" + name + "\', flag=\'" + flag + "\', mask=" + mask + "]";
		}
	}
}

