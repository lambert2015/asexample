package three.core;

/**
 * ...
 * @author andy
 */

class UV 
{
	public var u:Float;
	
	public var v:Float;

	public function new(u:Float = 0, v:Float = 0) 
	{
		this.u = u;
		this.v = v;
	}
	
	public function copy(value:UV):UV
	{
		this.u = value.u;
		this.v = value.v;
		
		return this;
	}
	
	public function clone():UV
	{
		return new UV(this.u, this.v);
	}
	
	public function setTo(u:Float, v:Float):UV
	{
		this.u = u;
		this.v = v;
		return this;
	}
	
	public function lerpSelf(uv:UV, interp:Float):UV
	{
		this.u += (uv.u - this.u) * interp;
		this.v += (uv.v - this.v) * interp;
		
		return this;
	}
	
}