package  
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author hacker47
	 */
	public class Test extends MovieClip 
	{
		private var loader:Loader;
		private var url:String = "1.jpg";
		private var bitmap:Bitmap;
		private var matrix:Matrix;
		private var angle:Number = 0;
		private var speed:Number = .05;
		
		public function Test() 
		{
			if (stage) init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.load(new URLRequest(url));

		}
		
		private var sprite:Sprite;

		private function onComplete(e:Event):void 
		{
			bitmap = e.target.content as Bitmap;

			
			
			
			sprite = new Sprite();
			bitmap.x = (- bitmap.width) / 2;
			bitmap.y = ( - bitmap.height) / 2;
			sprite.addChild(bitmap);
			this.addChild(sprite);
			
			sprite.x = (stage.stageWidth- bitmap.width) / 2;
			sprite.y = (stage.stageHeight - bitmap.height) / 2;
			
			//bitmap.rotation = 45;

			matrix = bitmap.transform.matrix.clone();
			stage.addEventListener(Event.ENTER_FRAME, running);
		}
		
		private var _rotation:Number = 0;
		private function running(e:Event = null):void 
		{	
			_rotation += 5;
			
			sprite.rotation = _rotation;
			
			//bitmap.x = stage.mouseX - bitmap.width * 0.5;
			//bitmap.y = stage.mouseY - bitmap.height * 0.5;

			//var matrix:Matrix = new Matrix();
			//matrix.identity();
			//matrix.tx = bitmap.x;
			//matrix.ty = bitmap.y;
			//bitmap.getr
			//matrix = bitmap.transform.matrix.clone();
			//rotate(bitmap, _rotation, bitmap.width / 2, bitmap.height / 2, matrix);
			//bitmap.x = (stage.stageWidth - bitmap.width) / 2;
			//bitmap.y = (stage.stageHeight - bitmap.height) / 2;
		}
		
		private function rotate(dis:DisplayObject, rotation:Number, px:Number, py:Number, srcMatrix:Matrix):void 
		{
			var tx:Number = dis.x + px;
			var ty:Number = dis.y + py;
			
			var m:Matrix = srcMatrix.clone();
			m.translate(-tx, -ty);
			m.rotate(rotation * Math.PI / 180);
			m.translate(tx, ty);
			dis.transform.matrix = m;
			
		}
		
	}

}