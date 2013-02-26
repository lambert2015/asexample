package org.angle3d.scene.debug;
import org.angle3d.math.Color;
import org.angle3d.math.Vector3f;

/**
 * ...
 * @author andy
 */

class LineSegment 
{
	public var start:Vector3f;
	public var end:Vector3f;
	public var startColor:UInt;
	public var endColor:UInt;
	public var thickness:Float;

	public function new(start:Vector3f, end:Vector3f, startColor:UInt, endColor:UInt, thickness:Float = 1.0)
	{
		this.start = start;
		this.end = end;
		this.startColor = startColor;
		this.endColor = endColor;
		this.thickness = thickness;
	}
	
}