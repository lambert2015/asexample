package quake3.bsp;
import nme.geom.Vector3D;
import quake3.math.FastMath;
import quake3.math.Plane3D;

/**
 * @see http://www.devmaster.net/articles/quake3collision/
 */
class BSPCollision 
{
	private static inline var TRACE_OFFSET = 0.03125;
	
    private var _bsp:BSP;
	
	public function new(bsp:BSP) 
	{
		_bsp = bsp;
	}
	
	/**
	 * 
	 * @param	start The point in the world where the trace will begin.
	 * @param	end The position we are trying to reach in the BSP.
	 * @param	radius 
	 * @return
	 */
	public function trace(start:Vector3D, end:Vector3D, radius:Float):TraceResult 
	{
		var output:TraceResult = new TraceResult(false,false,1.0,end);
	
		if (_bsp == null) { 
			return output; 
		}
	
		if (radius < 0) 
		{ 
			radius = 0; 
		}
	
		checkNode(0, 0, 1, start, end, radius, output);
	
		if (output.fraction != 1.0) // collided with something
		{
			output.endPos.x = start.x + output.fraction * (end.x - start.x);
			output.endPos.y = start.y + output.fraction * (end.y - start.y);
			output.endPos.z = start.z + output.fraction * (end.z - start.z);
		}
	
		return output;
	}

	public function checkNode(nodeIndex:Int, 
	                          startFraction:Float, 
							  endFraction:Float, 
							  start:Vector3D, 
							  end:Vector3D, 
							  radius:Float, 
							  output:TraceResult):Void
	{
		/**
		 * if the current node is a leaf, it goes through each brush in that leaf, 
		 * and, if needed, checks the brush for a collision. 
		 * I say if needed because some brushes should not be checked. 
		 * Those include those without any brush sides (or planes), 
		 * and those that aren't solid
		 */
		if (nodeIndex < 0) 
		{ 
			var leaf:BSPLeaf = _bsp.leaves[-(nodeIndex + 1)];
			for (i in 0...leaf.numLeafBrush) 
			{
				var brush:BSPBrush = _bsp.brushes[_bsp.leafBrushes[leaf.firstLeafBrush  + i]];
				var shader:BSPShader = _bsp.shaders[brush.shaderIndex];
				if (brush.numSides > 0 && (shader.contents & 1) != 0) 
				{
					checkBrush(brush, start, end, radius, output);
				}
			}
			// don't have to do anything else for leaves
			return;
		}
	
		// Tree node
		var node:BSPNode = _bsp.nodes[nodeIndex];
		var plane:Plane3D = _bsp.planes[node.plane];
	
		//calculate two floats which represent the distances of each point from the splitting plane.
		var startDist:Float = plane.normal.dotProduct(start) - plane.d;
		var endDist:Float = plane.normal.dotProduct(end) - plane.d;
	
		// both points are in front of the plane
		if (startDist >= radius && endDist >= radius) 
		{
			// so check the front child
			checkNode(node.front, startFraction, endFraction, start, end, radius, output );
		} 
		// both points are behind the plane
		else if (startDist < -radius && endDist < -radius) 
		{
			// so check the back child
			checkNode(node.back, startFraction, endFraction, start, end, radius, output );
		} 
		// the line spans the splitting plane
		else 
		{
			var side:Int;
			var fraction1:Float, fraction2:Float, middleFraction:Float;
			var middle:Vector3D = new Vector3D();

			// STEP 1: split the segment into two
			if (startDist < endDist) 
			{
				side = 1; // back
				var inverseDistance:Float = 1.0 / (startDist - endDist);
				fraction1 = (startDist - radius + TRACE_OFFSET) * inverseDistance;
				fraction2 = (startDist + radius + TRACE_OFFSET) * inverseDistance;
			} 
			else if (startDist > endDist) 
			{
				side = 0; // front
				var inverseDistance:Float = 1.0 / (startDist - endDist);
				fraction1 = (startDist + radius + TRACE_OFFSET) * inverseDistance;
				fraction2 = (startDist - radius - TRACE_OFFSET) * inverseDistance;
			} 
			else 
			{
				side = 0; // front
				fraction1 = 1;
				fraction2 = 0;
			}
			
			// STEP 2: make sure the numbers are valid
			fraction1 = FastMath.fclamp(fraction1, 0, 1);
			fraction2 = FastMath.fclamp(fraction2, 0, 1);
			
			
			var child1:Int;
			var child2:Int;
			if (side == 0)
			{
				child1 = node.front;
				child2 = node.back;
			}else
			{
				child1 = node.back;
				child2 = node.front;
			}
		
			// STEP 3: calculate the middle point for the first side
			middleFraction = startFraction + (endFraction - startFraction) * fraction1;
			middle.x = start.x + fraction1 * (end.x - start.x);
			middle.y = start.y + fraction1 * (end.y - start.y);
			middle.z = start.z + fraction1 * (end.z - start.z);
			
			// STEP 4: check the first side
			checkNode(child1, startFraction, middleFraction, start, middle, radius, output );
		
			// STEP 5: calculate the middle point for the second side
			middleFraction = startFraction + (endFraction - startFraction) * fraction2;
			middle.x = start.x + fraction2 * (end.x - start.x);
			middle.y = start.y + fraction2 * (end.y - start.y);
			middle.z = start.z + fraction2 * (end.z - start.z);
			
			// STEP 6: check the second side
			checkNode(child2, middleFraction, endFraction, middle, end, radius, output );  
		}
	}

	public function checkBrush(brush:BSPBrush, 
	                           start:Vector3D, 
							   end:Vector3D, 
							   radius:Float, 
							   output:TraceResult):Void
	{
		var startFraction:Float = -1;
		var endFraction:Float = 1;
		var startsOut:Bool = false;
		var endsOut:Bool = false;
		var collisionPlane:Plane3D = null;
	
		for (i in 0...brush.numSides) 
		{
			var brushSide:BSPBrushSide = _bsp.brushSides[brush.firstSide + i];
			var plane:Plane3D = _bsp.planes[brushSide.planeIndex];
		
			var startDist:Float = start.dotProduct(plane.normal ) - (plane.d + radius);
			var endDist:Float = end.dotProduct(plane.normal ) - (plane.d + radius);

			if (startDist > 0) startsOut = true;
			if (endDist > 0) endsOut = true;

			// make sure the trace isn't completely on one side of the brush
			if (startDist > 0 && endDist > 0) 
			{ 
				return; 
			}
			
			// both are behind this plane, it will get clipped by another one
			if (startDist <= 0 && endDist <= 0) 
			{ 
				continue; 
			}

			if (startDist > endDist) 
			{ 
				// line is entering into the brush
				var fraction:Float = (startDist - TRACE_OFFSET) / (startDist - endDist);  
				if (fraction > startFraction) 
				{
					startFraction = fraction;
					collisionPlane = plane;
				}
			} 
			else 
			{ 
				// line is leaving the brush
				var fraction:Float = (startDist + TRACE_OFFSET) / (startDist - endDist); 
				if (fraction < endFraction)
					endFraction = fraction;
			}
		}
	
		if (startsOut == false) 
		{
			output.startSolid = false;
			if (endsOut == false)
				output.allSolid = true;
			return; 
		}

		if (startFraction < endFraction) 
		{
			if (startFraction > -1 && startFraction < output.fraction) 
			{
				output.plane = collisionPlane;
				if (startFraction < 0)
					startFraction = 0;
				output.fraction = startFraction;
			}
		}
	}
}