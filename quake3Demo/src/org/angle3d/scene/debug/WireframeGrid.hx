package org.angle3d.scene.debug;
import org.angle3d.math.Color;
import org.angle3d.math.Vector3f;

/**
 * ...
 * @author andy
 */

class WireframeGrid extends WireframeShape
{
	
	public static inline var PLANE_XY:UInt = 0x01;
	public static inline var PLANE_XZ:UInt = 0x02;
	public static inline var PLANE_YZ:UInt = 0x04;

	/**
	 * 
	 * @param	subDivision
	 * @param	gridSize
	 * @param	thickness
	 * @param	color
	 * @param	plane default all plane
	 */
	public function new(subDivision:Int = 10, 
	                    gridSize:Int = 100, 
	                    thickness:Float = 1, 
	                    color:UInt = 0xFFFFFF,  
	                    plane:UInt = 7 ) 
	{
		super();
			
		if(subDivision == 0) subDivision = 1;
		if(thickness <= 0) thickness = 1;
		if(gridSize ==  0) gridSize = 1;
			 
		if ((plane & PLANE_XY) != 0)
		{
			addGrid(subDivision, gridSize, 0x0000FF, thickness, PLANE_XY);
		}
		
		if ((plane & PLANE_YZ) != 0)
		{
			addGrid(subDivision, gridSize, 0xFF0000, thickness, PLANE_YZ);
		}
		
		if ((plane & PLANE_XZ) != 0)
		{
			addGrid(subDivision, gridSize, 0x00FF00, thickness, PLANE_XZ);
		}

		build();
		
		updateBound();
	}
	
	private function addGrid(subDivision:Int, gridSize:Int, color:UInt, thickness:Float, plane:UInt):Void
	{
		var bound:Float = gridSize *.5;
		var step:Float = gridSize/subDivision;
		var inc:Float = -bound;
		while (inc <= bound)
		{ 
			switch(plane)
			{
				case PLANE_YZ:
					addSegment( new LineSegment(new Vector3f(0, inc, bound), new Vector3f(0, inc, -bound), color, color, thickness));
					addSegment( new LineSegment(new Vector3f(0, bound, inc), new Vector3f(0, -bound, inc), color, color, thickness));
				case PLANE_XY:
					addSegment( new LineSegment(new Vector3f(bound, inc, 0), new Vector3f(-bound, inc, 0), color, color, thickness));
					addSegment( new LineSegment(new Vector3f(inc, bound, 0), new Vector3f(inc, -bound, 0), color, color, thickness));
				default:
					addSegment( new LineSegment(new Vector3f(bound, 0, inc), new Vector3f(-bound, 0, inc), color, color, thickness));
					addSegment( new LineSegment(new Vector3f(inc, 0, bound), new Vector3f(inc, 0, -bound), color, color, thickness));
			}
				
			inc += step;
		}
	}
}