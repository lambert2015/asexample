package org.angle3d.effect.gpu.influencers.position
{
	import org.angle3d.effect.gpu.influencers.AbstractInfluencer;
	import org.angle3d.math.Vector3f;

	public class DefaultPositionInfluencer extends AbstractInfluencer implements IPositionInfluencer
	{
		private var _point:Vector3f;

		public function DefaultPositionInfluencer(point:Vector3f=null)
		{
			_point=point != null ? point.clone() : new Vector3f(0, 0, 0);
		}

		public function getPosition(index:int, vector3:Vector3f):Vector3f
		{
			vector3.copyFrom(_point);
			return vector3;
		}
	}
}
