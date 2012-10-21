package org.angle3d.io.parser
{
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	public interface IParser extends IEventDispatcher
	{
		//function get data() : Vector.<IScene>;

		function parse(data:ByteArray, options:ParserOptions):Boolean;
	}
}
