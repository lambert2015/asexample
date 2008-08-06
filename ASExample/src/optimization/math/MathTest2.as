package optimization.math
{
	import flash.display.BitmapData;
	
	import optimization.Test;

	public class MathTest2 extends Test
	{
		public function MathTest2()
		{
			super();
			test();
		}
		private function test():void
		{
			var width:int=1000;
			var height:int=1000;
			var bitmapData:BitmapData=new BitmapData(400,400,false,0x0);
			
			var n:int=1000000;
			var t:Number;
			start("setPixel 0:");
			for(var i:int=0;i<height;i++)
			{
				for(var j:int=0;j<width;j++)
				{
					t=Math.random()*50;
					bitmapData.setPixel(j,i,t);
				}
				
			}
			end();
			
			start("setPixel 0:");
			for(i=0;i<height;i++)
			{
				for(j=0;j<width;j++)
				{
					t=Math.random()*50;
					bitmapData.setPixel(j,i,int(t));
				}
			}
			end();
		}
		
	}
}