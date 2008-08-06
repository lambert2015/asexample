package optimization.keywords
{
	import optimization.Test;

	public class StaticTest extends Test
	{
		public function StaticTest()
		{
			super();
			test();
		}
		private function test():void
		{
			var n:int=1000000;
			
			start("function:");
			var v0:Vector=new Vector(30,30.4);
			var v1:Vector=new Vector(10,10);
			for(var i:int=0;i<n;i++)
			{
				v0.add(v1)
			}
			end();
			
			v0=new Vector(30,30.4);
			v1=new Vector(10,10);
			start("static function:");
			for(i=0;i<n;i++)
			{
				Vector.add(v1,v0);
			}
			end();
            
            
            start("var:");
			v0=new Vector(30,30.4);
			for(i=0;i<n;i++)
			{
				v0.x+=v0.width;
			}
			end();
			
			v0=new Vector(30,30.4);
			start("static var:");
			for(i=0;i<n;i++)
			{
				v0.x+=Vector.width;
			}
			end();
		}

	}
}

class Vector
{
	public var x:Number;
	public var y:Number;
	
	public var width:Number=400;
	public static var width:Number=400;
	
	public function Vector(x:Number,y:Number)
	{
		this.x=x;
		this.y=y;
	}
	public function add(v:Vector):void
	{
		x+=v.x;
		y+=v.y;
	}
	public static function add(v0:Vector,vout:Vector):void
	{
		vout.x+=v0.x;
		vout.y+=v0.y;
	}
}