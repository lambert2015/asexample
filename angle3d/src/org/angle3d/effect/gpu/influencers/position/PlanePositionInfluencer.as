package org.angle3d.effect.gpu.influencers.position
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.Vector3f;

	/**
	 * 粒子随机分配在一个球体内
	 * edge为true时，粒子都在球体表面上
	 * random为true时，随机分配位置,否则均匀分配--->如何均匀分配呢
	 */
	public class PlanePositionInfluencer extends AbstractInfluencer implements IPositionInfluencer
	{
		public static const XZ:String = "xz";
		public static const XY:String = "xy";

		private var _center:Vector3f;
		private var _width:Number;
		private var _height:Number;
		private var _type:String;

		public function PlanePositionInfluencer(center:Vector3f, width:Number, height:Number, type:String = "xz")
		{
			_center = center;
			_width = width;
			_height = height;
			_type = type;
		}

		public function getPosition(index:int, store:Vector3f):Vector3f
		{
			if (_type == XZ)
			{
				store.x = _center.x + (Math.random() - 0.5) * _width;
				store.y = _center.y;
				store.z = _center.z + (Math.random() - 0.5) * _height;
			}
			else if (_type == XY)
			{
				store.x = _center.x + (Math.random() - 0.5) * _width;
				store.y = _center.y + (Math.random() - 0.5) * _height;
				store.z = _center.z;
			}

			return store;
		}
	}
}
