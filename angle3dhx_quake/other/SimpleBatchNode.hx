package org.angle3d.scene;
import flash.errors.Error;
import flash.geom.Transform;

/**
 * 
 * SimpleBatchNode  comes with some restrictions, but can yield better performances.
 * Geometries to be batched has to be attached directly to the BatchNode
 * You can't attach a Node to a SimpleBatchNode
 * SimpleBatchNode is recommended when you have a large number of geometries using the same material that does not require a complex scene graph structure.
 * @see BatchNode
 * @author Nehon
 */
class SimpleBatchNode extends BatchNode
{

	public function new(name:String) 
	{
		super(name);
	}
	
	override public function attachChild(child:Spatial):Void
	{
		if (!Std.is(child, Geometry))
		{
			throw new Error("BatchNode is BatchMode.Simple only support child of type Geometry, use BatchMode.Complex to use a complex structure");
		}
		
		super.attachChild(child);
	}
	
	override private function setTransformRefresh():Void 
	{
        refreshFlags |= RF_TRANSFORM;
        setBoundRefresh();
        for (batch in batches) 
		{
            batch.geometry.setTransformRefresh();
        }
    }
	
	private function getTransforms(geom:Geometry):Transform
	{
		return geom.getLocalTransform();
	}
	
	override public function batch():Void
	{
		doBatch();
	}
	
}