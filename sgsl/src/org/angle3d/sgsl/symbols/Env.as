package org.angle3d.sgsl.symbols 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class Env 
	{
		public var prev:Env;
		private var table:Dictionary;
		
		public function Env(prev:Env) 
		{
			this.prev = prev;
			table = new Dictionary();
		}
		
	}

}