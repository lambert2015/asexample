package org.angle3d.scene.shape
{
	import org.angle3d.math.Color;
	import org.angle3d.math.Vector3f;

	/**
	 * ...
	 * @author andy
	 */

	public class WireframeCube extends WireframeShape
	{
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;

		public function WireframeCube(width:Number, height:Number, depth:Number)
		{
			super();

			this._width=width;
			this._height=height;
			this._depth=depth;

			setupGeometry();
			build();
		}

		private function setupGeometry():void
		{
			var hw:Number=_width * 0.5;
			var hh:Number=_height * 0.5;
			var hd:Number=_depth * 0.5;

			addSegment(new WireframeLineSet(-hw, hh, -hd, -hw, -hh, -hd));
			addSegment(new WireframeLineSet(-hw, hh, hd, -hw, -hh, hd));
			addSegment(new WireframeLineSet(hw, hh, hd, hw, -hh, hd));
			addSegment(new WireframeLineSet(hw, hh, -hd, hw, -hh, -hd));

			addSegment(new WireframeLineSet(-hw, -hh, -hd, hw, -hh, -hd));
			addSegment(new WireframeLineSet(-hw, hh, -hd, hw, hh, -hd));
			addSegment(new WireframeLineSet(-hw, hh, hd, hw, hh, hd));
			addSegment(new WireframeLineSet(-hw, -hh, hd, hw, -hh, hd));

			addSegment(new WireframeLineSet(-hw, -hh, -hd, -hw, -hh, hd));
			addSegment(new WireframeLineSet(-hw, hh, -hd, -hw, hh, hd));
			addSegment(new WireframeLineSet(hw, hh, -hd, hw, hh, hd));
			addSegment(new WireframeLineSet(hw, -hh, -hd, hw, -hh, hd));
		}
	}
}

