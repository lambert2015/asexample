package optimization.array
{
	import optimization.Test;
	
	public class PushTest extends Test
	{
		public function PushTest()
		{
			super();
			test();
		}
		private function test():void
		{
			var n:int=1000000;
			var arr:Array=new Array();
			start("test 0");
			for(var i:int=0;i<n;i++)
			{
				arr.push(Math.random());
			}
			end();
			
			var arr1:Array=new Array();
			start("test 1");
			for(i=0;i<n;i++)
			{
				arr1[i]=Math.random();
			}
			end();

		}

	}
}