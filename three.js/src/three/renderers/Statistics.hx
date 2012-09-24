package three.renderers;

/**
 * The statistics allow tracking of how data
 * per frame, such as number of objects rendered, number of triangles, etc.
 * These are updated when the Renderer's methods are used, make sure
 * to call {@link Statistics#clearFrame() } at the appropriate time
 * to get accurate info per frame.
 */
class Statistics 
{
	public var programs:Int;
	public var geometries:Int;
	public var textures:Int;
	
	public var calls:Int;
	public var vertices:Int;
	public var faces:Int;
	public var points:Int;

	public function new() 
	{
		reset();
	}
	
	public function reset():Void
	{
		programs = 0;
		geometries = 0;
		textures = 0;
		
		calls = 0;
		vertices = 0;
		faces = 0;
		points = 0;
	}
	
	public function resetRender():Void
	{
		calls = 0;
		vertices = 0;
		faces = 0;
		points = 0;
	}
	
}