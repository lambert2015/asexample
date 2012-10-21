package org.angle3d.collision
{


	/**
	 * <code>CollisionResults</code> is a collection returned as a result of a
	 * collision detection operation done by {@link Collidable}.
	 *
	 * @author Kirill Vainer
	 */
	public class CollisionResults
	{

		private var results:Vector.<CollisionResult>;
		private var sorted:Boolean;

		public function CollisionResults()
		{
			results = new Vector.<CollisionResult>();
			sorted = true;
		}

		/**
		 * Clears all collision results added to this list
		 */
		public function clear():void
		{
			results.length = 0;
		}

		public function addCollision(c:CollisionResult):void
		{
			results.push(c);
			sorted = false;
		}

		public function get size():int
		{
			return results.length;
		}

		public function getClosestCollision():CollisionResult
		{
			if (results.length == 0)
				return null;

			if (!sorted)
			{
				results.sort(compareTo);
				sorted = true;
			}

			return results[0];
		}

		public function getFarthestCollision():CollisionResult
		{
			if (results.length == 0)
				return null;

			if (!sorted)
			{
				results.sort(compareTo);
				sorted = true;
			}

			return results[results.length - 1];
		}

		public function getCollision(index:int):CollisionResult
		{
			if (results.length == 0)
				return null;

			if (!sorted)
			{
				results.sort(compareTo);
				sorted = true;
			}

			return results[index];
		}

		/**
		 * Internal use only.
		 * @param index
		 * @return
		 */
		public function getCollisionDirect(index:int):CollisionResult
		{
			return results[index];
		}

		private function compareTo(a:CollisionResult, b:CollisionResult):int
		{
			if (a.distance < b.distance)
				return -1;
			else if (a.distance > b.distance)
				return 1;
			else
				return 0;
		}
	}
}

