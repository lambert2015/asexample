package org.angle3d.renderer.queue;
import org.angle3d.material.Material;
import org.angle3d.math.FastMath;
import org.angle3d.renderer.Camera3D;
import org.angle3d.scene.Geometry;
import org.angle3d.math.Vector3f;

/**
 * <code>OpaqueComparator</code> sorts geometries front-to-back based
 * on their Z position.
 *
 * @author Kirill Vainer
 */
class OpaqueComparator implements GeometryComparator
{
    private var cam:Camera3D;
	private var tempVec:Vector3f;
	private var tempVec2:Vector3f;
	
	public function new()
	{
		tempVec = new Vector3f();
		tempVec2 = new Vector3f();
	}
	
	public function compare(o1:Geometry, o2:Geometry):Int
	{
		// use the same shader.
        // sort front-to-back then.
		var d1:Float = distanceToCam(o1);
		var d2:Float = distanceToCam(o2);
			
		if (d1 < d2)
		{
			return -1;
		}
		else if(d1 > d2)
		{
			return 1;
		}
		else 
		{
			return 0;
		}
	}
	
	//TODO 为什么要dot相机的方向？
	private function distanceToCam(spat:Geometry):Float
	{
		if (spat.queueDistance != Math.NEGATIVE_INFINITY)
		{
			return spat.queueDistance;
		}
		
		var camPosition:Vector3f = cam.getLocation();
		var viewVector:Vector3f = cam.getDirection(tempVec2);
		var spatPosition:Vector3f;
		if (spat.getWorldBound() != null)
		{
			spatPosition = spat.getWorldBound().getCenter();
		}
		else
		{
			spatPosition = spat.getWorldTranslation();
		}
		
		//tempVec = spatPosition.subtract(camPosition);
		tempVec.x = spatPosition.x - camPosition.x;
		tempVec.y = spatPosition.y - camPosition.y;
		tempVec.z = spatPosition.z - camPosition.z;
		
		spat.queueDistance = tempVec.dot(viewVector);
		
		return spat.queueDistance;
	}
	
	public function setCamera(cam:Camera3D):Void
	{
		this.cam = cam;
	}
	
}