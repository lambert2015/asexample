package quake3.core;
import nme.display3D.Context3D;
import nme.display3D.IndexBuffer3D;
import quake3.material.Material;

interface IGeometry
{
	function isVisible():Bool;
	
	function setVisible(value:Bool):Void;
	
	function getMaterial():Material;
	
	function getIndexBuffer():IndexBuffer3D;
	
	function createIndexBuffer(context:Context3D):Void;

	function createVertexBuffer(context:Context3D):Void;

	/**
	 * 传数据给GPU
	 */
	function uploadIndexBuffer(context:Context3D):Void;
	
	function uploadVertexBuffer(context:Context3D):Void;
	
	function uploadBuffers(context:Context3D):Void;
	
	//function setAttribute(context:Context3D):Void;
}
