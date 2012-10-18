package quake3.core;
import flash.display3D.Context3D;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.errors.Error;
import flash.Vector;
import quake3.core.Vertex;
import quake3.material.Material;
import quake3.utils.IndexBufferCount;

/**
 * BSPGeometry
 * @author andy
 */

class BSPGeometry implements IGeometry
{
	public var material : Material;
	public var vertices : Vector<Vertex>;
	public var indices : Vector<UInt>;
	
	//渲染使用的
	private var renderVertices:Vector<Float>;
	private var renderVertexBuffer:VertexBuffer3D;
	private var renderIndexBuffer:IndexBuffer3D;
	
	private var _visible:Bool;
	public function new() 
	{
		vertices = new Vector<Vertex>();
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
	
	public function getMaterial():Material
	{
		return material;
	}
	
	public function uploadBuffers(context:Context3D):Void
	{
		uploadIndexBuffer(context);
		uploadVertexBuffer(context);
	}
	
	public function createVertexBuffer(context:Context3D):Void
	{
		if (renderVertexBuffer != null)
		{
			renderVertexBuffer.dispose();
			renderVertexBuffer = null;
		}
		renderVertices = new Vector<Float>();
    	var offset = 0;
    	for(i in 0...vertices.length)
    	{
        	var vert:Vertex = vertices[i];

        	renderVertices[offset++] = vert.x;
        	renderVertices[offset++] = vert.y;
        	renderVertices[offset++] = vert.z;

        	renderVertices[offset++] = vert.u;
        	renderVertices[offset++] = vert.v;

        	renderVertices[offset++] = vert.u2;
        	renderVertices[offset++] = vert.v2;

        	renderVertices[offset++] = vert.nx;
        	renderVertices[offset++] = vert.ny;
        	renderVertices[offset++] = vert.nz;

			
        	renderVertices[offset++] = vert.r;
        	renderVertices[offset++] = vert.g;
        	renderVertices[offset++] = vert.b;
        	renderVertices[offset++] = vert.a;
    	}
		renderVertices.fixed = true;
		renderVertexBuffer = context.createVertexBuffer(vertices.length, 14);
		vertices = null;
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
        if (renderVertexBuffer == null)
		{
			createVertexBuffer(context);
		}
		renderVertexBuffer.uploadFromVector(renderVertices, 0, Std.int(renderVertices.length/14));
	}
	
	public function getIndexBuffer():IndexBuffer3D
	{
		return renderIndexBuffer;
	}
	
	public function getVertexBuffer():VertexBuffer3D
	{
		return renderVertexBuffer;
	}

	//public function setAttribute(context:Context3D):Void
	//{
		//var buffer:VertexBuffer3D = renderVertexBuffer;
		//context.setVertexBufferAt(0, buffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		//context.setVertexBufferAt(1, buffer, 3, Context3DVertexBufferFormat.FLOAT_2);
		//context.setVertexBufferAt(2, buffer, 5, Context3DVertexBufferFormat.FLOAT_2);
		//context.setVertexBufferAt(3, buffer, 7, Context3DVertexBufferFormat.FLOAT_3);
		//context.setVertexBufferAt(4, buffer, 10, Context3DVertexBufferFormat.FLOAT_4);
	//}
	
	
}