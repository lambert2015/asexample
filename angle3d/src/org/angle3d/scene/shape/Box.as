package org.angle3d.scene.shape
{
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.mesh.BufferType;

	/**
	 * A box with solid (filled) faces.
	 *
	 * @author Mark Powell
	 */
//TODO 重构
	public class Box extends AbstractBox
	{
		private static var GEOMETRY_INDICES_DATA:Vector.<uint> = Vector.<uint>([2, 1, 0, 3, 2, 0, // back
			6, 5, 4, 7, 6, 4, // right
			10, 9, 8, 11, 10, 8, // front
			14, 13, 12, 15, 14, 12, // left
			18, 17, 16, 19, 18, 16, // top
			22, 21, 20, 23, 22, 20 // bottom
			]);

		private static var GEOMETRY_NORMALS_DATA:Vector.<Number> = Vector.<Number>([0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, // back
			1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, // right
			0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, // front
			-1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, // left
			0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, // top
			0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0 // bottom
			]);

		private static var GEOMETRY_COLORS_DATA:Vector.<Number> = Vector.<Number>([1.0, 0.5, 0.3, 1.0, 0.0, 0.0, 1.0, 0.1, 0.3, 1.0, 0.4, 0.2, // back
			0.0, 0.4, 1.0, 0.0, 0.1, 1.0, 0.0, 0.2, 1.0, 0.9, 0.5, 1.0, // right
			1.0, 0.8, 0.0, 1.0, 0.6, 0.0, 1.0, 0.0, 0.4, 1.0, 0.8, 0.0, // front
			0.2, 0.2, 1.0, 0.7, 0.7, 1.0, 0.2, 0.3, 1.0, 0.0, 0.2, 1.0, // left
			0.5, 1.0, 0.3, 0.1, 1.0, 0.6, 0.1, 1.0, 0.0, 0.0, 1.0, 0.1, // top
			0.0, 1.0, 0.8, 0.6, 1.0, 0.4, 0.3, 1.0, 0.5, 0.7, 1.0, 0.1 // bottom
			]);

		private static var GEOMETRY_TEXTURE_DATA:Vector.<Number> = Vector.<Number>([1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // back
			1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // right
			1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // front
			1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // left
			1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, // top
			1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0 // bottom
			]);

		/**
		 * Creates a new box.
		 * <p>
		 * The box has a center of 0,0,0 and extends in the out from the center by
		 * the given amount in <em>each</em> direction. So, for example, a box
		 * with extent of 0.5 would be the unit cube.
		 *
		 * @param name the name of the box.
		 * @param x the size of the box along the x axis, in both directions.
		 * @param y the size of the box along the y axis, in both directions.
		 * @param z the size of the box along the z axis, in both directions.
		 */
		public function Box(x:Number, y:Number, z:Number, center:Vector3f = null)
		{
			super();
			if (center == null)
			{
				center = new Vector3f(0, 0, 0);
			}
			updateGeometryByXYZ(center, x, y, z);
		}

		public function clone():Box
		{
			return new Box(xExtent, yExtent, zExtent, center);
		}

		override protected function duUpdateGeometryIndices():void
		{
			subMesh.setIndices(GEOMETRY_INDICES_DATA);
		}

		override protected function duUpdateGeometryColors():void
		{
			subMesh.setVertexBuffer(BufferType.COLOR, 3, GEOMETRY_COLORS_DATA);
		}

		override protected function duUpdateGeometryNormals():void
		{
			subMesh.setVertexBuffer(BufferType.NORMAL, 3, GEOMETRY_NORMALS_DATA);
		}

		override protected function duUpdateGeometryTextures():void
		{
			subMesh.setVertexBuffer(BufferType.TEXCOORD, 2, GEOMETRY_TEXTURE_DATA);
		}

		override protected function duUpdateGeometryVertices():void
		{
			var v:Vector.<Vector3f> = computeVertices();

			var vertices:Vector.<Number> = Vector.<Number>([v[0].x, v[0].y, v[0].z, v[1].x, v[1].y, v[1].z, v[2].x, v[2].y, v[2].z, v[3].x, v[3].y, v[3].z, // back
				v[1].x, v[1].y, v[1].z, v[4].x, v[4].y, v[4].z, v[6].x, v[6].y, v[6].z, v[2].x, v[2].y, v[2].z, // right
				v[4].x, v[4].y, v[4].z, v[5].x, v[5].y, v[5].z, v[7].x, v[7].y, v[7].z, v[6].x, v[6].y, v[6].z, // front
				v[5].x, v[5].y, v[5].z, v[0].x, v[0].y, v[0].z, v[3].x, v[3].y, v[3].z, v[7].x, v[7].y, v[7].z, // left
				v[2].x, v[2].y, v[2].z, v[6].x, v[6].y, v[6].z, v[7].x, v[7].y, v[7].z, v[3].x, v[3].y, v[3].z, // top
				v[0].x, v[0].y, v[0].z, v[5].x, v[5].y, v[5].z, v[4].x, v[4].y, v[4].z, v[1].x, v[1].y, v[1].z // bottom
				]);

			v = null;

			subMesh.setVertexBuffer(BufferType.POSITION, 3, vertices);

			subMesh.validate();
		}
	}
}

