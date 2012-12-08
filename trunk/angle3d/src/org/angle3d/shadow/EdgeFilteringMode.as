package org.angle3d.shadow
{

	/**
	 * <code>ShadowEdgeFiltering</code> specifies how shadows are filtered
	 */
	public class EdgeFilteringMode
	{
		/**
		 * Shadows are not filtered. Nearest sample is used, causing in blocky
		 * shadows.
		 */
		public static const Nearest:int = 0;
		/**
		 * Bilinear filtering is used. Has the potential of being hardware
		 * accelerated on some GPUs
		 */
		public static const Bilinear:int = 1;
		/**
		 * Dither-based sampling is used, very cheap but can look bad at low
		 * resolutions.
		 */
		public static const Dither:int = 2;
		/**
		 * 4x4 percentage-closer filtering is used. Shadows will be smoother at the
		 * cost of performance
		 */
		public static const PCF4:int = 3;
		/**
		 * 8x8 percentage-closer filtering is used. Shadows will be smoother at the
		 * cost of performance
		 */
		public static const PCFPOISSON:int = 4;
		/**
		 * 8x8 percentage-closer filtering is used. Shadows will be smoother at the
		 * cost of performance
		 */
		public static const PCF8:int = 5;
	}
}
