package org.angle3d.collision.bin;

/**
 * Bounding Interval Hierarchy.
 * Based on:
 *
 * Instant Ray Tracing: The Bounding Interval Hierarchy
 * By Carsten Wächter and Alexander Keller
 */
class BIHNode 
{
	private var leftIndex:Int;
	private var rightIndex:Int;
	
	private var left:BIHNode;
	private var right:BIHNode;
	
	private var leftPlane:Float;
	private var rightPlane:Float;
	private var axis:Int;

	public function new(left:Int,right:Int) 
	{
		this.leftIndex = left;
		this.rightIndex = right;
		axis = 3;//indicates leaf
	}
	
	public function getLeftChild():BIHNode
	{
		return left;
	}
	
	public function setLeftChild(left:BIHNode):Void
	{
		this.left = left;
	}
	
	public function getLeftPlane():Float
	{
		return leftPlane;
	}
	
	public function setLeftPlane(leftPlane:Float):Void
	{
		this.leftPlane = leftPlane;
	}
	
	public function getRightChild():BIHNode
	{
		return right;
	}
	
	public function setRightChild(right:BIHNode):Void
	{
		this.right = right;
	}
	
	public function getRightPlane():Float
	{
		return rightPlane;
	}
	
	public function setRightPlane(rightPlane:Float):Void
	{
		this.rightPlane = rightPlane;
	}
}