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

			mType = MeshType.MT_SKINNING;
		}
	}
}
