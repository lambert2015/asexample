package quake3.core;
import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.errors.Error;
import flash.Vector;
import quake3.material.Material;
import quake3.utils.IndexBufferCount;

/**
 * ...
 * @author andy
 */

class SubGeometry  implements IGeometry
{
	private var parent:GroupGeometry;
	
	public var material : Material;
	public var indices : Vector<UInt>;
	
	//渲染使用的
	private var renderIndexBuffer:IndexBuffer3D;
	
	private var _visible:Bool;

	public function new() 
	{
		indices = new Vector<UInt>();
		material = new Material();
	}
	
	public function isVisible():Bool
	{
		return _visible;
	}
	
	public function setVisible(value:Bool):Void
	{
		_visible = value;
	}
	
	public function getIndexBuffer():IndexBuffer3D
	{
		return renderIndexBuffer;
	}
	
	public function getMaterial():Material
	{
		return material;
	}
	
	public function setParent(parent:GroupGeometry):Void
	{
		this.parent = parent;
	}
	
	public function getParent():GroupGeometry
	{
		return this.parent;
	}
	
	public function uploadBuffers(context:Context3D):Void
	{
	}
	
	public function createVertexBuffer(context:Context3D):Void
	{
	}
	
	public function createIndexBuffer(context:Context3D):Void
	{
		if (renderIndexBuffer != null)
		{
			renderIndexBuffer.dispose();
			renderIndexBuffer = null;
		}
		try {
			renderIndexBuffer = context.createIndexBuffer(indices.length);
			IndexBufferCount.COUNT++;
		}catch (e:Error)
		{
			throw new Error("createIndexBuffer超出了最大数量" + IndexBufferCount.COUNT);
		}
	}
	
	public function uploadIndexBuffer(context:Context3D):Void
	{
		if (renderIndexBuffer == null)
		{
			createIndexBuffer(context);
		}
		renderIndexBuffer.uploadFromVector(indices, 0, indices.length);
		indices = null;
	}
	
	public function uploadVertexBuffer(context:Context3D):Void
	{
	}
	
	public function setAttribute(context:Context3D):Void
	{
		//var buffer:VertexBuffer3D = getVertexBuffer();
		//context.setVertexBufferAt(0, buffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		//context.setVertexBufferAt(1, buffer, 3, Context3DVertexBufferFormat.FLOAT_2);
		//context.setVertexBufferAt(2, buffer, 5, Context3DVertexBufferFormat.FLOAT_2);
		//context.setVertexBufferAt(3, buffer, 7, Context3DVertexBufferFormat.FLOAT_3);
		//context.setVertexBufferAt(4, buffer, 10, Context3DVertexBufferFormat.FLOAT_4);
	}
}