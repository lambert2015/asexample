package org.angle3d.material.post
{

	/**
	 * Filters are 2D effects applied to the rendered scene.<br>
	 * The filter is fed with the rendered scene image rendered in an offscreen frame buffer.<br>
	 * This texture is applied on a fullscreen quad, with a special material.<br>
	 * This material uses a shader that aplly the desired effect to the scene texture.<br>
	 * <br>
	 * This public class is abstract, any Filter must extend it.<br>
	 * Any filter holds a frameBuffer and a texture<br>
	 * The getMaterial must return a Material that use a GLSL shader immplementing the desired effect<br>
	 *
	 * @author Rémy Bouquet aka Nehon
	 */
	public class Filter
	{
		private var name:String;
		private var defaultPass:Pass;


		public function Filter()
		{

		}
	}
}

