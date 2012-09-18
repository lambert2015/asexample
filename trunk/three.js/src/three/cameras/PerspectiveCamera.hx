package three.cameras;
import three.math.MathUtil;
/**
 * ...
 * @author andy
 */

class PerspectiveCamera extends Camera
{
	public var fov:Float;
	public var aspect:Float;

	public function new(fov:Float = 50, aspect:Float = 1, near:Float = 0.1, far:Float = 2000 )
	{
		super();
		
		this.fov = fov;
		this.aspect = aspect;
		this.near = near;
		this.far = far;
		
		this.fullWidth = 0;
		this.fullHeight = 0;
		
		this.updateProjectionMatrix();
	}
	
	
	/**
	 * Uses Focal Length (in mm) to estimate and set FOV
	 * 35mm (fullframe) camera is used if frame size is not specified;
	 * Formula based on http://www.bobatkins.com/photography/technical/field_of_view.html
	 */

	public function setLens( focalLength:Float, frameHeight:Float = 24 ):Void
	{
		this.fov = 2 * Math.atan( frameHeight / ( focalLength * 2 ) ) * ( 180 / Math.PI );
		this.updateProjectionMatrix();
	}


	/**
	 * Sets an offset in a larger frustum. This is useful for multi-window or
	 * multi-monitor/multi-machine setups.
	 *
	 * For example, if you have 3x2 monitors and each monitor is 1920x1080 and
	 * the monitors are in grid like this
	 *
	 *   +---+---+---+
	 *   | A | B | C |
	 *   +---+---+---+
	 *   | D | E | F |
	 *   +---+---+---+
	 *
	 * then for each monitor you would call it like this
	 *
	 *   var w = 1920;
	 *   var h = 1080;
	 *   var fullWidth = w * 3;
	 *   var fullHeight = h * 2;
	 *
	 *   --A--
	 *   camera.setOffset( fullWidth, fullHeight, w * 0, h * 0, w, h );
	 *   --B--
	 *   camera.setOffset( fullWidth, fullHeight, w * 1, h * 0, w, h );
	 *   --C--
	 *   camera.setOffset( fullWidth, fullHeight, w * 2, h * 0, w, h );
	 *   --D--
	 *   camera.setOffset( fullWidth, fullHeight, w * 0, h * 1, w, h );
	 *   --E--
	 *   camera.setOffset( fullWidth, fullHeight, w * 1, h * 1, w, h );
	 *   --F--
	 *   camera.setOffset( fullWidth, fullHeight, w * 2, h * 1, w, h );
	 *
	 *   Note there is no reason monitors have to be the same size or in a grid.
	 */

	public var fullWidth:Float;
	public var fullHeight:Float;
	public var x:Float;
	public var y:Float;
	public var width:Int;
	public var height:Int;
	public function setViewOffset( fullWidth:Float, fullHeight:Float, x:Float, y:Float, width:Int, height:Int ):Void
	{
		this.fullWidth = fullWidth;
		this.fullHeight = fullHeight;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;

		this.updateProjectionMatrix();
	}

	public function updateProjectionMatrix():Void
	{
		if ( this.fullWidth > 0 ) 
		{
			var aspect = this.fullWidth / this.fullHeight;
			var top = Math.tan( this.fov * 0.5 * MathUtil.DEG2RAD ) * this.near;
			var bottom = -top;
			var left = aspect * bottom;
			var right = aspect * top;
			var width = Math.abs( right - left );
			var height = Math.abs( top - bottom );

			this.projectionMatrix.makeFrustum(
				left + this.x * width / this.fullWidth,
				left + ( this.x + this.width ) * width / this.fullWidth,
				top - ( this.y + this.height ) * height / this.fullHeight,
				top - this.y * height / this.fullHeight,
				this.near,
				this.far
			);

		} 
		else 
		{
			this.projectionMatrix.makePerspective( this.fov, this.aspect, this.near, this.far );
		}
	}

}