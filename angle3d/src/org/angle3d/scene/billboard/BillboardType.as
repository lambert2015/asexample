package org.angle3d.scene.billboard
{

	public class BillboardType
	{
		/**
		 * 指向公告板，一直面向并且垂直于摄像机,默认类型
		 */
		public static const BBT_POINT:int=0;

		/**
		 * 导向公告板，它沿共同的轴（通常是Y轴）旋转,即绕在BillboardSet中设置的getCommonDirection()旋转
		 */
		public static const BBT_ORIENTED_COMMON:int=1;

		/**
		 * 导向公告板，它沿各自的方向旋转（Billboard.direction）
		 */
		public static const BBT_ORIENTED_SELF:int=2;

		/**
		 * 垂直公告板，它与方向向量（布告板与相机之间的向量）垂直。这个方向向量是共享的向量（通常是Z轴）
		 */
		// Billboards are perpendicular to a shared direction vector (used as Z axis, the facing direction) and X, Y axis are determined by a shared up-vertor
		public static const BBT_PERPENDICULAR_COMMON:int=3;

		/**
		 * 垂直公告板，它与方向向量（布告板与相机之间的向量）垂直。这个方向向量是各自的Z轴
		 */
		// Billboards are perpendicular to their own direction vector (their own Z axis, the facing direction) and X, Y axis are determined by a shared up-vertor
		public static const BBT_PERPENDICULAR_SELF:int=4;
	}
}
