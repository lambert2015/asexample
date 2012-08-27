package three.core;

/**
 * ...
 * @author andy
 */

class Clock 
{
	public var autoStart:Bool;
	
	public var startTime:Float;
	
	public var oldTime:Float;
	public var elapsedTime:Float;
	
	public var running:Bool;

	public function new(autoStart:Bool=true) 
	{
		this.autoStart = autoStart;

		this.startTime = 0;
		this.oldTime = 0;
		this.elapsedTime = 0;

		this.running = false;
	}
	
	public function start():Void
	{
		this.startTime = Date.now().getTime();
		this.oldTime = this.startTime;
		this.running = true;
	}

	public function stop():Void 
	{
		this.getElapsedTime();
		this.running = false;
	}

	public function getElapsedTime():Float 
	{
		this.elapsedTime += this.getDelta();
		return this.elapsedTime;
	}

	public function getDelta():Float
	{
		var diff:Float = 0;

		if (this.autoStart && !this.running) 
		{
			this.start();
		}

		if (this.running) 
		{
			var newTime = Date.now().getTime();
			diff = 0.001 * (newTime - this.oldTime );
			this.oldTime = newTime;

			this.elapsedTime += diff;

		}
		return diff;
	}
}