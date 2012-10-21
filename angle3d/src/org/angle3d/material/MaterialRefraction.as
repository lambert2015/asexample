package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueRefraction;
	import org.angle3d.texture.CubeTextureMap;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * Refraction mapping
	 * @author andy
	 */
	//TODO 效果不正常，可能是refract函数有问题
	public class MaterialRefraction extends Material
	{
		private var _technique:TechniqueRefraction;

		/**
		 *
		 * @param decalMap
		 * @param environmentMap
		 * @param etaRatio
		 * @param transmittance
		 *
		 */
		public function MaterialRefraction(decalMap:TextureMapBase, environmentMap:CubeTextureMap, etaRatio:Number = 1.5, transmittance:Number = 0.5)
		{
			super();

			_technique = new TechniqueRefraction(decalMap, environmentMap, etaRatio, transmittance);
			addTechnique(_technique);
		}
	}
}

