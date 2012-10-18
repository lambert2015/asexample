package org.angle3d.material.post
{
	import org.angle3d.texture.FrameBuffer;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * Pass are like filters in filters.
	 * Some filters will need multiple passes before the final render
	 */
	public class Pass
	{
		private var renderFrameBuffer:FrameBuffer;
		private var renderTexture:TextureMapBase;

		public function Pass()
		{

		}
	}
}

