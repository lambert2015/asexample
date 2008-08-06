package optimization.array
{
	import flash.geom.Point;
	
	import optimization.Test;

	public class ArrayTest extends Test
	{
		public function ArrayTest()
		{
			super();
			test();
		}
		private function test():void
		{
			appendText("Point");
			var n:int=1000000;
			var arr:Array=new Array();
			for(var i:int=0;i<n;i++)
			{
				arr.push(new Point());
			}
			
			start("test 0");
			for(i=0;i<(n/2);i++)
			{
				arr[i+2].x+=1.0;
			}
			end();

			start("test 1");
			for(i=0;i<(n/2);i++)
			{
				arr[int(i+2)].x+=1.0;
			}
			end();
			
			var point:Point;
			start("test 3");
			for(i=0;i<(n/2);i++)
			{
				point=arr[int(i+2)];
				point.x+=1.0;
			}
			end();
			
			start("test 4");
			for(i=0;i<(n/2);i++)
			{
				point=arr[i+2];
				point.x+=1.0;
			}
			end();

		}
		
	}
}