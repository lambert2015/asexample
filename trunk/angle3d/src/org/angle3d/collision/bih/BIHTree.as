package org.angle3d.collision.bih
{
	import org.angle3d.bounding.BoundingBox;
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.CollisionData;
	import org.angle3d.scene.mesh.Mesh;

	/**
	 * ...
	 * @author andy
	 */

	public class BIHTree implements CollisionData
	{
		private var root:BIHNode;

		private var numTris:int;

		private var mesh:Mesh;

		public function BIHTree(mesh:Mesh)
		{
			this.mesh = mesh;
		}

		public function construct():void
		{
			//var sceneBbox:BoundingBox = createBox(0, numTris - 1);
			//root = createNode(0, numTris - 1, sceneBbox, 0);
		}

		public function collideWith(other:Collidable, worldMatrix:Matrix4f, worldBound:BoundingVolume, results:CollisionResults):int
		{
			return -1;
		}

		public function getTriangleIndex(index:int):int
		{
			return 0;
		}

		public function getTriangle(index:int, v1:Vector3f, v2:Vector3f, v3:Vector3f):void
		{
			var pointIndex:int = index * 9;

			v1.x = pointData[pointIndex++];
			v1.y = pointData[pointIndex++];
			v1.z = pointData[pointIndex++];

			v2.x = pointData[pointIndex++];
			v2.y = pointData[pointIndex++];
			v2.z = pointData[pointIndex++];

			v3.x = pointData[pointIndex++];
			v3.y = pointData[pointIndex++];
			v3.z = pointData[pointIndex++];
		}
	}
}

