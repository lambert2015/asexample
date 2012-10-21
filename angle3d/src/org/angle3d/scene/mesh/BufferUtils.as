package org.angle3d.scene.mesh
{
	import org.angle3d.math.Vector3f;


	/**
	 * ...
	 * @author
	 */
	public class BufferUtils
	{
		/**
		 * Updates the values of the given vector from the specified buffer at the
		 * index provided.
		 *
		 * @param vector
		 *            the vector to set data on
		 * @param buf
		 *            the buffer to read from
		 * @param index
		 *            the position (in terms of vectors, not floats) to read from
		 *            the buf
		 */
		public static function populateFromBuffer(vector:Vector3f, buf:Vector.<Number>, index:int):void
		{
			vector.x = buf[index * 3];
			vector.y = buf[index * 3 + 1];
			vector.z = buf[index * 3 + 2];
		}

		/**
		 * Copies a Vector3f from one position in the buffer to another. The index
		 * values are in terms of vector number (eg, vector number 0 is postions 0-2
		 * in the NumberBuffer.)
		 *
		 * @param buf
		 *            the buffer to copy from/to
		 * @param fromPos
		 *            the index of the vector to copy
		 * @param toPos
		 *            the index to copy the vector to
		 */
		public static function copyInternalVector3(buf:Vector.<Number>, fromPos:int, toPos:int):void
		{
			copyInternal(buf, fromPos * 3, toPos * 3, 3);
		}

		/**
		 * Copies a Vector2f from one position in the buffer to another. The index
		 * values are in terms of vector number (eg, vector number 0 is postions 0-1
		 * in the NumberBuffer.)
		 *
		 * @param buf
		 *            the buffer to copy from/to
		 * @param fromPos
		 *            the index of the vector to copy
		 * @param toPos
		 *            the index to copy the vector to
		 */
		public static function copyInternalVector2(buf:Vector.<Number>, fromPos:int, toPos:int):void
		{
			copyInternal(buf, fromPos * 2, toPos * 2, 2);
		}

		/**
		 * Copies floats from one position in the buffer to another.
		 *
		 * @param buf
		 *            the buffer to copy from/to
		 * @param fromPos
		 *            the starting point to copy from
		 * @param toPos
		 *            the starting point to copy to
		 * @param length
		 *            the number of floats to copy
		 */
		public static function copyInternal(buf:Vector.<Number>, fromPos:int, toPos:int, length:int):void
		{
			for (var i:int = 0; i < length; i++)
			{
				buf[toPos + i] = buf[fromPos + i];
			}
		}
	}
}

