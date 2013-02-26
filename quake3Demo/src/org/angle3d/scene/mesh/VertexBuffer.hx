package org.angle3d.scene.mesh;
import flash.Vector;
import org.angle3d.utils.Assert;


class VertexBuffer extends Buffer
{
	private var _data:Vector<Float>;
	
	private var _components:Int;
	
	public function new(type:String) 
	{
		super(type);
	}
	
	public function getComponents():Int
	{
		return _components;
	}
	
	/**
	 * 
	 * @param	data
	 * @param	components
	 */
	public function setData(data:Vector<Float>, components:Int):Void
	{
		_data = data;
		_components = components;
		_count = Std.int(_data.length / _components);
		
		setDirty();
		
		Assert.assert(_components >= 1 && _components <= 4, "_components长度应该在1～4之间");
	}
	
	public function updateData(data:Vector<Float>):Void
	{
		_data = data;
		
		setDirty();
		
		#if debug
		Assert.assert(Std.int(_data.length / _components) == _count, "更新的数组长度应该和之前相同");
		#end
	}
	
	public inline function getData():Vector<Float>
	{
		return _data;
	}
	
	override public function clean():Void
	{
		setDirty();
		_data = null;
	}
	
	/**
	 * 销毁
	 */
	override public function destroy():Void
	{
		_data = null;
	}
	
}