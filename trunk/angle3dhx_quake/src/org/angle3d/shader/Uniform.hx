package org.angle3d.shader;

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

class Uniform extends ShaderVar
{
	private var _data:Vector<Float>;
	
	/**
     * Binding to a renderer value, or null if user-defined uniform
     */
    private var binding:UniformBinding;

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
	}
	
	public function setMatrix3(mat:Matrix3f):Void
	{
		_data = mat.toUniform(_data);
	}
	
	public function setColor(c:Color):Void
	{
		_data = c.toUniform(_data);
	}
	
	public function setVector3(vec:Vector3f):Void
	{
		_data = vec.toVector(_data);
	}
	
	public inline function getValue():Vector<Float>
	{
		return _data;
	}
	
	public inline function setBinding(binding:UniformBinding):Void
	{
        this.binding = binding;
    }

    public inline function getBinding():UniformBinding
	{
        return binding;
    }
}