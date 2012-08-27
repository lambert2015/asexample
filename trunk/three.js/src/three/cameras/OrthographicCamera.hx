package three.cameras;

/**
 * ...
 * @author andy
 */

class OrthographicCamera extends Camera
{
	public var left:Float;
	public var right:Float;
	public var top:Float;
	public var bottom:Float;
	public var near:Float;
	public var far:Float;
	public function new(left:Float, right:Float, top:Float, bottom:Float, near:Float = 0.1, far:Float = 2000)
	{
		super();
		
		this.left = left;
		this.right = right;
		this.top = top;
		this.bottom = bottom;

		this.near = near;
		this.far = far;

		this.updateProjectionMatrix();
	}
	
	public function updateProjectionMatrix():Void
	{
		this.projectionMatrix.makeOrthographic(this.left, this.right, this.top, this.bottom, this.near, this.far);
	}
	
}