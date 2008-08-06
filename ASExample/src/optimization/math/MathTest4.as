package optimization.math
{
	import optimization.Test;

	public class MathTest4 extends Test
	{
		public function MathTest4()
		{
			super();
			test();
		}
		private function test():void
		{
			var n:int=1000000;
			
			//整数与浮点数循环
			start("abs:");
			var a:Number;
			var t:Number=-Math.random()*50;
			for(var i:int=0;i<n;i++)
			{
				a=Math.abs(t);
			}
			end();
			
			start("int:");
			for(i=0;i<n;i++)
			{
				a= t>0 ? t : -t;
			}
			end();
			
			start("ceil:");
			var g:int;
			t=-Math.random()*50;
			for(i=0;i<n;i++)
			{
				g=Math.ceil(t);
			}
			end();
			trace(g);
			start("int:");
			for(i=0;i<n;i++)
			{
				g= t>0 ? int(t)+1 : int(t);
			}
			end();
			trace(g);
			

			
		}
		
	}
}