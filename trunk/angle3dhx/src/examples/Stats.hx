package examples;
	
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.Lib;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFormat;
import org.angle3d.math.FastMath;
	
class Stats extends Sprite
{		
	private var fpsText : TextField; 
	private var msText : TextField;
	private var memText : TextField; 
	private var format : TextFormat;
		
	private var fps :Int; 
	private var timer : Int; 
	private var ms : Int; 
	private var msPrev	: Int ;
	private var mem : Int ;

	public function new( )
	{
		super();
		
		format = new TextFormat( "_sans", 11 );
			
		graphics.beginFill(0x333);
		graphics.drawRect(0, 0, 80, 50);
		graphics.endFill();
			
		fpsText = new TextField();
		msText = new TextField();
		memText = new TextField();
			
		fpsText.defaultTextFormat = msText.defaultTextFormat = memText.defaultTextFormat = format;
		fpsText.width = msText.width = memText.width = 80;
		fpsText.selectable = msText.selectable = memText.selectable = false;
			
		fpsText.textColor = 0xFFFF00;
		fpsText.text = "FPS: ";
		addChild(fpsText);
			
		msText.y = 14;
		msText.textColor = 0x00FF00;
		msText.text = "MS: ";
		addChild(msText);

		memText.y = 28;
		memText.textColor = 0x00FFFF;
		memText.text = "MEM: ";
		addChild(memText);
			
		addEventListener(MouseEvent.CLICK, mouseHandler);
		addEventListener(Event.ENTER_FRAME, update);
    }
		
    private function mouseHandler( e:MouseEvent ):Void
	{
		if (this.mouseY > this.height * .35)
			stage.frameRate --;
		else
			stage.frameRate ++;
			
		stage.frameRate = FastMath.fclamp(stage.frameRate, 1, 60);
				
		fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
	}	
		
    private function update( e:Event ):Void
    {
		timer = Lib.getTimer();
		fps++;
			
		if( timer - 1000 > msPrev )
		{
			msPrev = timer;
			mem = Std.int( System.totalMemory / 1048576 );
				
			fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
			memText.text = "MEM: " + mem;
			
			fps = 0;
		}
			
		msText.text = "MS: " + (timer - ms);
		ms = timer;
    }
}