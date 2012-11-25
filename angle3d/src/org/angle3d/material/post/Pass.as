package org.angle3d.material.post
{
	import org.angle3d.material.Material;
	import org.angle3d.renderer.IRenderer;
	import org.angle3d.texture.FrameBuffer;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * Filters are 2D effects applied to the rendered scene.<br>
	 * The filter is fed with the rendered scene image rendered in an offscreen frame buffer.<br>
	 * This texture is applied on a fullscreen quad, with a special material.<br>
	 * This material uses a shader that aplly the desired effect to the scene texture.<br>
	 * <br>
	 * This class is abstract, any Filter must extend it.<br>
	 * Any filter holds a frameBuffer and a texture<br>
	 * The getMaterial must return a Material that use a GLSL shader immplementing the desired effect<br>
	 *
	 * @author Rémy Bouquet aka Nehon
	 */
	public class Pass
	{
		protected var renderFrameBuffer:FrameBuffer;
		protected var renderTexture:TextureMapBase;
		protected var depthTexture:TextureMapBase;
		protected var passMaterial:Material;

		public function Pass()
		{

		}

		public function init(render:IRenderer, width:int, height:int, numSamples:int, renderDepth:Boolean):void
		{
			renderFrameBuffer = new FrameBuffer();
		}
	}
}

