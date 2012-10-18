package org.angle3d.renderer;
import org.angle3d.material.BlendMode;
import org.angle3d.material.FaceCullMode;

/**
 * Represents the current state of the graphics library. This class is used
 * internally to reduce state changes.
 */
class RenderContext 
{
	/**
     * If back-face culling is enabled.
     */
	public var cullMode:Int;
	
	/**
     * If Depth testing is enabled.
     */
	public var depthTestEnabled:Bool;
	
	public var depthWriteEnabled:Bool;

    public var colorWriteEnabled:Bool;

    public var clipRectEnabled:Bool;

	public var blendMode:Int;

	public function new() 
	{
		reset();
	}
	
	public function reset():Void
	{
		cullMode = FaceCullMode.Off;
        depthTestEnabled = false;
		depthWriteEnabled = false;
        colorWriteEnabled = false;
        clipRectEnabled = false;
        blendMode = BlendMode.Off;
	}
	
}