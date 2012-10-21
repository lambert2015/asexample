package org.angle3d.scene.billboard
{

	/**
	 * 布告板注册点，布告板将围绕这个点旋转
	 * 默认使用中心点
	 */
	public class BillboardOriginType
	{
		/**
		 * 中心点
		 */
		public static const BBO_CENTER:int = 0;
		public static const BBO_TOP_LEFT:int = 1;
		public static const BBO_TOP_CENTER:int = 2;
		public static const BBO_TOP_RIGHT:int = 3;
		public static const BBO_CENTER_LEFT:int = 4;
		public static const BBO_CENTER_RIGHT:int = 5;
		public static const BBO_BOTTOM_LEFT:int = 6;
		public static const BBO_BOTTOM_CENTER:int = 7;
		public static const BBO_BOTTOM_RIGHT:int = 8;
	}
}
