package org.angle3d.collision.bih
{
	import org.angle3d.bounding.BoundingBox;
	import org.angle3d.bounding.BoundingSphere;
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.error.UnsupportedCollisionException;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Ray;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.CollisionData;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;
	import org.angle3d.utils.TempVars;

	/**
	 * ...
	 * @author andy
	 */

	public class BIHTree implements CollisionData
	{
		public static const MAX_TREE_DEPTH:int = 100;
		public static const MAX_TRIS_PER_NODE:int = 21;

		private var root:BIHNode;

		private var numTris:int;
		private var maxTrisPerNode:int;

		private var subMesh:SubMesh;

		private var pointData:Vector.<Number>;
		private var triIndices:Vector.<int>;

		private var boundResults:CollisionResults = new CollisionResults();
		private var bihSwapTmp:Vector.<Number>;

		public function BIHTree(subMesh:SubMesh, maxTrisPerNode:int = 100)
		{
			this.subMesh = subMesh;
			this.maxTrisPerNode = maxTrisPerNode;

			if (maxTrisPerNode < 1 || subMesh == null)
			{
				throw new Error("illegal argument");
			}

			bihSwapTmp = new Vector.<Number>(9, true);

			var vertices:Vector.<Number> = subMesh.getVertexBuffer(BufferType.POSITION).getData();
			var indices:Vector.<uint> = subMesh.getIndices();

			numTris = indices.length / 3;
			initTriList(vertices, indices);
		}

		private function initTriList(vertices:Vector.<Number>, indices:Vector.<uint>):void
		{
			pointData = new Vector.<Number>(numTris * 3 * 3);
			var p:int = 0;
			var count:int = numTris * 3;
			for (var i:int = 0; i < count; i += 3)
			{
				var vert:int = indices[i] * 3;

				pointData[p++] = vertices[vert++];
				pointData[p++] = vertices[vert++];
				pointData[p++] = vertices[vert];


				vert = indices[i + 1] * 3;
				pointData[p++] = vertices[vert++];
				pointData[p++] = vertices[vert++];
				pointData[p++] = vertices[vert];

				vert = indices[i + 2] * 3;
				pointData[p++] = vertices[vert++];
				pointData[p++] = vertices[vert++];
				pointData[p++] = vertices[vert];

			}

			triIndices = new Vector.<int>(numTris);
			for (i = 0; i < numTris; i++)
			{
				triIndices[i] = i;
			}
		}

		public function construct():void
		{
			var sceneBbox:BoundingBox = createBox(0, numTris - 1);
			root = createNode(0, numTris - 1, sceneBbox, 0);
		}

		private function createBox(l:int, r:int):BoundingBox
		{
			var vars:TempVars = TempVars.getTempVars();

			var min:Vector3f = vars.vect1.copyFrom(new Vector3f(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY));
			var max:Vector3f = vars.vect2.copyFrom(new Vector3f(Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.NEGATIVE_INFINITY));

			var v1:Vector3f = vars.vect3;
			var v2:Vector3f = vars.vect4;
			var v3:Vector3f = vars.vect5;

			for (var i:int = l; i <= r; i++)
			{
				getTriangle(i, v1, v2, v3);
				Vector3f.checkMinMax(min, max, v1);
				Vector3f.checkMinMax(min, max, v2);
				Vector3f.checkMinMax(min, max, v3);
			}

			var bbox:BoundingBox = new BoundingBox();
			bbox.setMinMax(min, max);

			vars.release();

			return bbox;
		}

		public function getTriangleIndex(triIndex:int):int
		{
			return triIndices[triIndex];
		}

		private function sortTriangles(l:int, r:int, split:Number, axis:int):int
		{
			var pivot:int = l;
			var j:int = r;

			var vars:TempVars = TempVars.getTempVars();

			var v1:Vector3f = vars.vect1;
			var v2:Vector3f = vars.vect2;
			var v3:Vector3f = vars.vect3;

			while (pivot <= j)
			{
				getTriangle(pivot, v1, v2, v3);
				v1.addLocal(v2).addLocal(v3).scaleLocal(FastMath.ONE_THIRD);
				if (v1.getValueAt(axis) > split)
				{
					swapTriangles(pivot, j);
					--j;
				}
				else
				{
					++pivot;
				}
			}

			vars.release();
			pivot = (pivot == l && j < pivot) ? j : pivot;
			return pivot;
		}

		private function setMinMax(bbox:BoundingBox, doMin:Boolean, axis:int, value:Number):void
		{
			var min:Vector3f = bbox.getMin(null);
			var max:Vector3f = bbox.getMax(null);

			if (doMin)
			{
				min.setValueAt(axis, value);
			}
			else
			{
				max.setValueAt(axis, value);
			}

			bbox.setMinMax(min, max);
		}

		private function getMinMax(bbox:BoundingBox, doMin:Boolean, axis:int):Number
		{
			if (doMin)
			{
				return bbox.getMin(null).getValueAt(axis);
			}
			else
			{
				return bbox.getMax(null).getValueAt(axis);
			}
		}

		private function createNode(l:int, r:int, nodeBbox:BoundingBox, depth:int):BIHNode
		{
			if ((r - l) < maxTrisPerNode || depth > MAX_TREE_DEPTH)
			{
				return new BIHNode(l, r);
			}

			var currentBox:BoundingBox = createBox(l, r);

			var exteriorExt:Vector3f = nodeBbox.getExtent(null);
			var interiorExt:Vector3f = currentBox.getExtent(null);
			exteriorExt.subtractLocal(interiorExt);

			var axis:int = 0;
			if (exteriorExt.x > exteriorExt.y)
			{
				if (exteriorExt.x > exteriorExt.z)
				{
					axis = 0;
				}
				else
				{
					axis = 2;
				}
			}
			else
			{
				if (exteriorExt.y > exteriorExt.z)
				{
					axis = 1;
				}
				else
				{
					axis = 2;
				}
			}

			if (exteriorExt.isZero())
			{
				axis = 0;
			}

//        Arrays.sort(tris, l, r, comparators[axis]);
			var split:Number = currentBox.getCenter().getValueAt(axis);
			var pivot:int = sortTriangles(l, r, split, axis);
			if (pivot == l || pivot == r)
			{
				pivot = (r + l) / 2;
			}

			var lbbox:BoundingBox;
			var rbbox:BoundingBox;
			//If one of the partitions is empty, continue with recursion: same level but different bbox
			if (pivot < l)
			{
				//Only right
				rbbox = currentBox.clone() as BoundingBox;
				setMinMax(rbbox, true, axis, split);
				return createNode(l, r, rbbox, depth + 1);
			}
			else if (pivot > r)
			{
				//Only left
				lbbox = currentBox.clone() as BoundingBox;
				setMinMax(lbbox, false, axis, split);
				return createNode(l, r, lbbox, depth + 1);
			}
			else
			{
				//Build the node
				var node:BIHNode = new BIHNode(-1, -1);
				node.axis = axis;

				//Left child
				lbbox = currentBox.clone() as BoundingBox;
				setMinMax(lbbox, false, axis, split);

				//The left node right border is the plane most right
				node.leftPlane = getMinMax(createBox(l, Math.max(l, pivot - 1)), false, axis);
				node.left = createNode(l, Math.max(l, pivot - 1), lbbox, depth + 1); //Recursive call

				//Right Child
				rbbox = currentBox.clone() as BoundingBox;
				setMinMax(rbbox, true, axis, split);
				//The right node left border is the plane most left
				node.rightPlane = getMinMax(createBox(pivot, r), true, axis);
				node.right = createNode(pivot, r, rbbox, depth + 1); //Recursive call

				return node;
			}
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

		public function swapTriangles(index1:int, index2:int):void
		{
			var p1:int = index1 * 9;
			var p2:int = index2 * 9;


			var i:int;

			// store p1 in tmp
			for (i = 0; i < 9; i++)
			{
				bihSwapTmp[i] = pointData[p1 + i];
			}

			// copy p2 to p1
			for (i = 0; i < 9; i++)
			{
				pointData[p1 + i] = pointData[p2 + i];
			}

			// copy tmp to p2
			for (i = 0; i < 9; i++)
			{
				pointData[p2 + i] = bihSwapTmp[i];
			}

			// swap indices
			var tmp2:int = triIndices[index1];
			triIndices[index1] = triIndices[index2];
			triIndices[index2] = tmp2;
		}

		private function collideWithRay(r:Ray,
			worldMatrix:Matrix4f,
			worldBound:BoundingVolume,
			results:CollisionResults):int
		{
			boundResults.clear();
			worldBound.collideWith(r, boundResults);
			if (boundResults.size > 0)
			{
				var tMin:Number = boundResults.getClosestCollision().distance;
				var tMax:Number = boundResults.getFarthestCollision().distance;

				if (tMax <= 0)
				{
					tMax = Number.POSITIVE_INFINITY;
				}
				else if (tMin == tMax)
				{
					tMin = 0;
				}

				if (tMin <= 0)
				{
					tMin = 0;
				}

				if (r.getLimit() < Number.POSITIVE_INFINITY)
				{
					tMax = Math.min(tMax, r.getLimit());
					if (tMin > tMax)
					{
						return 0;
					}
				}

				//            return root.intersectBrute(r, worldMatrix, this, tMin, tMax, results);
				return root.intersectWhere2(r, worldMatrix, this, tMin, tMax, results);
			}
			return 0;
		}

		private function collideWithBoundingVolume(bv:BoundingVolume,
			worldMatrix:Matrix4f,
			results:CollisionResults):int
		{
			var bbox:BoundingBox;
			if (bv is BoundingSphere)
			{
				var sphere:BoundingSphere = bv as BoundingSphere;
				bbox = new BoundingBox(bv.center.clone());
				bbox.setExtent(sphere.radius, sphere.radius, sphere.radius);
			}
			else if (bv is BoundingBox)
			{
				bbox = bv.clone() as BoundingBox;
			}
			else
			{
				throw new UnsupportedCollisionException();
			}

			bbox.transformByMatrix(worldMatrix.invert(), bbox);
			return root.intersectWhere(bv, bbox, worldMatrix, this, results);
		}

		public function collideWith(other:Collidable,
			worldMatrix:Matrix4f,
			worldBound:BoundingVolume,
			results:CollisionResults):int
		{
			if (other is Ray)
			{
				var ray:Ray = other as Ray;
				return collideWithRay(ray, worldMatrix, worldBound, results);
			}
			else if (other is BoundingVolume)
			{
				var bv:BoundingVolume = other as BoundingVolume;
				return collideWithBoundingVolume(bv, worldMatrix, results);
			}
			else
			{
				throw new UnsupportedCollisionException();
			}
		}
	}
}

