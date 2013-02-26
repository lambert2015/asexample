package org.angle3d.effect.shape;
import flash.geom.Vector3D;
import org.angle3d.math.Vector3f;

/**
 * ...
 * @author andy
 */

class EmitterBoxShape implements EmitterShape
{
	private var min:Vector3f;
	private var max:Vector3f;
	private var len:Vector3f;

	public function new(min:Vector3f,max:Vector3f) 
	{
		this.min = new Vector3f();
		this.min.copyFrom(min);
		
		this.max = new Vector3f();
		this.max.copyFrom(max);
		
		this.len = max.subtract(min);
	}
	
	//TODO 可能需要使用可以使用随机种子的随机函数
	public function getRandomPoint(store:Vector3f):Void
	{
		store.x = min.x + len.x * Math.random();
		store.y = min.y + len.y * Math.random();
		store.z = min.z + len.z * Math.random();
	}
	
	public function getRandomPointAndNormal(store:Vector3f, normal:Vector3f):Void
	{
		getRandomPoint(store);
	}
	
	public function deepClone():EmitterShape
	{
		return new EmitterBoxShape(min,max);
	}
	
}