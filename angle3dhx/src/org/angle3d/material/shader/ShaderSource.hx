package org.angle3d.material.shader;
import flash.utils.ByteArray;

/**
 * ...
 * @author andy
 */

class ShaderSource 
{
	public var vertex:ByteArray;
	public var fragment:ByteArray;

	public function new(vertex:ByteArray,fragment:ByteArray) 
	{
		this.vertex = vertex;
		this.fragment = fragment;
	}
	
}