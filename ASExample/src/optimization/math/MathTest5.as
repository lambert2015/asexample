package optimization.math
{
	import optimization.Test;

	public class MathTest5 extends Test
	{
		public function MathTest5()
		{
			super();
			test();
		}
		private function test():void
		{
			var n:int=1000000;
			
			start("int:");
			
			var angle:Number=Math.random();
			var out:Number;
			start("sin:");
			for(var j:int=0;j<n;j++)
			{
				out=Math.sin(angle);
			}
			end();
			
            start("fastsin:");
			for(j=0;j<n;j++)
			{
				var f:int = int(angle * 683565275.57643158978229477811035) >> 16;
             	var sin:int = (f - ((f * ((f < 0)?-f:f)) >> 15)) * 41721;
             	var ssin:int = sin >> 15;
             	out=(((ssin * (sin < 0?-ssin:ssin)) >> 9) * 467 + sin) / 441009855.21060102566599663103894;
			}
			end();

			
		}
		
	}
}