package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueReflective;
	import org.angle3d.texture.CubeTextureMap;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * Reflection mapping
	 * @author andy
	 */

	public class MaterialReflective extends Material
	{
		private var _technique:TechniqueReflective;

		public function MaterialReflective(decalMap:TextureMapBase, environmentMap:CubeTextureMap, reflectivity:Number=0.8)
		{
			super();

			_technique=new TechniqueReflective(decalMap, environmentMap, reflectivity);
			addTechnique(_technique);
		}

		override public function set influence(value:Number):void
		{
			_technique.influence=value;
		}

		public function get technique():TechniqueReflective
		{
			return _technique;
		}

		public function set decalMap(map:TextureMapBase):void
		{
			_technique.decalMap=map;
		}

		public function set environmentMap(map:CubeTextureMap):void
		{
			_technique.environmentMap=map;
		}

		public function set reflectivity(reflectivity:Number):void
		{
			_technique.reflectivity=reflectivity;
		}

		public function get decalMap():TextureMapBase
		{
			return _technique.decalMap;
		}

		public function get environmentMap():CubeTextureMap
		{
			return _technique.environmentMap;
		}

		public function get reflectivity():Number
		{
			return _technique.reflectivity;
		}
	}
}

