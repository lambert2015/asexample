package org.angle3d.effect.shape;
import org.angle3d.math.Vector3f;

/**
 * ...
 * @author andy
 */

class EmitterSphereShape implements EmitterShape
{
	private var center:Vector3f;
	private var radius:Float;
	private var radiusSquared:Float;

	public function new(center:Vector3f, radius:Float ) 
	{
		this.center = new Vector3f();
		this.center.copyFrom(center);
		this.radius = radius;
		
		radiusSquared = radius * radius;
	}
	
	//TODO 可能需要使用可以使用随机种子的随机函数
	public function getRandomPoint(store:Vector3f):Void
	{
		do 
		{
            store.x = (Math.random() * 2 - 1) * radius;
            store.y = (Math.random() * 2 - 1) * radius;
            store.z = (Math.random() * 2 - 1) * radius;
        } 
		while (store.distanceSquared(center) > radiusSquared);
	}
	
	public function getRandomPointAndNormal(store:Vector3f, normal:Vector3f):Void
	{
		getRandomPoint(store);
	}
	
	public function deepClone():EmitterShape
	{
		return new EmitterSphereShape(center, radius);
	}
	
}