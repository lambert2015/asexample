package org.angle3d.input
{
	import org.angle3d.input.controls.InputListener;

	public class InputMapping
	{
		public var name:String;
		public var triggers:Array;
		public var listeners:Array;

		public function InputMapping(name:String)
		{
			this.name = name;

			this.triggers = new Array();
			this.listeners = new Array();
		}
	}
}

