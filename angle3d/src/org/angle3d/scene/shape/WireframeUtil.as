package org.angle3d.scene.shape
{
	import org.angle3d.renderer.queue.NullComparator;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;

	public class WireframeUtil
	{
		/**
		 * 生成Wireframe模型
		 */
		public static function generateWireframe(mesh:Mesh):WireframeShape
		{
			if (mesh is WireframeShape)
			{
				return mesh as WireframeShape;
			}

			var shape:WireframeShape=new WireframeShape();

			var subMeshList:Vector.<SubMesh>=mesh.subMeshList;
			for (var i:int=0, length:int=subMeshList.length; i < length; i++)
			{
				var subMesh:SubMesh=subMeshList[i];

				if (subMesh.getVertexBuffer(BufferType.POSITION) == null || subMesh.getIndices() == null)
				{
					return null;
				}

				var vertices:Vector.<Number>=subMesh.getVertexBuffer(BufferType.POSITION).getData();
				var indices:Vector.<uint>=subMesh.getIndices();

				var p0x:Number, p0y:Number, p0z:Number;
				var p1x:Number, p1y:Number, p1z:Number;
				var p2x:Number, p2y:Number, p2z:Number;
				var count:int=int(indices.length / 3);
				for (var j:int=0; j < count; j++)
				{
					var j3:int=j * 3;
					var j0:uint=indices[j3] * 3;
					p0x=vertices[j0];
					p0y=vertices[j0 + 1];
					p0z=vertices[j0 + 2];

					var j1:uint=indices[j3 + 1] * 3;
					p1x=vertices[j1];
					p1y=vertices[j1 + 1];
					p1z=vertices[j1 + 2];

					var j2:uint=indices[j3 + 2] * 3;
					p2x=vertices[j2];
					p2y=vertices[j2 + 1];
					p2z=vertices[j2 + 2];

					shape.addSegment(new WireframeLineSet(p0x, p0y, p0z, p1x, p1y, p1z));
					shape.addSegment(new WireframeLineSet(p1x, p1y, p1z, p2x, p2y, p2z));
					shape.addSegment(new WireframeLineSet(p2x, p2y, p2z, p0x, p0y, p0z));
				}
			}
			shape.build();
			return shape;
		}

		/**
		 * 得到顶点法线，用于测试
		 */
		public static function generateNormalLineShape(mesh:Mesh, size:Number=5):WireframeShape
		{
			if (mesh is WireframeShape)
			{
				return null;
			}

			var shape:WireframeShape=new WireframeShape();

			var subMeshList:Vector.<SubMesh>=mesh.subMeshList;
			for (var i:int=0, length:int=subMeshList.length; i < length; i++)
			{
				var subMesh:SubMesh=subMeshList[i];
				if (subMesh.getVertexBuffer(BufferType.POSITION) == null || subMesh.getVertexBuffer(BufferType.NORMAL) == null)
				{
					return null;
				}

				var vertices:Vector.<Number>=subMesh.getVertexBuffer(BufferType.POSITION).getData();
				var normals:Vector.<Number>=subMesh.getVertexBuffer(BufferType.NORMAL).getData();

				var p0x:Number, p0y:Number, p0z:Number;
				var p1x:Number, p1y:Number, p1z:Number;
				var nx:Number, ny:Number, nz:Number;
				var count:int=int(vertices.length / 3);
				for (var j:int=0; j < count; j++)
				{
					var j3:int=j * 3;
					p0x=vertices[j3];
					p0y=vertices[j3 + 1];
					p0z=vertices[j3 + 2];

					nx=normals[j3];
					ny=normals[j3 + 1];
					nz=normals[j3 + 2];

					p1x=p0x + nx * size;
					p1y=p0y + ny * size;
					p1z=p0z + nz * size;

					shape.addSegment(new WireframeLineSet(p0x, p0y, p0z, p1x, p1y, p1z));
				}
			}
			shape.build();

			return shape;
		}
	}
}

