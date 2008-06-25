package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
    [SWF(width='400',height='400',frameRate='40')]
	public class TestGouraud extends Sprite
	{
		private var target:BitmapData;
		private var draw:DrawGouraudTriangle;
		private var v0:Vertex=new Vertex();
		private var v1:Vertex=new Vertex();;
		private var v2:Vertex=new Vertex();;
		public function TestGouraud()
		{
			target = new BitmapData (400, 400, true, 0x0);
			this.addChild (new Bitmap (target));
			draw=new DrawGouraudTriangle(target);
            stage.addEventListener(MouseEvent.CLICK,_drawTriangleHandler);
		}
		public function _drawTriangleHandler(e:Event):void
		{
			v0.x=Math.random()*target.rect.width;
			v0.y=Math.random()*target.rect.height;
			v1.x=Math.random()*target.rect.width;
			v1.y=Math.random()*target.rect.height;
			v2.x=Math.random()*target.rect.width;
			v2.y=Math.random()*target.rect.height;
			
			v0.color=Math.random()*0xFFFFFFFF;
			v1.color=Math.random()*0xFFFFFFFF;
			v2.color=Math.random()*0xFFFFFFFF;

			draw.drawTriangle(v0,v1,v2);
		}
	}
}
