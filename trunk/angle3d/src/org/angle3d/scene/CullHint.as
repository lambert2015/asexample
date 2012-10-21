package org.angle3d.scene
{

	/**
	 * CullHint
	 * @author andy
	 */
	public class CullHint
	{
		/**
		 * Do whatever our parent does. If no parent, we'll default to dynamic.
		 */
		public static const Inherit:int=0;
		/**
		 * Do not draw if we are not at least partially within the view frustum
		 * of the renderer's camera.
		 */
		public static const Auto:int=1;
		/**
		 * Always cull this from view.
		 */
		public static const Always:int=2;
		/**
		 * Never cull this from view. Note that we will still get culled if our
		 * parent is culled.
		 */
		public static const Never:int=3;

	}
}

