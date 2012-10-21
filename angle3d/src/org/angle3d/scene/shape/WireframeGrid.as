package org.angle3d.scene.shape
{
	import org.angle3d.math.Color;
	import org.angle3d.math.Vector3f;

	/**
	 * ...
	 * @author andy
	 */

	public class WireframeGrid extends WireframeShape
	{

		public static const PLANE_XY:uint=0x01;
		public static const PLANE_XZ:uint=0x02;
		public static const PLANE_YZ:uint=0x04;

		/**
		 *
		 * @param	subDivision
		 * @param	gridSize
		 * @param	thickness
		 * @param	color
		 * @param	plane default all plane
		 */
		public function WireframeGrid(subDivision:int=10, gridSize:int=100, plane:uint=7)
		{
			super();

			if (subDivision == 0)
				subDivision=1;
			if (gridSize == 0)
				gridSize=1;

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
		}

		private function addGrid(subDivision:int, gridSize:int, plane:uint):void
		{
			var bound:Number=gridSize * .5;
			var step:Number=gridSize / subDivision;
			var inc:Number=-bound;
			while (inc <= bound)
			{
				switch (plane)
				{
					case PLANE_YZ:
						addSegment(new WireframeLineSet(0, inc, bound, 0, inc, -bound));
						addSegment(new WireframeLineSet(0, bound, inc, 0, -bound, inc));
						break;
					case PLANE_XY:
						addSegment(new WireframeLineSet(bound, inc, 0, -bound, inc, 0));
						addSegment(new WireframeLineSet(inc, bound, 0, inc, -bound, 0));
						break;
					default:
						addSegment(new WireframeLineSet(bound, 0, inc, -bound, 0, inc));
						addSegment(new WireframeLineSet(inc, 0, bound, inc, 0, -bound));
						break;
				}

				inc+=step;
			}
		}
	}
}

