package org.angle3d.math
{

	/**
	 * <code>Line</code> defines a line. Where a line is defined as infinite along
	 * two points. The two points of the line are defined as the origin and direction.
	 *
	 * @author Mark Powell
	 * @author Joshua Slack
	 */
	public class Line
	{
		/**
		 * the origin of the line
		 */
		public var origin:Vector3f;

		/**
		 * the direction of the line
		 */
		public var direction:Vector3f;

		public function Line(origin:Vector3f = null, direction:Vector3f = null)
		{
			this.origin = new Vector3f();
			this.direction = new Vector3f();

			if (origin != null)
			{
				this.origin.copyFrom(origin);
			}

			if (direction != null)
			{
				this.direction.copyFrom(direction);
			}
		}

		public function distanceSquared(point:Vector3f):Number
		{
			var compVec1:Vector3f = new Vector3f();
			var compVec2:Vector3f = new Vector3f();

			point.subtract(origin, compVec1);
			var lineParameter:Number = direction.dot(compVec1);
			direction.scale(lineParameter, compVec2);
			origin.add(compVec2, compVec2);
			compVec2.subtract(point, compVec1);

			var len:Number = compVec1.lengthSquared;

			return len;
		}

		public function distance(point:Vector3f):Number
		{
			return Math.sqrt(distanceSquared(point));
		}

		public function getRandomPointInLine(result:Vector3f):void
		{
			var rand:Number = Math.random();
			var rand1:Number = 1.0 - rand;
			result.x = origin.x * rand1 + direction.x * rand;
			result.y = origin.y * rand1 + direction.y * rand;
			result.z = origin.z * rand1 + direction.z * rand;
		}

		public function clone():Line
		{
			return new Line(this.origin, this.direction);
		}
	}
}

