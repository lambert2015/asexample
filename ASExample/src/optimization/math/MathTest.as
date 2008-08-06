package optimization.math
{
	import optimization.Test;

	public class MathTest extends Test
	{
		public function MathTest()
		{
			super();
			test();
		}
		private function test():void
		{
			var n:int=1000000;
			
			//整数与浮点数循环
			start("Number:");
			var t:Number;
			for(var i:Number=0;i<n;i++)
			{
				t=i*i;
			}
			end();
			
			start("int:");
			var t1:int;
			for(var j:int=0;j<n;j++)
			{
				t=j*j;
			}
			end();

			t1=10;
			var t2:int=30;
			n=10000000;
			var tmp:int;
			start("swap 0:");
			for(j=0;j<n;j++)
			{
				tmp=t1;t1=t2;t2=tmp;
			}
			end();
			
			var tmp1:Number;
			start("swap 1:");
			for(j=0;j<n;j++)
			{
				tmp1=t1;t1=t2;t2=tmp1;
			}
			end();
			
			start("swap 2:");
			for(j=0;j<n;j++)
			{
				t1 ^= t2; t2 ^= t1; t1 ^= t2;
			}
			end();
			
		}
		
	}
}