package org.angle3d.collision.bih
{
	import org.angle3d.math.Vector3f;

	/**
	 * ...
	 * @author andy
	 */

	public class BIHTriangle
	{
		public var pointa:Vector3f;
		public var pointb:Vector3f;
		public var pointc:Vector3f;
		public var center:Vector3f;

		public function BIHTriangle(p1:Vector3f, p2:Vector3f, p3:Vector3f)
		{
			pointa = p1.clone();
			pointb = p2.clone();
			pointc = p3.clone();
			center = new Vector3f();
			center.x = (pointa.x + pointb.x + pointc.x) / 3;
			center.y = (pointa.y + pointb.y + pointc.y) / 3;
			center.z = (pointa.z + pointb.z + pointc.z) / 3;
		}

		public function getNormal():Vector3f
		{
			var normal:Vector3f = pointb.clone();
			normal.subtractLocal(pointa);
			normal.crossLocal(pointc.subtract(pointa));
			normal.normalizeLocal();
			return normal;
		}

		public function getExtreme(axis:int, left:Boolean):Number
		{
			var v1:Number, v2:Number, v3:Number;
			switch (axis)
			{
				case 0:
					v1 = pointa.x;
					v2 = pointb.x;
					v3 = pointc.x;
					break;
				case 1:
					v1 = pointa.y;
					v2 = pointb.y;
					v3 = pointc.y;
					break;
				case 2:
					v1 = pointa.z;
					v2 = pointb.z;
					v3 = pointc.z;
					break;
				default:
					return 0;
			}
			if (left)
			{
				if (v1 < v2)
				{
					if (v1 < v3)
						return v1;
					else
						return v3;
				}
				else
				{
					if (v2 < v3)
						return v2;
					else
						return v3;
				}
			}
			else
			{
				if (v1 > v2)
				{
					if (v1 > v3)
						return v1;
					else
						return v3;
				}
				else
				{
					if (v2 > v3)
						return v2;
					else
						return v3;
				}
			}
		}
	}
}

