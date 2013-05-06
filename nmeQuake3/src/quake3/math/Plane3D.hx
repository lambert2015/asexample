package quake3.math;
import nme.geom.Vector3D;
class Plane3D
{
	public static inline var IS_FRONT : Int = 0;
	public static inline var IS_BACK : Int = 1;
	public static inline var IS_PLANAR : Int = 2;
	public static inline var IS_SPANNING : Int = 3;
	public static inline var IS_CLIPPED : Int = 4;

	
	public var normal : Vector3D;
	
	public var d : Float ;
	
	public function new(?n : Vector3D = null, ?d : Float = 0)
	{
		this.normal = new Vector3D();
		if (n != null)
		    normal.copyFrom(n);
		this.d = d;
	}

	/** 
	 * 直线的参数方程为p=p0+v*t;//p0(x0,y0,z0)为直线的点,v(vx,vy,vz)为直线的方向
	 * 平面的通用方程a*x+b*y+c*z+d=0;//假设平面的法向量为normal(a,b,c)
	 * 把直线带入平面方程中：
	 * a*(x0+vx*t)+b*(y0+vy*t)+c*(z0+vz*t)+d=0
	 * t=-(a*x0+b*y0+c*z0+d)/(a*vx+b*vy+c*vz);
	 * 即t=-(normal.dot(p0)+d)/normal.dot(v);
	 * 再带入直线的参数方程即可求得交点：
	 * x=x0+vx*t;
	 * y=y0+vy*t;
	 * z=z0+vz*t;
	 * @param lineVect: Vector of the line to intersect with.直线的向量
	 * @param linePoint: Point of the line to intersect with.直线上的一个点
	 * @param outIntersection: Place to store the intersection point, if there is one.交点，如果存在的话
	 * @return Returns true if there was an intersection, false if there was not.如果交点存在，返回true
	 */
	public inline function getIntersectionWithLine(linePoint : Vector3D, lineVect : Vector3D, outIntersection : Vector3D) : Bool
	{
		var t2 : Float = normal.dotProduct(lineVect);
		//两个向量垂直，说明直线与平面平行或者被包含
		if(t2 == 0)
		{
			return false;
		} 
		else 
		{
			var t : Float = -(normal.dotProduct(linePoint) + d) / t2;
			outIntersection.x = linePoint.x +(lineVect.x * t);
			outIntersection.y = linePoint.y +(lineVect.y * t);
			outIntersection.z = linePoint.z +(lineVect.z * t);
			return true;
		}
	}
	
	/**
	 * 判断平面与点的关系
	 * @param	point
	 * @return
	 */
	public inline function classifyPointRelation(point : Vector3D) : Int
	{
		var t : Float = normal.dotProduct(point) + d;
		if (t < - FastMath.ROUNDING_ERROR)
		{
			return IS_BACK;
		} 
		else if (t > FastMath.ROUNDING_ERROR)
		{
			return IS_FRONT;
		} 
		else
		{
			return IS_PLANAR;
		}
	}

	public inline function isFrontFacing(lookDirection : Vector3D) : Bool
	{
		return normal.dotProduct(lookDirection) <= 0.0;
	}
}
