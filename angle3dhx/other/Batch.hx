package org.angle3d.scene;

class Batch 
{
    public var geometry:Geometry;
	
	public var needMeshUpdate:Bool;
	
	public function new() 
	{
		needMeshUpdate = false;
	}
	
}