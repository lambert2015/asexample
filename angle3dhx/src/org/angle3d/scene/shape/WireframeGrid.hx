package org.angle3d.scene.shape;
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
	                    plane:UInt = 7 ) 
	{
		super();
			
		if(subDivision == 0) subDivision = 1;
		if(gridSize ==  0) gridSize = 1;
			 
		if ((plane & PLANE_XY) != 0)
		{
			addGrid(subDivision, gridSize, PLANE_XY);
		}
		
		if ((plane & PLANE_YZ) != 0)
		{
			addGrid(subDivision, gridSize, PLANE_YZ);
		}
		
		if ((plane & PLANE_XZ) != 0)
		{
			addGrid(subDivision, gridSize, PLANE_XZ);
		}

		build();
		
		updateBound();
	}
	
	private function addGrid(subDivision:Int, gridSize:Int, plane:UInt):Void
	{
		var bound:Float = gridSize *.5;
		var step:Float = gridSize/subDivision;
		var inc:Float = -bound;
		while (inc <= bound)
		{ 
			switch(plane)
			{
				case PLANE_YZ:
					addSegment( new LineSet(0, inc, bound, 0, inc, -bound));
					addSegment( new LineSet(0, bound, inc, 0, -bound, inc));
				case PLANE_XY:
					addSegment( new LineSet(bound, inc, 0, -bound, inc, 0));
					addSegment( new LineSet(inc, bound, 0, inc, -bound, 0));
				default:
					addSegment( new LineSet(bound, 0, inc, -bound, 0, inc));
					addSegment( new LineSet(inc, 0, bound, inc, 0, -bound));
			}
				
			inc += step;
		}
	}
}