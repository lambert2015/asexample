package org.angle3d.scene.mesh;
import flash.Vector;
import org.angle3d.utils.Assert;


class IndexBuffer extends Buffer
{
	private var _data:Vector<UInt>;
	
	public function new() 
	{
		super(BufferType.Index);
	}
	
	public inline function getData():Vector<UInt>
	{
		return _data;
	}
	
	public function setData(data:Vector<UInt>):Void
	{
		_data = data;
		_count = _data.length;
		
		setDirty();
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
		setDirty();
	}
}