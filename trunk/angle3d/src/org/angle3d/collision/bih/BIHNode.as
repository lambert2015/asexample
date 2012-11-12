package org.angle3d.collision.bih
{
	import org.angle3d.bounding.BoundingBox;
	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResult;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Ray;
	import org.angle3d.math.Triangle;
	import org.angle3d.math.Vector3f;
	import org.angle3d.utils.TempVars;

	/**
	 * Bounding Interval Hierarchy.
	 * Based on:
	 *
	 * Instant Ray Tracing: The Bounding Interval Hierarchy
	 * By Carsten Wächter and Alexander Keller
	 */
	public class BIHNode
	{
		public var leftIndex:int;
		public var rightIndex:int;

		public var left:BIHNode;
		public var right:BIHNode;

		public var leftPlane:Number;
		public var rightPlane:Number;
		public var axis:int;

		public function BIHNode(left:int, right:int)
		{
			this.leftIndex = left;
			this.rightIndex = right;
			axis = 3; //indicates leaf
		}

		public function intersectWhere(col:Collidable, box:BoundingBox, worldMatrix:Matrix4f,
			tree:BIHTree, results:CollisionResults):int
		{
			var vars:TempVars = TempVars.getTempVars();
			var stack:Vector.<BIHStackData> = vars.bihStack;
			stack.length = 0;

			var minExts:Vector.<Number> = Vector.<Number>([box.center.x - box.xExtent,
				box.center.y - box.yExtent,
				box.center.z - box.zExtent]);

			var maxExts:Vector.<Number> = Vector.<Number>([box.center.x + box.xExtent,
				box.center.y + box.yExtent,
				box.center.z + box.zExtent]);

			stack.push(new BIHStackData(this, 0, 0));

			var t:Triangle = new Triangle();
			var cols:int = 0;

			stackloop: while (stack.length > 0)
			{
				var node:BIHNode = stack.pop().node;

				while (node.axis != 3)
				{
					var a:int = node.axis;

					var maxExt:Number = maxExts[a];
					var minExt:Number = minExts[a];

					if (node.leftPlane < node.rightPlane)
					{
						// means there's a gap in the middle
						// if the box is in that gap, we stop there
						if (minExt > node.leftPlane &&
							maxExt < node.rightPlane)
						{
							continue stackloop;
						}
					}

					if (maxExt < node.rightPlane)
					{
						node = node.left;
					}
					else if (minExt > node.leftPlane)
					{
						node = node.right;
					}
					else
					{
						stack.push(new BIHStackData(node.right, 0, 0));
						node = node.left;
					}
						//                if (maxExt < node.leftPlane
						//                 && maxExt < node.rightPlane){
						//                    node = node.left;
						//                }else if (minExt > node.leftPlane
						//                       && minExt > node.rightPlane){
						//                    node = node.right;
						//                }else{

						//					//                }
				}

				for (var i:int = node.leftIndex; i <= node.rightIndex; i++)
				{
					tree.getTriangle(i, t.point1, t.point2, t.point3);
					if (worldMatrix != null)
					{
						worldMatrix.multVec(t.point1, t.point1);
						worldMatrix.multVec(t.point2, t.point2);
						worldMatrix.multVec(t.point3, t.point3);
					}

					var added:int = col.collideWith(t, results);

					if (added > 0)
					{
						var index:int = tree.getTriangleIndex(i);
						var start:int = results.size - added;

						for (var j:int = start; j < results.size; j++)
						{
							var cr:CollisionResult = results.getCollisionDirect(j);
							cr.triangleIndex = index;
						}

						cols += added;
					}
				}
			}
			vars.release();
			return cols;
		}

		public function intersectWhere2(r:Ray, worldMatrix:Matrix4f, tree:BIHTree,
			sceneMin:Number, sceneMax:Number,
			results:CollisionResults):int
		{

			var vars:TempVars = TempVars.getTempVars();
			var stack:Vector.<BIHStackData> = vars.bihStack;
			stack.length = 0;

			//        float tHit = Float.POSITIVE_INFINITY;

			var o:Vector3f = vars.vect1.copyFrom(r.origin);
			var d:Vector3f = vars.vect2.copyFrom(r.direction);

			var inv:Matrix4f = vars.tempMat4.copyFrom(worldMatrix).invertLocal();

			inv.multVec(r.origin, r.origin);

			// Fixes rotation collision bug
			inv.multNormal(r.direction, r.direction);
			//        inv.multNormalAcross(r.direction, r.direction);

			var origins:Vector.<Number> = Vector.<Number>([r.origin.x, r.origin.y, r.origin.z]);

			var invDirections:Vector.<Number> = Vector.<Number>([1 / r.direction.x, 1 / r.direction.y, 1 / r.direction.z]);

			r.direction.normalizeLocal();

			var v1:Vector3f = vars.vect3;
			var v2:Vector3f = vars.vect4;
			var v3:Vector3f = vars.vect5;
			var cols:int = 0;
			stack.push(new BIHStackData(this, sceneMin, sceneMax));

			stackloop: while (stack.length > 0)
			{
				var data:BIHStackData = stack.pop();
				var node:BIHNode = data.node;
				var tMin:Number = data.min;
				var tMax:Number = data.max;

				if (tMax < tMin)
				{
					continue;
				}

				leafloop: while (node.axis != 3)
				{
					//while node is not a leaf
					var a:int = node.axis;

					// find the origin and direction value for the given axis
					var origin:Number = origins[a];
					var invDirection:Number = invDirections[a];

					var tNearSplit:Number, tFarSplit:Number;
					var nearNode:BIHNode, farNode:BIHNode;

					tNearSplit = (node.leftPlane - origin) * invDirection;
					tFarSplit = (node.rightPlane - origin) * invDirection;
					nearNode = node.left;
					farNode = node.right;

					if (invDirection < 0)
					{
						var tmpSplit:Number = tNearSplit;
						tNearSplit = tFarSplit;
						tFarSplit = tmpSplit;

						var tmpNode:BIHNode = nearNode;
						nearNode = farNode;
						farNode = tmpNode;
					}

					if (tMin > tNearSplit && tMax < tFarSplit)
					{
						continue stackloop;
					}

					if (tMin > tNearSplit)
					{
						tMin = Math.max(tMin, tFarSplit);
						node = farNode;
					}
					else if (tMax < tFarSplit)
					{
						tMax = Math.min(tMax, tNearSplit);
						node = nearNode;
					}
					else
					{
						stack.push(new BIHStackData(farNode, Math.max(tMin, tFarSplit), tMax));
						tMax = Math.min(tMax, tNearSplit);
						node = nearNode;
					}
				}

//				if ((node.rightIndex - node.leftIndex) > minTrisPerNode)
//				{
				//                // on demand subdivision
				//                node.subdivide();
				//                stack.add(new BIHStackData(node, tMin, tMax));
				//                continue stackloop;
				//            }

				// a leaf
				for (var i:int = node.leftIndex; i <= node.rightIndex; i++)
				{
					tree.getTriangle(i, v1, v2, v3);

					var t:Number = r.intersects2(v1, v2, v3);
					if (isFinite(t))
					{
						if (worldMatrix != null)
						{
							worldMatrix.multVec(v1, v1);
							worldMatrix.multVec(v2, v2);
							worldMatrix.multVec(v3, v3);
							var t_world:Number = new Ray(o, d).intersects2(v1, v2, v3);
							t = t_world;
						}

						var contactNormal:Vector3f = Triangle.computeTriangleNormal(v1, v2, v3, null);
						var contactPoint:Vector3f = d.clone().scaleLocal(t).addLocal(o);
						var worldSpaceDist:Number = o.distance(contactPoint);

						var cr:CollisionResult = new CollisionResult();
						cr.contactPoint = contactPoint;
						cr.distance = worldSpaceDist;
						cr.contactNormal = contactNormal;
						cr.triangleIndex = tree.getTriangleIndex(i);
						results.addCollision(cr);
						cols++;
					}
				}
			}


			vars.release();
			r.setOrigin(o);
			r.setDirection(d);

			return cols;
		}

		public function intersectBrute(r:Ray, worldMatrix:Matrix4f, tree:BIHTree,
			sceneMin:Number, sceneMax:Number,
			results:CollisionResults):int
		{
			var tHit:Number = Number.POSITIVE_INFINITY;

			var vars:TempVars = TempVars.getTempVars();

			var v1:Vector3f = vars.vect1;
			var v2:Vector3f = vars.vect2;
			var v3:Vector3f = vars.vect3;

			var cols:int = 0;

			var stack:Vector.<BIHStackData> = vars.bihStack;
			stack.length = 0;
			stack.push(new BIHStackData(this, 0, 0));

			stackloop: while (stack.length > 0)
			{
				var data:BIHStackData = stack.pop();
				var node:BIHNode = data.node;

				leafloop: while (node.axis != 3)
				{
					//whilenode is not a leaf
					var nearNode:BIHNode, farNode:BIHNode;
					nearNode = node.left;
					farNode = node.right;

					stack.push(new BIHStackData(farNode, 0, 0));
					node = nearNode;
				}

				//a leaf
				for (var i:int = node.leftIndex; i <= node.rightIndex; i++)
				{
					tree.getTriangle(i, v1, v2, v3);

					if (worldMatrix != null)
					{
						worldMatrix.multVec(v1, v1);
						worldMatrix.multVec(v2, v2);
						worldMatrix.multVec(v3, v3);
					}

					var t:Number = r.intersects2(v1, v2, v3);
					if (t < tHit)
					{
						tHit = t;
						var contactPoint:Vector3f = r.direction.clone().scaleLocal(tHit).addLocal(r.origin);
						var cr:CollisionResult = new CollisionResult();
						cr.contactPoint = contactPoint;
						cr.distance = tHit;
						cr.triangleIndex = tree.getTriangleIndex(i);
						results.addCollision(cr);
						cols++;
					}
				}
			}

			vars.release();
			return cols;
		}
	}
}

