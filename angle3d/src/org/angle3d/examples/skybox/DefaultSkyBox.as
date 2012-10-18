package org.angle3d.examples.skybox
{
	import flash.display.BitmapData;

	import org.angle3d.scene.SkyBox;
	import org.angle3d.texture.CubeTextureMap;

	/**
	 * ...
	 * @author andy
	 */

	public class DefaultSkyBox extends SkyBox
	{
		[Embed(source = "../embed/sky/negativeX.png")]
		private static var EmbedNegativeX : Class;

		[Embed(source = "../embed/sky/negativeY.png")]
		private static var EmbedNegativeY : Class;

		[Embed(source = "../embed/sky/negativeZ.png")]
		private static var EmbedNegativeZ : Class;

		[Embed(source = "../embed/sky/positiveX.png")]
		private static var EmbedPositiveX : Class;

		[Embed(source = "../embed/sky/positiveY.png")]
		private static var EmbedPositiveY : Class;

		[Embed(source = "../embed/sky/positiveZ.png")]
		private static var EmbedPositiveZ : Class;

		private var _cubeMap : CubeTextureMap;

		public function DefaultSkyBox(size : Number)
		{
			var px : BitmapData = new EmbedPositiveX().bitmapData;
			var nx : BitmapData = new EmbedNegativeX().bitmapData;
			var py : BitmapData = new EmbedPositiveY().bitmapData;
			var ny : BitmapData = new EmbedNegativeY().bitmapData;
			var pz : BitmapData = new EmbedPositiveZ().bitmapData;
			var nz : BitmapData = new EmbedNegativeZ().bitmapData;

			_cubeMap = new CubeTextureMap(px, nx, py, ny, pz, nz);

			super(_cubeMap, size);
		}

		public function get cubeMap() : CubeTextureMap
		{
			return _cubeMap;
		}

	}
}

