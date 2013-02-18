package org.angle3d.material.post.filter
{
	import org.angle3d.material.post.Filter;

	public class FogFilter extends Filter
	{
		public function FogFilter()
		{
			super("FogFilter");
		}
		
		@Override
		protected boolean isRequiresDepthTexture() {
			return true;
		}
		
		@Override
		protected void initFilter(AssetManager manager, RenderManager renderManager, ViewPort vp, int w, int h) {
			material = new Material(manager, "Common/MatDefs/Post/Fog.j3md");
			material.setColor("FogColor", fogColor);
			material.setFloat("FogDensity", fogDensity);
			material.setFloat("FogDistance", fogDistance);
		}
		
		@Override
		protected Material getMaterial() {
			
			return material;
		}
		
		
		/**
		 * returns the fog color
		 * @return
		 */
		public ColorRGBA getFogColor() {
			return fogColor;
		}
		
		/**
		 * Sets the color of the fog
		 * @param fogColor
		 */
		public void setFogColor(ColorRGBA fogColor) {
			if (material != null) {
				material.setColor("FogColor", fogColor);
			}
			this.fogColor = fogColor;
		}
		
		/**
		 * returns the fog density
		 * @return
		 */
		public float getFogDensity() {
			return fogDensity;
		}
		
		/**
		 * Sets the density of the fog, a high value gives a thick fog
		 * @param fogDensity
		 */
		public void setFogDensity(float fogDensity) {
			if (material != null) {
				material.setFloat("FogDensity", fogDensity);
			}
			this.fogDensity = fogDensity;
		}
		
		/**
		 * returns the fog distance
		 * @return
		 */
		public float getFogDistance() {
			return fogDistance;
		}
		
		/**
		 * the distance of the fog. the higer the value the distant the fog looks
		 * @param fogDistance
		 */
		public void setFogDistance(float fogDistance) {
			if (material != null) {
				material.setFloat("FogDistance", fogDistance);
			}
			this.fogDistance = fogDistance;
		}
	}
}
