package org.angle3d.bounding
{

	import org.angle3d.collision.Collidable;
	import org.angle3d.collision.CollisionResult;
	import org.angle3d.collision.CollisionResults;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Plane;
	import org.angle3d.math.PlaneSide;
	import org.angle3d.math.Ray;
	import org.angle3d.math.Transform;
	import org.angle3d.math.Triangle;
	import org.angle3d.math.Vector3f;

	/**
	 * <code>BoundingSphere</code> defines a sphere that defines a container for a
	 * group of vertices of a particular piece of geometry. This sphere defines a
	 * radius and a center. <br>
	 * <br>
	 * A typical usage is to allow the public class define the center and radius by calling
	 * either <code>containAABB</code> or <code>averagePoints</code>. A call to
	 * <code>computeFramePoint</code> in turn calls <code>containAABB</code>.
	 *
	 */

	public class BoundingSphere extends BoundingVolume
	{
		public var radius:Number;

		private static var RADIUS_EPSILON:Number = 1.00001;

		/**
		 * Constructor instantiates a new <code>BoundingSphere</code> object.
		 *
		 * @param r
		 *            the radius of the sphere.
		 * @param c
		 *            the center of the sphere.
		 */
		public function BoundingSphere(r:Number = 0, center:Vector3f = null)
		{
			super(center);
			this.radius = r;
		}

		override public function get type():int
		{
			return BoundingVolumeType.Sphere;
		}

		/**
		 * <code>computeFromPoints</code> creates a new Bounding Sphere from a
		 * given set of points. It uses the <code>calcWelzl</code> method as
		 * default.
		 *
		 * @param points
		 *            the points to contain.
		 */
		override public function computeFromPoints(points:Vector.<Number>):void
		{
			calcWelzl(points);
		}

		/**
		 * <code>computeFromTris</code> creates a new Bounding Box from a given
		 * set of triangles. It is used in OBBTree calculations.
		 *
		 * @param tris
		 * @param start
		 * @param end
		 */
		public function computeFromTris(tris:Vector.<Triangle>, start:int, end:int):void
		{
			if (end - start <= 0)
			{
				return;
			}

			var vertList:Vector.<Vector3f> = new Vector.<Vector3f>((end - start) * 3);
			var count:int = 0;
			for (var i:int = start; i < end; i++)
			{
				vertList[count++] = tris[i].point1
				vertList[count++] = tris[i].point2
				vertList[count++] = tris[i].point3;
			}
			averagePoints(vertList);
		}

		/**
		 * Calculates a minimum bounding sphere for the set of points. The algorithm
		 * was originally found at
		 * http://www.flipcode.com/cgi-bin/msg.cgi?showThread=COTD-SmallestEnclosingSpheres&forum=cotd&id=-1
		 * in C++ and translated to java by Cep21
		 *
		 * @param points
		 *            The points to calculate the minimum bounds from.
		 */
		public function calcWelzl(points:Vector.<Number>):void
		{
			if (center == null)
				center = new Vector3f();
			//NumberBuffer buf = BufferUtils.createNumberBuffer(points.limit());
			//points.rewind();
			//buf.put(points);
			//buf.flip();
			//recurseMini(buf, buf.limit() / 3, 0, 0);
		}

		/**
		 * Used from calcWelzl. This function recurses to calculate a minimum
		 * bounding sphere a few points at a time.
		 *
		 * @param points
		 *            The array of points to look through.
		 * @param p
		 *            The size of the list to be used.
		 * @param b
		 *            The number of points currently considering to include with the
		 *            sphere.
		 * @param ap
		 *            A variable simulating pointer arithmatic from C++, and offset
		 *            in <code>points</code>.
		 */
		private function recurseMini(points:Vector.<Number>, p:int, b:int, ap:int):void
		{
			//TempVars vars = TempVars.get();
			//assert vars.lock();
			//Vector3f tempA = vars.vect1;
			//Vector3f tempB = vars.vect2;
			//Vector3f tempC = vars.vect3;
			//Vector3f tempD = vars.vect4;
//
			//switch (b) {
			//case 0:
			//this.radius = 0;
			//this.center.set(0, 0, 0);
			//break;
			//case 1:
			//this.radius = 1f - RADIUS_EPSILON;
			//BufferUtils.populateFromBuffer(center, points, ap-1);
			//break;
			//case 2:
			//BufferUtils.populateFromBuffer(tempA, points, ap-1);
			//BufferUtils.populateFromBuffer(tempB, points, ap-2);
			//setSphere(tempA, tempB);
			//break;
			//case 3:
			//BufferUtils.populateFromBuffer(tempA, points, ap-1);
			//BufferUtils.populateFromBuffer(tempB, points, ap-2);
			//BufferUtils.populateFromBuffer(tempC, points, ap-3);
			//setSphere(tempA, tempB, tempC);
			//break;
			//case 4:
			//BufferUtils.populateFromBuffer(tempA, points, ap-1);
			//BufferUtils.populateFromBuffer(tempB, points, ap-2);
			//BufferUtils.populateFromBuffer(tempC, points, ap-3);
			//BufferUtils.populateFromBuffer(tempD, points, ap-4);
			//setSphere(tempA, tempB, tempC, tempD);
			//assert vars.unlock();
			//return;
			//}
			//for (int i = 0; i < p; i++) {
			//BufferUtils.populateFromBuffer(tempA, points, i+ap);
			//if (tempA.distanceSquared(center) - (radius * radius) > RADIUS_EPSILON - 1f) {
			//for (int j = i; j > 0; j--) {
			//BufferUtils.populateFromBuffer(tempB, points, j + ap);
			//BufferUtils.populateFromBuffer(tempC, points, j - 1 + ap);
			//BufferUtils.setInBuffer(tempC, points, j + ap);
			//BufferUtils.setInBuffer(tempB, points, j - 1 + ap);
			//}
			//assert vars.unlock();
			//recurseMini(points, i, b + 1, ap + 1);
			//assert vars.lock();
			//}
			//}
			//assert vars.unlock();
		}


		/**
		 * Calculates the minimum bounding sphere of 4 points. Used in welzl's
		 * algorithm.
		 *
		 * @param O
		 *            The 1st point inside the sphere.
		 * @param A
		 *            The 2nd point inside the sphere.
		 * @param B
		 *            The 3rd point inside the sphere.
		 * @param C
		 *            The 4th point inside the sphere.
		 * @see #calcWelzl(java.nio.NumberBuffer)
		 */
		public function setSphereByFourPoints(D:Vector3f, A:Vector3f, B:Vector3f, C:Vector3f):void
		{
			var a:Vector3f = A.subtract(D);
			var b:Vector3f = B.subtract(D);
			var c:Vector3f = C.subtract(D);

			var Denominator:Number = 2.0 * (a.x * (b.y * c.z - c.y * b.z) - b.x * (a.y * c.z - c.y * a.z) + c.x * (a.y * b.z - b.y * a.z));
			if (Denominator == 0)
			{
				center.setTo(0, 0, 0);
				radius = 0;
			}
			else
			{
				var cca:Vector3f = c.cross(a);
				var bcc:Vector3f = b.cross(c);
				var t:Vector3f = a.cross(b);

				var aLenSqr:Number = a.lengthSquared;
				var bLenSqr:Number = b.lengthSquared;
				var cLenSqr:Number = c.lengthSquared;

				Denominator = 1 / Denominator;

				t.x = (t.x * cLenSqr + cca.x * bLenSqr + bcc.x * aLenSqr) * Denominator;
				t.y = (t.y * cLenSqr + cca.y * bLenSqr + bcc.y * aLenSqr) * Denominator;
				t.z = (t.z * cLenSqr + cca.z * bLenSqr + bcc.z * aLenSqr) * Denominator;

				//var t:Vector3f = a.cross(b).scaleBy(c.lengthSquared()).incrementBy(
				//c.cross(a).scaleBy(b.lengthSquared())).incrementBy(
				//b.cross(c).scaleBy(a.lengthSquared())).scaleBy(
				//1/Denominator);

				radius = t.length * RADIUS_EPSILON;
				center.x = D.x + t.x;
				center.y = D.y + t.y;
				center.z = D.z + t.z;
			}
		}

		/**
		 * Calculates the minimum bounding sphere of 3 points. Used in welzl's
		 * algorithm.
		 *
		 * @param O
		 *            The 1st point inside the sphere.
		 * @param A
		 *            The 2nd point inside the sphere.
		 * @param B
		 *            The 3rd point inside the sphere.
		 * @see #calcWelzl(java.nio.NumberBuffer)
		 */
		public function setSphereByThreePoints(D:Vector3f, A:Vector3f, B:Vector3f):void
		{
			var a:Vector3f = A.subtract(D);
			var b:Vector3f = B.subtract(D);
			var acrossB:Vector3f = a.subtract(b);

			var Denominator:Number = 2.0 * acrossB.dot(acrossB);

			if (Denominator == 0)
			{
				center.setTo(0, 0, 0);
				radius = 0;
			}
			else
			{
				var bca:Vector3f = b.cross(a);
				var bcaB:Vector3f = b.cross(acrossB);
				var t:Vector3f = acrossB.cross(a);

				var aLenSqr:Number = a.lengthSquared;
				var bLenSqr:Number = b.lengthSquared;

				Denominator = 1 / Denominator;

				t.x = (t.x * bLenSqr + bcaB.x * aLenSqr) * Denominator;
				t.y = (t.y * bLenSqr + bcaB.y * aLenSqr) * Denominator;
				t.z = (t.z * bLenSqr + bcaB.z * aLenSqr) * Denominator;

				radius = t.length * RADIUS_EPSILON;
				center.x = D.x + t.x;
				center.y = D.y + t.y;
				center.z = D.z + t.z;
			}
		}

		/**
		 * Calculates the minimum bounding sphere of 2 points. Used in welzl's
		 * algorithm.
		 *
		 * @param O
		 *            The 1st point inside the sphere.
		 * @param A
		 *            The 2nd point inside the sphere.
		 * @see #calcWelzl(java.nio.NumberBuffer)
		 */
		public function setSphereByTwoPoints(D:Vector3f, A:Vector3f):void
		{
			radius = Math.sqrt(((A.x - D.x) * (A.x - D.x) + (A.y - D.y) * (A.y - D.y) + (A.z - D.z) * (A.z - D.z)) / 4) + RADIUS_EPSILON - 1;

			center.lerp(D, A, 0.5);
		}

		/**
		 * <code>averagePoints</code> selects the sphere center to be the average
		 * of the points and the sphere radius to be the smallest value to enclose
		 * all points.
		 *
		 * @param points
		 *            the list of points to contain.
		 */
		public function averagePoints(points:Vector.<Vector3f>):void
		{
			trace("Bounding Sphere calculated using average points.");

			center.copyFrom(points[0]);

			var len:int = points.length;
			for (var i:int = 1; i < len; i++)
			{
				center.addLocal(points[i]);
			}

			var quantity:Number = 1.0 / points.length;
			center.scaleLocal(quantity);

			var maxRadiusSqr:Number = 0;
			len = points.length;
			for (i = 1; i < len; i++)
			{
				var diff:Vector3f = points[i].subtract(center);
				var radiusSqr:Number = diff.lengthSquared;
				if (radiusSqr > maxRadiusSqr)
				{
					maxRadiusSqr = radiusSqr;
				}
			}

			radius = Math.sqrt(maxRadiusSqr) + RADIUS_EPSILON - 1;
		}

		/**
		 * <code>transform</code> modifies the center of the sphere to reflect the
		 * change made via a rotation, translation and scale.
		 *
		 * @param rotate
		 *            the rotation change.
		 * @param translate
		 *            the translation change.
		 * @param scale
		 *            the size change.
		 * @param store
		 *            sphere to store result in
		 * @return BoundingVolume
		 * @return ref
		 */
		override public function transform(trans:Transform, result:BoundingVolume = null):BoundingVolume
		{
			var sphere:BoundingSphere;
			if (result == null || result.type != BoundingVolumeType.Sphere)
			{
				sphere = new BoundingSphere();
			}
			else
			{
				sphere = result as BoundingSphere;
			}

			center.multiply(trans.scale, sphere.center);
			trans.rotation.multiplyVector(sphere.center, sphere.center);
			sphere.center.addLocal(trans.translation);
			sphere.radius = FastMath.fabs(getMaxAxis(trans.scale) * radius) + RADIUS_EPSILON - 1;
			return sphere;
		}

		override public function transformByMatrix(trans:Matrix4f, result:BoundingVolume = null):BoundingVolume
		{
			var sphere:BoundingSphere;
			if (result == null || result.type != BoundingVolumeType.Sphere)
			{
				sphere = new BoundingSphere();
			}
			else
			{
				sphere = result as BoundingSphere;
			}

			trans.multVec(center, sphere.center);

			var axes:Vector3f = new Vector3f(1, 1, 1);

			trans.multVec(axes, axes);

			var ax:Number = getMaxAxis(axes);

			sphere.radius = FastMath.fabs(ax * radius) + RADIUS_EPSILON - 1;

			return sphere;
		}

		private function getMaxAxis(scale:Vector3f):Number
		{
			var x:Number = FastMath.fabs(scale.x);
			var y:Number = FastMath.fabs(scale.y);
			var z:Number = FastMath.fabs(scale.z);

			if (x >= y)
			{
				if (x >= z)
					return x;
				return z;
			}

			if (y >= z)
				return y;

			return z;
		}

		/**
		 * <code>whichSide</code> takes a plane (typically provided by a view
		 * frustum) to determine which side this bound is on.
		 *
		 * @param plane
		 *            the plane to check against.
		 * @return side
		 */
		override public function whichSide(plane:Plane):int
		{
			var distance:Number = plane.pseudoDistance(center);

			if (distance <= -radius)
			{
				return PlaneSide.Negative;
			}
			else if (distance >= radius)
			{
				return PlaneSide.Positive;
			}
			else
			{
				return PlaneSide.None;
			}
		}

		/**
		* <code>merge</code> combines this sphere with a second bounding sphere.
		* This new sphere contains both bounding spheres and is returned.
		*
		* @param volume
		*            the sphere to combine with this sphere.
		* @return a new sphere
		*/
		override public function merge(volume:BoundingVolume):BoundingVolume
		{
			switch (volume.type)
			{
				case BoundingVolumeType.AABB:
				{
					var box:BoundingBox = volume as BoundingBox;
					var radVect:Vector3f = box.getExtent();
					return merge2(radVect.length, box.center);
				}
				case BoundingVolumeType.Sphere:
				{
					var sphere:BoundingSphere = volume as BoundingSphere;
					return merge2(sphere.radius, sphere.center);
				}
				default:
					return null;
			}
		}

		override public function mergeLocal(volume:BoundingVolume):void
		{
			switch (volume.type)
			{
				case BoundingVolumeType.AABB:
					var box:BoundingBox = volume as BoundingBox;
					var radVect:Vector3f = box.getExtent();
					merge2(radVect.length, box.center, this);
					break;
				case BoundingVolumeType.Sphere:
					var sphere:BoundingSphere = volume as BoundingSphere;
					merge2(sphere.radius, sphere.center, this);
					break;
			}
		}

		public function merge2(temp_radius:Number, temp_center:Vector3f, result:BoundingSphere = null):BoundingSphere
		{
			if (result == null)
			{
				result = new BoundingSphere();
			}
			var diff:Vector3f = temp_center.subtract(center);
			var lengthSquared:Number = diff.lengthSquared;
			var radiusDiff:Number = temp_radius - radius;

			var fRDiffSqr:Number = radiusDiff * radiusDiff;

			if (fRDiffSqr >= lengthSquared)
			{
				if (radiusDiff <= 0.0)
				{
					return result;
				}

				result.center.copyFrom(temp_center);
				result.radius = temp_radius;
				return result;
			}

			var length:Number = Math.sqrt(lengthSquared);
			if (length > RADIUS_EPSILON)
			{
				var coeff:Number = (length + radiusDiff) / (2.0 * length);
				result.center.x = center.x + diff.x * coeff;
				result.center.y = center.y + diff.y * coeff;
				result.center.z = center.z + diff.z * coeff;
			}
			else
			{
				result.center.copyFrom(center);
			}

			result.radius = 0.5 * (length + radius + temp_radius);

			return result;
		}

		override public function clone(result:BoundingVolume = null):BoundingVolume
		{
			var sphere:BoundingSphere;
			if (result == null || !(result is BoundingSphere))
			{
				sphere = new BoundingSphere();
			}
			else
			{
				sphere = result as BoundingSphere;
			}

			sphere = super.clone(sphere) as BoundingSphere;

			sphere.radius = radius;
			sphere.center.copyFrom(center);
			sphere.checkPlane = checkPlane;
			return sphere;
		}

		public function toString():String
		{
			return "BoundingSphere [Radius: " + radius + " Center: " + center + "]";
		}

		override public function intersects(bv:BoundingVolume):Boolean
		{
			return bv.intersectsSphere(this);
		}

		override public function intersectsSphere(bs:BoundingSphere):Boolean
		{
			var diff:Vector3f = center.subtract(bs.center);
			var rsum:Number = radius + bs.radius;
			return diff.lengthSquared <= rsum * rsum;
		}

		override public function intersectsBoundingBox(bb:BoundingBox):Boolean
		{
			if (FastMath.fabs(bb.center.x - center.x) < radius + bb.xExtent && FastMath.fabs(bb.center.y - center.y) < radius + bb.yExtent && FastMath.fabs(bb.center.z - center.z) < radius + bb.zExtent)
				return true;

			return false;
		}

		override public function intersectsRay(ray:Ray):Boolean
		{
			var diff:Vector3f = ray.origin.subtract(center);
			var radiusSquared:Number = radius * radius;
			var a:Number = diff.dot(diff) - radiusSquared;
			if (a <= 0.0)
			{
				// in sphere
				return true;
			}

			// outside sphere
			var b:Number = ray.direction.dot(diff);
			if (b >= 0.0)
			{
				return false;
			}
			return b * b >= a;
		}

		public function collideWithRay(ray:Ray, results:CollisionResults):int
		{
			var point:Vector3f;
			var dist:Number;

			var diff:Vector3f = ray.origin.subtract(center);
			var radiusSquared:Number = radius * radius;
			var a:Number = diff.dot(diff) - radiusSquared;

			var a1:Number, discr:Number, root:Number;
			if (a <= 0.0)
			{
				// inside sphere
				a1 = ray.direction.dot(diff);
				discr = (a1 * a1) - a;
				root = Math.sqrt(discr);

				var distance:Number = root - a1;
				point = ray.direction.clone();
				point.scaleAdd(distance, ray.origin);

				var result:CollisionResult = new CollisionResult();
				result.contactPoint = point;
				result.distance = distance;
				results.addCollision(result);
				return 1;
			}

			a1 = ray.direction.dot(diff);
			if (a1 >= 0.0)
			{
				return 0;
			}

			var cr:CollisionResult;

			discr = a1 * a1 - a;
			if (discr < 0.0)
			{
				return 0;
			}
			else if (discr >= FastMath.ZERO_TOLERANCE)
			{
				root = Math.sqrt(discr);
				dist = -a1 - root;
				point = ray.direction.clone();
				point.scaleAdd(dist, ray.origin);
				cr = new CollisionResult();
				cr.contactPoint = point;
				cr.distance = dist;
				results.addCollision(cr);

				dist = -a1 + root;
				point = ray.direction.clone();
				point.scaleAdd(dist, ray.origin);
				cr = new CollisionResult();
				cr.contactPoint = point;
				cr.distance = dist;
				results.addCollision(cr);
				return 2;
			}
			else
			{
				dist = -a1;
				point = ray.direction.clone();
				point.scaleAdd(dist, ray.origin);
				cr = new CollisionResult();
				cr.contactPoint = point;
				cr.distance = dist;
				results.addCollision(cr);
				return 1;
			}
		}

		override public function collideWith(other:Collidable, results:CollisionResults):int
		{
			if (other is Ray)
			{
				var ray:Ray = other as Ray;
				return collideWithRay(ray, results);
			}
			else
			{
				throw new Error("Unsupported Collision Object");
			}
		}

		override public function contains(point:Vector3f):Boolean
		{
			return center.distanceSquared(point) < radius * radius;
		}

		override public function intersectsPoint(point:Vector3f):Boolean
		{
			return center.distanceSquared(point) <= radius * radius;
		}

		override public function distanceToEdge(point:Vector3f):Number
		{
			return center.distance(point) - radius;
		}

		//TODO 这里是如何计算的？
		override public function getVolume():Number
		{
			return 4 * (1 / 3) * FastMath.PI * radius * radius * radius;
		}
	}
}

