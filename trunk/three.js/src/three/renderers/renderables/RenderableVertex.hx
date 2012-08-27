package three.renderers.renderables;
import three.math.Vector3;
import three.math.Vector4;

/**
 * ...
 * @author 
 */

class RenderableVertex 
{
	public var positionWorld:Vector3;
	public var positionScreen:Vector4;
	
	public var visible:Bool;

	public function new() 
	{
		this.positionWorld = new Vector3();
		this.positionScreen = new Vector4();

		this.visible = true;
	}
	
	public function copy(vertex:RenderableVertex):Void
	{
		this.positionWorld.copy(vertex.positionWorld);
		this.positionScreen.copy(vertex.positionScreen);
	}
	
}