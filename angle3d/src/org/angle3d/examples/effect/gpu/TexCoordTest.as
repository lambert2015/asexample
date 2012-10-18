package org.angle3d.examples.effect.gpu
{
	import flash.display.Sprite;

	import org.angle3d.math.Vector2f;

	/**
	 * SpriteSheet UV测试
	 */
	public class TexCoordTest extends Sprite
	{
		public function TexCoordTest()
		{
			super();

			//测试到达第几帧
			var duration:Number = 0.5;
			var startFrame:int=5;
			var currentTime:int = 15;
			var totalFrame:int = 16;

			var frame:int = currentTime / duration + startFrame;
			var index:int = int(frame / totalFrame);

			var real:int = frame - index * totalFrame;
			trace(frame);
			trace(real);

			trace(getTexCoord(10, new Vector2f(1, 0), 4, 4));
			trace(getTexCoord(10, new Vector2f(0, 0), 4, 4));
			trace(getTexCoord(10, new Vector2f(1, 1), 4, 4));
			trace(getTexCoord(10, new Vector2f(0, 1), 4, 4));
			trace(getTexCoord(0, new Vector2f(1, 0), 4, 4));
			trace(getTexCoord(1, new Vector2f(0, 0), 4, 4));
			trace(getTexCoord(2, new Vector2f(1, 1), 4, 4));
			trace(getTexCoord(3, new Vector2f(0, 1), 4, 4));
		}

		/**
		 *
		 * @param frame
		 * @param vertex
		 * @param numCol 列数量
		 * @param numRow 行数量
		 * @return
		 *
		 */
		private function getTexCoord(frame:int, vertex:Vector2f, numCol:int, numRow:int):Vector2f
		{
			var totalFrame:int = numCol * numRow;

			var invertX:Number = 1 / numRow;
			var invertY:Number = 1 / numCol;

			var currentRowIndex:int = int(frame / numCol);
			var currentColIndex:int = frame - currentRowIndex * numCol;

			var result:Vector2f = new Vector2f();

			result.x = currentColIndex * invertX + vertex.x * invertX;
			result.y = currentRowIndex * invertY + vertex.y * invertY;

			return result;
		}
	}
}
