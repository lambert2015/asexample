package three.math;

/**
 * ...
 * @author 
 */

class Ray 
{
	public var origin:Vector3;
	public var direction:Vector3;
	public var near:Float;
	public var far:Float;

	public function new(origin:Vector3 = null, directin:Vector3 = null, near:Float = 0; far:Float = Math.POSITIVE_INFINITY )
	{
		this.origin = origin != null ? origin : new Vector3();
		this.direction = direction != null ? direction : new Vector3();
		this.near = near;
		this.far = far;
		
	}
	
}