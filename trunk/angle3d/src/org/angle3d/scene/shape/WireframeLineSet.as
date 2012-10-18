package org.angle3d.scene.shape
{
	import org.angle3d.math.Color;
	import org.angle3d.math.Vector3f;

	/**
	 * ...
	 * @author andy
	 */

	public class WireframeLineSet
	{
		public var sx : Number;
		public var sy : Number;
		public var sz : Number;

		public var ex : Number;
		public var ey : Number;
		public var ez : Number;

		public function WireframeLineSet(sx : Number, sy : Number, sz : Number, ex : Number, ey : Number, ez : Number)
		{
			this.sx = sx;
			this.sy = sy;
			this.sz = sz;

			this.ex = ex;
			this.ey = ey;
			this.ez = ez;
		}
	}
}

