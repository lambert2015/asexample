package optimization.array
{
	import flash.geom.Point;
	
	import optimization.Test;

	public class CalculateTest extends Test
	{
		public function CalculateTest()
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
			for(i=0;i<n;i++)
			{
				arr[i].x+=Math.random();
			}
			end();

			start("test 1");
			var point:Point;
			for(i=0;i<n;i++)
			{
				point=arr[i];
				point.x+=Math.random();
			}
			end();

		}
		
	}
}