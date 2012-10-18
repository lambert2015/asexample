package org.angle3d.collision.bin;
import org.angle3d.math.Vector3f;

/**
 * ...
 * @author andy
 */

class BIHTriangle 
{
    private var pointa:Vector3f;
	private var pointb:Vector3f;
	private var pointc:Vector3f;
	private var center:Vector3f;
	
	public function new(p1:Vector3f,p2:Vector3f,p3:Vector3f) 
	{
		pointa = p1.clone();
		pointb = p2.clone();
		pointc = p3.clone();
		center = new Vector3f();
		center.x = (pointa.x + pointb.x + pointc.x) / 3;
		center.y = (pointa.y + pointb.y + pointc.y) / 3;
		center.z = (pointa.z + pointb.z + pointc.z) / 3;
	}
	
	public function getPoint1():Vector3f
	{
		return pointa;
	}
	
	public function getPoint2():Vector3f
	{
		return pointb;
	}
	
	public function getPoint3():Vector3f
	{
		return pointc;
	}
	
}