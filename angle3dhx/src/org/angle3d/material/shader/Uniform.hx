package org.angle3d.material.shader;

import org.angle3d.math.Vector3f;
import flash.Vector;
import org.angle3d.math.Color;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Matrix4f;
import org.angle3d.math.VectorUtil;

/**
 * ...
 * @author 
 */
//TODO 需要判断_data长度
class Uniform extends ShaderVar
{
	private var _data:Vector<Float>;
	
	/**
     * Binding to a renderer value, or null if user-defined uniform
     */
    private var binding:Int;

	public function new(name:String,size:Int) 
	{
		super(name, size);
		
		_data = new Vector<Float>();
	}
	
	override public function getSize():Int
	{
        return Std.int(size / 4);
    }
	
	public function setVector(data:Vector<Float>):Void
	{
		_data = data;
	}
	
	public function setMatrix4(mat:Matrix4f):Void
	{
		_data = mat.toUniform(_data);
		if (_data.length > 16)
		{
			_data.length = 16;
		}
	}
	
	public function setMatrix3(mat:Matrix3f):Void
	{
		_data = mat.toUniform(_data);
		if (_data.length > 12)
		{
			_data.length = 12;
		}
	}
	
	public function setColor(c:Color):Void
	{
		_data = c.toUniform(_data);
		if (_data.length > 4)
		{
			_data.length = 4;
		}
	}
	
	public function setFloat(value:Float):Void
	{
		if (_data == null)
		{
			_data = new Vector<Float>(4);
		}
		_data.length = 4;
		_data[0] = value;
	}
	
	public function setVector3(vec:Vector3f):Void
	{
		_data = vec.toVector(_data);
		if (_data.length > 4)
		{
			_data.length = 4;
		}
	}
	
	public inline function getValue():Vector<Float>
	{
		return _data;
	}
	
	public inline function setBinding(binding:Int):Void
	{
        this.binding = binding;
    }

    public inline function getBinding():Int
	{
        return binding;
    }
}