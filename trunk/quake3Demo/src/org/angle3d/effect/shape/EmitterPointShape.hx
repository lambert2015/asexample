package org.angle3d.effect.shape;
import flash.geom.Vector3D;
import org.angle3d.math.Vector3f;

/**
 * ...
 * @author andy
 */

class EmitterPointShape implements EmitterShape
{
	private var point:Vector3f;

	public function new(point:Vector3f = null)
	{
		this.point = new Vector3f();
		
		if (point != null)
		    this.point.copyFrom(point);
	}
	
	public function getPoint():Vector3f
	{
        return point;
    }

    public function setPoint(point:Vector3f):Void
	{
        this.point.copyFrom(point);
    }
	
	//TODO 可能需要使用可以使用随机种子的随机函数
	public function getRandomPoint(store:Vector3f):Void
	{
		store.copyFrom(point);
	}
	
	public function getRandomPointAndNormal(store:Vector3f, normal:Vector3f):Void
	{
		store.copyFrom(point);
	}
	
	public function deepClone():EmitterShape
	{
		return new EmitterPointShape(point);
	}
	
}