package org.angle3d.scene.shape;

import flash.Lib;
import org.angle3d.renderer.queue.NullComparator;
import org.angle3d.scene.mesh.BufferType;
import org.angle3d.scene.mesh.Mesh;

class WireframeUtil
{
		/**
		 * 生成Wireframe模型
		 */
	public static function generateWireframe(mesh : Mesh) : WireframeShape
	{
		if (mesh == null || mesh.getVertexBuffer(BufferType.Position) == null ||
			mesh.getIndexBuffer() == null)
		{
			return null;
		}

		if (Std.is(mesh,WireframeShape))
		{
			return Lib.as(mesh,WireframeShape);
		}

		var vertices : Vector<Float> = mesh.getVertexBuffer(BufferType.Position).getData();
		var indices : Vector<UInt> = mesh.getIndexBuffer().getData();

		var shape : WireframeShape = new WireframeShape();

		var p0x : Float, p0y : Float, p0z : Float;
		var p1x : Float, p1y : Float, p1z : Float;
		var p2x : Float, p2y : Float, p2z : Float;
		var count : Int = Std.int(indices.length / 3);
		for (i in 0...count)
		{
			var i0 : UInt = indices[i * 3] * 3;
			p0x = vertices[i0];
			p0y = vertices[i0 + 1];
			p0z = vertices[i0 + 2];

			var i1 : UInt = indices[i * 3 + 1] * 3;
			p1x = vertices[i1];
			p1y = vertices[i1 + 1];
			p1z = vertices[i1 + 2];

			var i2 : UInt = indices[i * 3 + 2] * 3;
			p2x = vertices[i2];
			p2y = vertices[i2 + 1];
			p2z = vertices[i2 + 2];

			shape.addSegment(new LineSet(p0x, p0y, p0z, p1x, p1y, p1z));
			shape.addSegment(new LineSet(p1x, p1y, p1z, p2x, p2y, p2z));
			shape.addSegment(new LineSet(p2x, p2y, p2z, p0x, p0y, p0z));
		}

		shape.build();

		return shape;
	}
}

