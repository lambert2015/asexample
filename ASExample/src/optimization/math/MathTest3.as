package optimization.math
{
	import optimization.Test;

	public class MathTest3 extends Test
	{
		public function MathTest3()
		{
			super();
			test();
		}
		private function test():void
		{
			var n:int=1000000;
			
			//整数与浮点数循环
			start("Number:");
			var t:Number=50;
			var a:Number=100.0;
			var b:Number=200.0;
			var c:Number=300.0;
			var d:Number=400.0;
			var e:Number=3.14;
			for(var i:int=0;i<n;i++)
			{
				a=a/e;
				b=b/e;
				c=c/e;
				d=d/e;
			}
			end();
			
			start("int:");
			var t1:Number;
			for(i=0;i<n;i++)
			{
				t1=1/e;
				
				a=a*t1;
				b=b*t1;
				c=c*t1;
				d=d*t1;
			}
			end();
		}
		
	}
}