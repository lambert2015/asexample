package org.angle3d.bounding;
import flash.errors.Error;
import org.angle3d.math.Vector3f;
import flash.Lib;
import flash.Vector;
import org.angle3d.collision.Collidable;
import org.angle3d.collision.CollisionResult;
import org.angle3d.collision.CollisionResults;
import org.angle3d.math.FastMath;
import org.angle3d.math.Matrix3f;
import org.angle3d.math.Matrix4f;
import org.angle3d.math.Plane;
import org.angle3d.math.PlaneSide;
import org.angle3d.math.Ray;
import org.angle3d.math.Transform;
import org.angle3d.math.Triangle;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.utils.Assert;

/**
 * <code>BoundingBox</code> defines an axis-aligned cube that defines a
 * container for a group of vertices of a particular piece of geometry. This box
 * defines a center and extents from that center along the x, y and z axis. <br>
 * <br>
 * A typical usage is to allow the class define the center and radius by calling
 * either <code>containAABB</code> or <code>averagePoints</code>. A call to
 * <code>computeFramePoint</code> in turn calls <code>containAABB</code>.
 * 
 */
class BoundingBox extends BoundingVolume
{
    public var xExtent:Float;
	public var yExtent:Float;
	public var zExtent:Float;
	
	public function new(center:Vector3f = null) 
	{
		super(center);
		xExtent = 0;
		yExtent = 0;
		zExtent = 0;
	}
	
	public function setExtent(x:Float, y:Float, z:Float):Void
	{
		xExtent = x;
		yExtent = y;
		zExtent = z;
	}
	
	public function setMinMax(min:Vector3f, max:Vector3f):Void
	{
		center.x = (max.x - min.x) * 0.5;
		center.y = (max.y - min.y) * 0.5;
		center.z = (max.z - min.z) * 0.5;
		
		xExtent = FastMath.fabs(max.x - center.x);
		yExtent = FastMath.fabs(max.y - center.y);
		zExtent = FastMath.fabs(max.z - center.z);
	}
	
	/**
     * <code>computeFromPoints</code> creates a new Bounding Box from a given
     * set of points. It uses the <code>containAABB</code> method as default.
     * 
     * @param points
     *            the points to contain.
     */
	override public function computeFromPoints(points:Vector<Float>):Void
	{
		containAABB(points);
	}
	
	/**
     * <code>computeFromTris</code> creates a new Bounding Box from a given
     * set of triangles. It is used in OBBTree calculations.
     * 
     * @param tris
     * @param start
     * @param end
     */
	public function computeFromTris(tris:Vector<Triangle>, start:Int, end:Int):Void
	{
		#if debug
		Assert.assert(end - start > 0, "end should be greater than end");
		#end
		
		var min:Vector3f = new Vector3f();
		var max:Vector3f = new Vector3f();
		
		var tri:Triangle = tris[start];
		var point:Vector3f = tri.getPoint(0);
		
		min.copyFrom(point);
		max.copyFrom(point);
		
		for (i in start...end)
		{
			tri = tris[i];
			Vector3f.checkMinMax(min, max, tri.getPoint(0));
			Vector3f.checkMinMax(min, max, tri.getPoint(1));
			Vector3f.checkMinMax(min, max, tri.getPoint(2));
		}
		
		center.x = (min.x + max.x) * 0.5;
		center.y = (min.y + max.y) * 0.5;
		center.z = (min.z + max.z) * 0.5;
		
		xExtent = max.x - center.x;
		yExtent = max.y - center.y;
		zExtent = max.z - center.z;
	}
	
	public function computeFromMesh(indices:Vector<Int>,mesh:Mesh, start:Int, end:Int):Void
	{
		#if debug
		Assert.assert(end - start > 0, "end should be greater than end");
		#end
		
		var min:Vector3f = new Vector3f();
		var max:Vector3f = new Vector3f();
		
		var tri:Triangle = new Triangle();
		var point:Vector3f;
		
		//初始化min,max
		mesh.getTriangle(indices[start], tri);
		point = tri.getPoint(0);
		min.copyFrom(point);
		max.copyFrom(point);
		
		for (i in start...end)
		{
			mesh.getTriangle(indices[i], tri);
			point = tri.getPoint(0);
			Vector3f.checkMinMax(min, max, point);
			point = tri.getPoint(1);
			Vector3f.checkMinMax(min, max, point);
			point = tri.getPoint(2);
			Vector3f.checkMinMax(min, max, point);
		}

		center.x = (min.x + max.x) * 0.5;
		center.y = (min.y + max.y) * 0.5;
		center.z = (min.z + max.z) * 0.5;
		
		xExtent = max.x - center.x;
		yExtent = max.y - center.y;
		zExtent = max.z - center.z;
	}
	
	/**
     * <code>containAABB</code> creates a minimum-volume axis-aligned bounding
     * box of the points, then selects the smallest enclosing sphere of the box
     * with the sphere centered at the boxes center.
     * 
     * @param points
     *            the list of points.
     */
    public function containAABB(points:Vector<Float>):Void
	{
        if (points.length <= 2) // we need at least a 3 float vector
            return;

		var minX:Float = points[0];
		var minY:Float = points[1];
		var minZ:Float = points[2];
		var maxX:Float = minX;
		var maxY:Float = minY;
		var maxZ:Float = minZ;
		
		var len:Int = Std.int(points.length / 3);
        for (i in 1...len) 
		{
			var i3:Int = i * 3;
			
			var px:Float = points[i3];
			var py:Float = points[i3 + 1];
			var pz:Float = points[i3 + 2];
			
            if (px < minX)
                minX = px;
            else if (px  > maxX)
                maxX = px;

            if (py < minY)
                minY = py;
            else if (py > maxY)
                maxY = py;

            if (pz < minZ)
                minZ = pz;
            else if (pz > maxZ)
                maxZ = pz;
        }
		
		center.x = (minX + maxX) * 0.5;
		center.y = (minY + maxY) * 0.5;
		center.z = (minZ + maxZ) * 0.5;

		xExtent = maxX - center.x;
		yExtent = maxY - center.y;
		zExtent = maxZ - center.z;
    }
	
	/**
     * <code>transform</code> modifies the center of the box to reflect the
     * change made via a rotation, translation and scale.
     * 
     * @param rotate
     *            the rotation change.
     * @param translate
     *            the translation change.
     * @param scale
     *            the size change.
     * @param result
     *            box to store result in
     */
	override public function transform(trans:Transform, result:BoundingVolume = null):BoundingVolume
	{
		var box:BoundingBox;
		if (result == null || result.getType() != BoundingVolumeType.AABB)
		{
			box = new BoundingBox();
		}
		else
		{
			box = Lib.as(result, BoundingBox);
		}
		
		center.multiply(trans.scale, box.center);
		trans.rotation.multiplyVector(box.center, box.center);
		box.center.addLocal(trans.translation);
		
		var transMatrix:Matrix3f = new Matrix3f();
		transMatrix.setQuaternion(trans.rotation);
		// Make the rotation matrix all positive to get the maximum x/y/z extent
		transMatrix.abs();
		
		var scale:Vector3f = trans.scale;
		var tmp1:Vector3f = new Vector3f();
		tmp1.x = xExtent * scale.x;
		tmp1.y = yExtent * scale.y;
		tmp1.z = zExtent * scale.z;
		
		var tmp2:Vector3f = transMatrix.multVec(tmp1);
		
		// Assign the biggest rotations after scales.
		box.xExtent = FastMath.fabs(tmp2.x);
		box.yExtent = FastMath.fabs(tmp2.y);
		box.zExtent = FastMath.fabs(tmp2.z);
		
		return box;
	}
	
	override public function transformByMatrix(trans:Matrix4f, result:BoundingVolume = null):BoundingVolume
	{
		var box:BoundingBox;
		if (result == null || result.getType() != BoundingVolumeType.AABB)
		{
			box = new BoundingBox();
		}
		else
		{
			box = Lib.as(result, BoundingBox);
		}
		
		var w:Float = trans.multProj(center, box.center);
		box.center.scaleLocal(1 / w);
		
		var transMatrix:Matrix3f = new Matrix3f();
		trans.toRotationMatrix(transMatrix);
		
		// Make the rotation matrix all positive to get the maximum x/y/z extent
		transMatrix.abs();
		
		var vect1:Vector3f = new Vector3f(xExtent, yExtent, zExtent);
		transMatrix.multVecLocal(vect1);
		
		// Assign the biggest rotations after scales.
		box.xExtent = FastMath.fabs(vect1.x);
		box.yExtent = FastMath.fabs(vect1.y);
		box.zExtent = FastMath.fabs(vect1.z);
		
		return box;
	}

	override public function getType():Int
	{
		return BoundingVolumeType.AABB;
	}
	
	/**
     * <code>whichSide</code> takes a plane (typically provided by a view
     * frustum) to determine which side this bound is on.
     * 
     * @param plane
     *            the plane to check against.
     */
	override public function whichSide(plane:Plane):PlaneSide
	{
		var normal:Vector3f = plane.normal;
		var radius:Float = FastMath.fabs(xExtent * normal.x)
                         + FastMath.fabs(yExtent * normal.y)
                         + FastMath.fabs(zExtent * normal.z);
		
	    var distance:Float = plane.pseudoDistance(center);
		
		//changed to < and > to prevent floating point precision problems
		if (distance < - radius)
		{
		    return PlaneSide.Negative;
		}
		else if (distance > radius)
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
     * @return the new sphere
     */
	override public function merge(volume:BoundingVolume):BoundingVolume
	{
		switch(volume.getType())
		{
			case BoundingVolumeType.AABB:
				{
					var box:BoundingBox = Lib.as(volume, BoundingBox);
					return mergeToBoundingBox(box.center, 
					              box.xExtent, box.yExtent, box.zExtent);
				}
			case BoundingVolumeType.Sphere:
				{
					var sphere:BoundingSphere = Lib.as(volume, BoundingSphere);
					return mergeToBoundingBox(sphere.center, 
					              sphere.radius, sphere.radius, sphere.radius);
				}
			default :
				return null;
		}
	}
	
	/**
     * <code>merge</code> combines this bounding box with another box which is
     * defined by the center, x, y, z extents.
     * 
     * @param boxCenter
     *            the center of the box to merge with
     * @param boxX
     *            the x extent of the box to merge with.
     * @param boxY
     *            the y extent of the box to merge with.
     * @param boxZ
     *            the z extent of the box to merge with.
     * @param rVal
     *            the resulting merged box.
     * @return the resulting merged box.
     */
	public function mergeToBoundingBox(boxCenter:Vector3f, boxX:Float, boxY:Float, boxZ:Float, result:BoundingBox = null):BoundingBox
	{
		if (result == null)
		{
			result = new BoundingBox();
		}
		
		var vect1:Vector3f = new Vector3f();
		vect1.x = center.x - xExtent;
		if (vect1.x > boxCenter.x - boxX)
		{
			vect1.x = boxCenter.x - boxX;
		}
		
		vect1.y = center.y - yExtent;
		if (vect1.y > boxCenter.y - boxY)
		{
			vect1.y = boxCenter.y - boxY;
		}
		
		vect1.z = center.z - zExtent;
		if (vect1.z > boxCenter.z - boxZ)
		{
			vect1.z = boxCenter.z - boxZ;
		}
		
		var vect2:Vector3f = new Vector3f();
		vect2.x = center.x + xExtent;
		if (vect2.x < boxCenter.x + boxX)
		{
			vect2.x = boxCenter.x + boxX;
		}
		
		vect2.y = center.y + yExtent;
		if (vect2.y < boxCenter.y + boxY)
		{
			vect2.y = boxCenter.y + boxY;
		}
		
		vect2.z = center.z + zExtent;
		if (vect2.z < boxCenter.z + boxZ)
		{
			vect2.z = boxCenter.z + boxZ;
		}
		
		result.center.x = (vect2.x + vect1.x) * 0.5;
		result.center.y = (vect2.y + vect1.y) * 0.5;
		result.center.z = (vect2.z + vect1.z) * 0.5;
		
		result.xExtent = vect2.x - vect1.x;
		result.yExtent = vect2.y - vect1.y;
		result.zExtent = vect2.z - vect1.z;
		
		return result;
	}
	
	override public function mergeLocal(volume:BoundingVolume):Void
	{
		if (volume == null)
		return;
		switch(volume.getType())
		{
			case BoundingVolumeType.AABB:
			{
				var box:BoundingBox = Lib.as(volume, BoundingBox);
				mergeToBoundingBox(box.center, box.xExtent, box.yExtent, box.zExtent,this);
			}
			case BoundingVolumeType.Sphere:
			{
				var sphere:BoundingSphere = Lib.as(volume, BoundingSphere);
				mergeToBoundingBox(sphere.center, sphere.radius, sphere.radius, sphere.radius,this);
			}
		}
	}
	
	override public function copyFrom(volume:BoundingVolume):Void
	{
		var box:BoundingBox = Lib.as(volume, BoundingBox);
		
		Assert.assert(box != null, "volume is not a BoundingBox");
		
		this.center.copyFrom(box.center);
		this.xExtent = box.xExtent;
		this.yExtent = box.yExtent;
		this.zExtent = box.zExtent;
		this.checkPlane = box.checkPlane;
	}
	
	override public function clone(result:BoundingVolume = null):BoundingVolume
	{
		var box:BoundingBox;
		if (result == null || !Std.is(result,BoundingBox))
		{
			box = new BoundingBox();
		}
		else
		{
			box = Lib.as(result, BoundingBox);
		}
		
		box = Lib.as(super.clone(box), BoundingBox);
		
		box.center.copyFrom(center);
		box.xExtent = xExtent;
		box.yExtent = yExtent;
		box.zExtent = zExtent;
		box.checkPlane = checkPlane;
		return box;
	}
	
	public function toString():String
	{
        return "BoundingBox [Center: " + center + 
		       "  xExtent: " + xExtent + 
			   "  yExtent: " + yExtent + 
			   "  zExtent: " + zExtent + "]";
    }
	
	/**
     * intersects determines if this Bounding Box intersects with another given
     * bounding volume. If so, true is returned, otherwise, false is returned.
     * 
     * @see com.jme.bounding.BoundingVolume#intersects(com.jme.bounding.BoundingVolume)
     */
	override public function intersects(bv:BoundingVolume):Bool
	{
		return bv.intersectsBoundingBox(this);
	}
	
	/**
     * determines if this bounding box intersects a given bounding sphere.
     * 
     * @see com.jme.bounding.BoundingVolume#intersectsSphere(com.jme.bounding.BoundingSphere)
     */
	override public function intersectsSphere(bs:BoundingSphere):Bool
	{
		if (FastMath.fabs(center.x - bs.center.x) < bs.radius + xExtent &&
            FastMath.fabs(center.y - bs.center.y) < bs.radius + yExtent &&
            FastMath.fabs(center.z - bs.center.z) < bs.radius + zExtent)
		{
            return true;
		}

        return false;
	}
	
	/**
     * determines if this bounding box intersects a given bounding box. If the
     * two boxes intersect in any way, true is returned. Otherwise, false is
     * returned.
     * 
     * @see com.jme.bounding.BoundingVolume#intersectsBoundingBox(com.jme.bounding.BoundingBox)
     */
	override public function intersectsBoundingBox(bb:BoundingBox):Bool
	{
		if (center.x + xExtent < bb.center.x - bb.xExtent ||
            center.x - xExtent > bb.center.x + bb.xExtent)
		{
			return false;	
		}  
        else if (center.y + yExtent < bb.center.y - bb.yExtent ||
                 center.y - yExtent > bb.center.y + bb.yExtent)
		{
			return false;	
		}    
        else if (center.z + zExtent < bb.center.z - bb.zExtent ||
                 center.z - zExtent > bb.center.z + bb.zExtent)
		{
            return false;
		}
        else
		{
            return true;
		}
	}
	
	/**
     * determines if this bounding box intersects with a given ray object. If an
     * intersection has occurred, true is returned, otherwise false is returned.
     * 
     * @see com.jme.bounding.BoundingVolume#intersects(com.jme.math.Ray)
     */
	override public function intersectsRay(ray:Ray):Bool
	{
		var diff:Vector3f = ray.origin.subtract(center);
		
		var rhs:Float;
		
		var fWdU:Array<Float>  = [];
        var fAWdU:Array<Float>  = [];
        var fDdU:Array<Float>  = [];
        var fADdU:Array<Float>  = [];
        var fAWxDdU:Array<Float>  = [];
		
		fWdU[0] = ray.direction.dot(Vector3f.X_AXIS);
        fAWdU[0] = FastMath.fabs(fWdU[0]);
        fDdU[0] = diff.dot(Vector3f.X_AXIS);
        fADdU[0] = FastMath.fabs(fDdU[0]);
        if (fADdU[0] > xExtent && fDdU[0] * fWdU[0] >= 0.0) 
		{
            return false;
        }

        fWdU[1] = ray.direction.dot(Vector3f.Y_AXIS);
        fAWdU[1] = FastMath.fabs(fWdU[1]);
        fDdU[1] = diff.dot(Vector3f.Y_AXIS);
        fADdU[1] = FastMath.fabs(fDdU[1]);
        if (fADdU[1] > yExtent && fDdU[1] * fWdU[1] >= 0.0) 
		{
            return false;
        }

        fWdU[2] = ray.direction.dot(Vector3f.Z_AXIS);
        fAWdU[2] = FastMath.fabs(fWdU[2]);
        fDdU[2] = diff.dot(Vector3f.Z_AXIS);
        fADdU[2] = FastMath.fabs(fDdU[2]);
        if (fADdU[2] > zExtent && fDdU[2] * fWdU[2] >= 0.0) 
		{
            return false;
        }

        var wCrossD:Vector3f = ray.direction.cross(diff);

        fAWxDdU[0] = FastMath.fabs(wCrossD.dot(Vector3f.X_AXIS));
        rhs = yExtent * fAWdU[2] + zExtent * fAWdU[1];
        if (fAWxDdU[0] > rhs) 
		{
            return false;
        }

        fAWxDdU[1] = FastMath.fabs(wCrossD.dot(Vector3f.Y_AXIS));
        rhs = xExtent * fAWdU[2] + zExtent * fAWdU[0];
        if (fAWxDdU[1] > rhs) 
		{
            return false;
        }

        fAWxDdU[2] = FastMath.fabs(wCrossD.dot(Vector3f.Z_AXIS));
        rhs = xExtent * fAWdU[1] + yExtent * fAWdU[0];
        if (fAWxDdU[2] > rhs) 
		{
            return false;
        }

        return true;
	}
	
	public function collideWithRay(ray:Ray, results:CollisionResults):Int
	{
		var diff:Vector3f = ray.origin.subtract(center);
        var direction:Vector3f = ray.direction.clone();

        var t:Array<Float> = [ 0, Math.POSITIVE_INFINITY ];
        
        var saveT0:Float = t[0], saveT1:Float = t[1];
        var notEntirelyClipped:Bool = clip(direction.x, -diff.x - xExtent, t)
                && clip(-direction.x,  diff.x - xExtent, t)
                && clip( direction.y, -diff.y - yExtent, t)
                && clip(-direction.y,  diff.y - yExtent, t)
                && clip( direction.z, -diff.z - zExtent, t)
                && clip(-direction.z,  diff.z - zExtent, t);
        
        if (notEntirelyClipped && (t[0] != saveT0 || t[1] != saveT1)) 
		{
            if (t[1] > t[0]) 
			{
                var distances:Array<Float> = t;
				
				var point0:Vector3f = ray.direction.clone();
				point0.scaleAdd(distances[0],ray.origin);
				
				var point1:Vector3f = ray.direction.clone();
				point1.scaleAdd(distances[1],ray.origin);

                var result:CollisionResult = new CollisionResult();
				result.setContactPointAndDistance(point0, distances[0]);
                results.addCollision(result);
                result = new CollisionResult();
				result.setContactPointAndDistance(point1, distances[1]);
                results.addCollision(result);
                return 2;
            }
			
			var point:Vector3f = ray.direction.clone();
			point.scaleAdd(t[0],ray.origin);

            var result:CollisionResult = new CollisionResult();
			result.setContactPointAndDistance(point, t[0]);
            results.addCollision(result);
            return 1;
        }
        return 0;
	}
	
	override public function collideWith(other:Collidable, results:CollisionResults):Int
	{
		if (Std.is(other, Ray))
		{
			var ray:Ray = Lib.as(other, Ray);
			return collideWithRay(ray,results);
		}
		else if (Std.is(other, Triangle))
		{
			var t:Triangle = Lib.as(other, Triangle);
			if (intersectsTriangle(t))
			{
				var r:CollisionResult = new CollisionResult();
				results.addCollision(r);
				return 1;
			}
			return 0;
		}
		else
		{
			throw new Error("Unsupported Collision Object");
		}
	}
	
	/**
     * C code ported from http://www.cs.lth.se/home/Tomas_Akenine_Moller/code/tribox3.txt
     *
     * @param v1
     * @param v2
     * @param v3
     * @return
     */
	override public function intersectsTriangle(tri:Triangle):Bool
	{
		return Intersection.intersect(this, tri.getPoint1(), tri.getPoint2(), tri.getPoint3());
	}
	
	override public function contains(point:Vector3f):Bool
	{
		return FastMath.fabs(center.x - point.x) < xExtent &&
		       FastMath.fabs(center.y - point.y) < yExtent &&
			   FastMath.fabs(center.z - point.z) < zExtent;
	}
	
	override public function intersectsPoint(point:Vector3f):Bool
	{
		return FastMath.fabs(center.x - point.x) < xExtent &&
		       FastMath.fabs(center.y - point.y) < yExtent &&
			   FastMath.fabs(center.z - point.z) < zExtent;
	}
	
	override public function distanceToEdge(point:Vector3f):Float
	{
		// compute coordinates of point in box coordinate system
		var closest:Vector3f = point.subtract(center);
		
		// project test point onto box
		var sqrDistance:Float = 0.0;
		var delta:Float;
		
		if (closest.x < -xExtent) 
		{
            delta = closest.x + xExtent;
            sqrDistance += delta * delta;
            closest.x = -xExtent;
        } 
		else if (closest.x > xExtent) 
		{
            delta = closest.x - xExtent;
            sqrDistance += delta * delta;
            closest.x = xExtent;
        }

        if (closest.y < -yExtent) 
		{
            delta = closest.y + yExtent;
            sqrDistance += delta * delta;
            closest.y = -yExtent;
        } 
		else if (closest.y > yExtent) 
		{
            delta = closest.y - yExtent;
            sqrDistance += delta * delta;
            closest.y = yExtent;
        }

        if (closest.z < -zExtent) 
		{
            delta = closest.z + zExtent;
            sqrDistance += delta * delta;
            closest.z = -zExtent;
        } 
		else if (closest.z > zExtent) 
		{
            delta = closest.z - zExtent;
            sqrDistance += delta * delta;
            closest.z = zExtent;
        }

        return Math.sqrt(sqrDistance);
	}
	
	/**
     * <code>clip</code> determines if a line segment intersects the current
     * test plane.
     * 
     * @param denom
     *            the denominator of the line segment.
     * @param numer
     *            the numerator of the line segment.
     * @param t
     *            test values of the plane.
     * @return true if the line segment intersects the plane, false otherwise.
     */
	private function clip(denom:Float, numer:Float, t:Array<Float>):Bool
	{
		 // Return value is 'true' if line segment intersects the current test
        // plane. Otherwise 'false' is returned in which case the line segment
        // is entirely clipped.
        if (denom > 0.0) 
		{
            if (numer > denom * t[1])
                return false;
            if (numer > denom * t[0])
                t[0] = numer / denom;
            return true;
        } 
		else if (denom < 0.0) 
		{
            if (numer > denom * t[0])
                return false;
            if (numer > denom * t[1])
                t[1] = numer / denom;
            return true;
        } 
		else 
		{
            return numer <= 0.0;
        }
	}
	
	/**
     * Query extent.
     * 
     * @param store
     *            where extent gets stored - null to return a new vector
     * @return store / new vector
     */
	public function getExtent(result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		result.setTo(xExtent, yExtent, zExtent);
		return result;
	}
	
	public function getMin(result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		result.x = center.x - xExtent;
		result.y = center.y - yExtent;
		result.z = center.z - zExtent;
		return result;
	}
	
	public function getMax(result:Vector3f = null):Vector3f
	{
		if (result == null)
		{
			result = new Vector3f();
		}
		result.x = center.x + xExtent;
		result.y = center.y + yExtent;
		result.z = center.z + zExtent;
		return result;
	}
	
	override public function getVolume():Float
	{
		return (8 * xExtent * yExtent * zExtent);
	}
	
}