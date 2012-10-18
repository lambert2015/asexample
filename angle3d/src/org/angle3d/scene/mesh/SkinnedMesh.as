package org.angle3d.scene.mesh
{

	/**
	 * 骨骼动画
	 */
	public class SkinnedMesh extends Mesh
	{
		public function SkinnedMesh()
		{
			super();
			
			_type = MeshType.MT_SKELETAL_ANIMATION;
		}
	}
}
