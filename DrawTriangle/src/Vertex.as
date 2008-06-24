package 
{
	public final class Vertex
	{
		//position
		public var x : Number;
		public var y : Number;
		public var z : Number;
		//color
		public var a : int=255;
		public var r : int;
		public var g : int;
		public var b : int;
		//uv
		public var u : Number;
		public var v : Number;
		
		public function Vertex (x : Number = 0, y : Number = 0, z : Number = 0, c : uint = 0xFFFFFFFF, u : Number = 0, v : Number = 0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.color = c;
			this.u = u;
			this.v = v;
		}
		public function get color () : uint
		{
			return  ((255 << 24) | (r << 16) | (g << 8) | b);
		}
		public function set color (c : uint) : void
		{
			a = (c >> 24) & 0xFF;
			r = (c >> 16) & 0xFF;
			g = (c >> 8) & 0xFF;
			b = (c) & 0xFF;
		}
		public function clone():Vertex
		{
			var vertex:Vertex=new Vertex();
			vertex.x=x;
			vertex.y=y;
			vertex.z=z;
			vertex.color=color;
			vertex.u=u;
			vertex.v=v;
			return vertex;
		}
		public function copy(c:Vertex):void
		{
			x=c.x;
			y=c.y;
			z=c.z;
			color=c.color;
			u=c.u;
			v=c.v;
		}
		public function toString():String
		{
			return "[ x="+x+',y='+y+',z='+z+',a='+a+',r='+r+',g='+g+',b='+b+' ]';
		}
		public function equals(other:Vertex):Boolean
		{
			return (x==other.x && y==other.y && z==other.z 
			       && r==other.r && g==other.g && b==other.b
			       && u==other.u && v==other.v);
		}
	}
}
