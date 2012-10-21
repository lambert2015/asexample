package org.angle3d.io.parser.max3ds
{
	import flash.events.EventDispatcher;

	internal class AbstractMax3DSParser
	{
		private var _functions:Array;

		public function AbstractMax3DSParser(chunk:Max3DSChunk=null)
		{
			initialize();

			if (chunk)
				parseChunk(chunk);
		}

		protected function initialize():void
		{
			_functions=new Array();
			// override & fill _functions here
		}

		protected function get parseFunctions():Array
		{
			return _functions;
		}

		protected function finalize():void
		{
			// NOTHING
		}

		final protected function parseChunk(chunk:Max3DSChunk):void
		{
			var parseFunction:Function=null;

			parseFunction=_functions[chunk.identifier];

			if (parseFunction == null)
			{
				chunk.skip();

				return;
			}

			parseFunction(chunk);

			enterChunk(chunk);

			finalize();
		}

		final protected function enterChunk(chunk:Max3DSChunk):void
		{
			while (chunk.bytesAvailable > 0)
			{
				var innerChunk:Max3DSChunk=new Max3DSChunk(chunk.data);

				var parseFunction:Function=_functions[innerChunk.identifier];
				if (parseFunction == null)
				{
					innerChunk.skip();
				}
				else if (parseFunction != enterChunk)
				{
					parseFunction(innerChunk);
				}
			}
		}

	}
}
