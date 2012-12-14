package org.angle3d.shadow
{
	import org.angle3d.material.Material;
	import org.angle3d.material.post.Filter;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Vector4f;
	import org.angle3d.renderer.ViewPort;

	/**
	 *
	 * Generic abstract filter that holds common implementations for the different
	 * shadow filtesr
	 *
	 * @author Rémy Bouquet aka Nehon
	 */
	public class AbstractShadowFilter extends Filter
	{
		protected var shadowRender:AbstractShadowRenderer;
		protected var viewPort:ViewPort;
		
		/**
		 * Abstract class constructor
		 *
		 * @param manager the application asset manager
		 * @param shadowMapSize the size of the rendered shadowmaps (512,1024,2048,
		 * etc...)
		 * @param nbShadowMaps the number of shadow maps rendered (the more shadow
		 * maps the more quality, the less fps).
		 * @param shadowRenderer the shadowRenderer to use for this Filter
		 */
		public function AbstractShadowFilter(shadowMapSize:int,shadowRender:AbstractShadowRenderer)
		{
			super("Post Shadow");
			
			material = new Material();
			this.shadowRender = shadowRender;
			this.shadowRender.setPostShadowMaterial(material);
		}
		
		override protected function getMaterial():Material
		{
			return material;
		}
		
		override protected function preFrame(tpf:Number):void
		{
			shadowRender.preFrame(tpf);
			material.setMatrix4("", viewPort.camera.getViewProjectionMatrix().invert());
			var m:Matrix4f = viewPort.camera.getViewProjectionMatrix();
			material.setVector4("", new Vector4f(m.m20, m.m21, m.m22, m.m23));
		}
	}
}
