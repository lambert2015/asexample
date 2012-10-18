package org.angle3d.shader;
import flash.Lib;
import flash.Vector;
import org.angle3d.shader.Uniform;

class UniformList extends ShaderVarList
{
	private var _digits:Vector<Vector<Float>>;

	public function new() 
	{
		super();
		_digits = new Vector<Vector<Float>>();
	}
	
	public inline function setDigits(value:Vector<Vector<Float>>):Void
	{
		_digits = value;
	}
	
	public inline function getDigits():Vector<Vector<Float>>
	{
		return _digits;
	}
	
	public inline function getUniforms():Vector<ShaderVar>
	{
		return _variables;
	}
	
	public inline function getUniformAt(i:Int):Uniform
	{
		return Lib.as(_variables[i],Uniform);
	}
	
	/**
	 * 
	 */
	override public function arrange():Void
	{
		//需要偏移常数数组的长度
		var offset:Int = _digits != null ? _digits.length : 0;
		for (i in 0..._variables.length)
		{
			var sv:ShaderVar = _variables[i];
			
			sv.setLocation(offset);
			
			offset += sv.getSize();
		}
	}
}