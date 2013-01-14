package yanyan.animation
{
	import flash.geom.Matrix3D;
	
	import yanyan.YObject3DContainer;
	
	/**
	 * 骨骼节点 
	 * 
	 * @author harry
	 * @date 11.05 2012
	 * 
	 */
	public class Joint3D extends YObject3DContainer
	{
		public function Joint3D()
		{
			super();
		}
		
		/*
		 * 骨骼节点继承的树形结构判定 
		 * 
		 * 
		 */
		protected var mHasParent:Boolean = false;
		public function hasParent():Boolean
		{
			return mHasParent = (this.parent != null);
		}

		/*
		 * 合并后的世界变换矩阵 
		 * 
		 */
		protected var _mCombineWorldTransform:Matrix3D = new Matrix3D;
		public function get mCombineWorldTransform():Matrix3D
		{
			return _mCombineWorldTransform;
		}

		public function set mCombineWorldTransform(value:Matrix3D):void
		{
			_mCombineWorldTransform = value;
		}

		/*
		 * 骨骼节点原始pose的绑定矩阵 
		 * 
		 * 
		 */
		protected var _mBindPoseTransform:Matrix3D = null;
		public function get mBindPoseTransform():Matrix3D
		{
			return _mBindPoseTransform;
		}
		
		public function set mBindPoseTransform(value:Matrix3D):void
		{
			_mBindPoseTransform = value;
		}

		/*
		 * 最后混合得到的变换矩阵 
		 * 
		 * 
		 */
		protected var _mSkinnedLastMatrix:Matrix3D = new Matrix3D;
		public function get mSkinnedLastMatrix():Matrix3D
		{
			return _mSkinnedLastMatrix;
		}

		public function set mSkinnedLastMatrix(value:Matrix3D):void
		{
			_mSkinnedLastMatrix = value;
		}
		
		
	}
}