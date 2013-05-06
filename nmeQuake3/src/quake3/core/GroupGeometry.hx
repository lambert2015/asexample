package quake3.core;
import nme.display3D.Context3D;
import nme.display3D.VertexBuffer3D;
import nme.Vector;
import quake3.core.Vertex;

/**
 * 一个VertexBuffer对应多个IndexBuffer和Material
 * @author andy
 */

class GroupGeometry
{
	public var vertices:Vector<Vertex>;
	public var geometrys:Vector<SubGeometry>;
	
	//渲染使用的
	private var renderVertices:Vector<Float>;
	private var renderVertexBuffer:VertexBuffer3D;
	public function new() 
	{
		vertices = new Vector<Vertex>();
		geometrys = new Vector<SubGeometry>();
	}
	
	public function addSubGeometry(geom:SubGeometry):Void
	{
		geometrys.push(geom);
		geom.setParent(this);
	}
	
	public function getVertexBuffer():VertexBuffer3D
	{
		return renderVertexBuffer;
	}
	
	public function uploadBuffers(context:Context3D):Void
	{
		uploadIndexBuffer(context);
		uploadVertexBuffer(context);
	}

	public function createVertexBuffer(context:Context3D):Void
	{
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
		var numGeom:Int = geometrys.length;
		for (i in 0...numGeom)
		{
			geometrys[i].createIndexBuffer(context);
		}
	}
	
	public function uploadIndexBuffer(context:Context3D):Void
	{
		var numGeom:Int = geometrys.length;
		for (i in 0...numGeom)
		{
			geometrys[i].uploadIndexBuffer(context);
		}
	}
	
	public function uploadVertexBuffer(context:Context3D):Void
	{
        if (renderVertexBuffer == null)
		{
			createVertexBuffer(context);
		}
		renderVertexBuffer.uploadFromVector(renderVertices, 0, Std.int(renderVertices.length/14));
	}
	
	//public function setAttribute(context:Context3D):Void
	//{
		//var buffer:VertexBuffer3D = getVertexBuffer();
		//context.setVertexBufferAt(0, buffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		//context.setVertexBufferAt(1, buffer, 3, Context3DVertexBufferFormat.FLOAT_2);
		//context.setVertexBufferAt(2, buffer, 5, Context3DVertexBufferFormat.FLOAT_2);
		//context.setVertexBufferAt(3, buffer, 7, Context3DVertexBufferFormat.FLOAT_3);
		//context.setVertexBufferAt(4, buffer, 10, Context3DVertexBufferFormat.FLOAT_4);
	//}
}