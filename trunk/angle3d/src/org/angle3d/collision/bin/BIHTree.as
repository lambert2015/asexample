package org.angle3d.collision.bin
{
	import org.angle3d.bounding.BoundingBox;
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.CollisionData;

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

		public function collideWith(other:Collidable,
			worldMatrix:Matrix4f,
			worldBound:BoundingVolume,
			results:CollisionResults):int
		{
			return -1;
		}
	}
}

