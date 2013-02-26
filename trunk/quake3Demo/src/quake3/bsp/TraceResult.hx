package quake3.bsp;
import flash.geom.Vector3D;
import quake3.math.Plane3D;

class TraceResult 
{
    public var allSolid:Bool;
	public var startSolid:Bool;
	public var fraction:Float;
	public var endPos:Vector3D;
	public var plane:Plane3D;
	
	/**
	 * 
	 * @param	allSolid True if the line segment is completely enclosed in a solid volume
	 * @param	startSolid True if the line segment starts outside of a solid volume.
	 * @param	fraction How far along the line we got before we collided. 0.5 == 50%, 1.0 == 100%.
	 * @param	endPos The point of collision, in world space.
	 */
	public function new(allSolid:Bool = false, 
	                    startSolid:Bool = false,
	                    fraction:Float = 1.0,
	                    endPos:Vector3D=null) 
	{
		this.allSolid = allSolid;
		this.startSolid = startSolid;
		this.fraction = fraction;
		this.endPos = endPos != null ? endPos.clone() : new Vector3D();
		this.plane = null;
	}
	
}