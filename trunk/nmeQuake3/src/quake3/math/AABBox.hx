package quake3.math;
import nme.geom.Vector3D;
import nme.Vector;

class AABBox
{
	public var minX : Float;
	public var minY : Float;
	public var minZ : Float;
	public var maxX : Float;
	public var maxY : Float;
	public var maxZ : Float;
	
	public function new(min : Vector3D = null, max : Vector3D = null)
	{
		if(min == null || max == null)
		{
			minX = 0.;
			minY = 0.;
			minZ = 0.;
			maxX = 0.;
			maxY = 0.;
			maxZ = 0.;
		} 
		else
		{
			minX = min.x;
			minY = min.y;
			minZ = min.z;
			maxX = max.x;
			maxY = max.y;
			maxZ = max.z;
		}
	}
	
	public inline function makeIdentity() : Void
	{
		minX = 0.;
		minY = 0.;
		minZ = 0.;
		maxX = 0.;
		maxY = 0.;
		maxZ = 0.;
	}
	
	public inline function reset(x : Float, y : Float, z : Float) : Void
	{
		minX = x;
		minY = y;
		minZ = z;
		maxX = x;
		maxY = y;
		maxZ = z;
	}

	public inline function copy(other : AABBox) : Void
	{
		minX = other.minX;
		minY = other.minY;
		minZ = other.minZ;
		maxX = other.maxX;
		maxY = other.maxY;
		maxZ = other.maxZ;
	}

	public inline function addInternalVector(point : Vector3D) : Void
	{
		addInternalXYZ(point.x, point.y, point.z);
	}

	public inline function addInternalXYZ(x : Float, y : Float, z : Float) : Void
	{
		if(x> maxX) maxX = x;
		if(y> maxY) maxY = y;
		if(z> maxZ) maxZ = z;
		if(x <minX) minX = x;
		if(y <minY) minY = y;
		if(z <minZ) minZ = z;
	}
	
	public inline function addInternalAABBox(box : AABBox) : Void
	{
		addInternalXYZ(box.maxX, box.maxY, box.maxZ);
		addInternalXYZ(box.minX, box.minY, box.minZ);
	}
	
	public inline function intersectsWithBox(box : AABBox) : Bool
	{
		return(minX <= box.maxX && minY <= box.maxY && minZ <= box.maxZ &&
		        maxX>= box.minX && maxY>= box.minY && maxZ>= box.minZ);
	}
	
	public inline function isFullInside(box : AABBox) : Bool
	{
		return(minX>= box.minX && minY>= box.minY && minZ>= box.minZ &&
		maxX <= box.maxX && maxY <= box.maxY && maxZ <= box.maxZ);
	}

	public inline function getCenter() : Vector3D
	{
		var center : Vector3D = new Vector3D();
		center.x =(maxX + minX) * 0.5;
		center.y =(maxY + minY) * 0.5;
		center.z =(maxZ + minZ) * 0.5;
		return center;
	}
	
	public inline function getExtent() : Vector3D
	{
		var extent : Vector3D = new Vector3D();
		extent.x =(maxX - minX) * 0.5;
		extent.y =(maxY - minY) * 0.5;
		extent.z =(maxZ - minZ) * 0.5;
		return extent;
	}
	
	public inline function getEdges() : Vector<Vector3D>
	{
		var _edges : Vector<Vector3D>= new Vector<Vector3D>(8, true);
		for(i in 0...8)
		{
			_edges[i] = new Vector3D();
		}
		var centerX : Float =(maxX + minX) * 0.5;
		var centerY : Float =(maxY + minY) * 0.5;
		var centerZ : Float =(maxZ + minZ) * 0.5;
		var diagX : Float = centerX - maxX;
		var diagY : Float = centerY - maxY;
		var diagZ : Float = centerZ - maxZ;
		var v : Vector3D = _edges[0];
		v.x = centerX + diagX;
		v.y = centerY + diagY;
		v.z = centerZ + diagZ;
		v = _edges[1];
		v.x = centerX + diagX;
		v.y = centerY - diagY;
		v.z = centerZ + diagZ;
		v = _edges[2];
		v.x = centerX + diagX;
		v.y = centerY + diagY;
		v.z = centerZ - diagZ;
		v = _edges[3];
		v.x = centerX + diagX;
		v.y = centerY - diagY;
		v.z = centerZ - diagZ;
		v = _edges[4];
		v.x = centerX - diagX;
		v.y = centerY + diagY;
		v.z = centerZ + diagZ;
		v = _edges[5];
		v.x = centerX - diagX;
		v.y = centerY - diagY;
		v.z = centerZ + diagZ;
		v = _edges[6];
		v.x = centerX - diagX;
		v.y = centerY + diagY;
		v.z = centerZ - diagZ;
		v = _edges[7];
		v.x = centerX - diagX;
		v.y = centerY - diagY;
		v.z = centerZ - diagZ;
		return _edges;
	}

	public inline function clone() : AABBox
	{
		return new AABBox(new Vector3D(minX, minY, minZ) , new Vector3D(maxX, maxY, maxZ));
	}
}
