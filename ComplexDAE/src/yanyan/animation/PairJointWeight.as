package yanyan.animation
{
	/**
	 * 辅助数据结构 
	 * 
	 * @author harry
	 * 
	 */
	public class PairJointWeight
	{
		// 一个顶点对应多个Pair
		protected var _mJointPointer:Joint3D = null;// 骨骼节点
		public var numWeight:Number = 0;// 当前骨骼节点的权重
		public var mJointName:String = '';
		
		// link
		public var mPreLink:PairJointWeight = null;
		public var mNextLink:PairJointWeight = null;
		
		public function PairJointWeight()
		{
		}

		public function get mJointPointer():Joint3D
		{
			return _mJointPointer;
		}

		public function set mJointPointer(value:Joint3D):void
		{
			_mJointPointer = value;
			mJointName = _mJointPointer.name;
		}

	}
}