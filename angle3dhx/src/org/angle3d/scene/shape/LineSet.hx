package org.angle3d.scene.shape;
import org.angle3d.math.Color;
import org.angle3d.math.Vector3f;

/**
 * ...
 * @author andy
 */

class LineSet 
{
	public var sx:Float;
	public var sy:Float;
	public var sz:Float;
	
	public var ex:Float;
	public var ey:Float;
	public var ez:Float;

	public function new(sx:Float,sy:Float,sz:Float,ex:Float,ey:Float,ez:Float)
	{
		this.sx = sx;
		this.sy = sy;
		this.sz = sz;
		
		this.ex = ex;
		this.ey = ey;
		this.ez = ez;
	}
}