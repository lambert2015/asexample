package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueTexture;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * ...
	 * @author andy
	 */

	public class MaterialTexture extends Material
	{
		private var _technique:TechniqueTexture;

		public function MaterialTexture(texture:TextureMapBase, lightmap:TextureMapBase = null, useTexCoord2:Boolean = false)
		{
			super();

			_technique = new TechniqueTexture();
			addTechnique(_technique);

			this.texture = texture;
			this.lightmap = lightmap;
			this.useTexCoord2 = useTexCoord2;
		}

		override public function set skinningMatrices(data:Vector.<Number>):void
		{
			_technique.skinningMatrices = data;
		}

		override public function set influence(value:Number):void
		{
			_technique.influence = value;
		}

		public function get technique():TechniqueTexture
		{
			return _technique;
		}

		public function set useTexCoord2(value:Boolean):void
		{
			_technique.useTexCoord2 = value;
		}

		public function set texture(value:TextureMapBase):void
		{
			_technique.texture = value;
		}

		public function set lightmap(value:TextureMapBase):void
		{
			_technique.lightmap = value;
		}

		public function get texture():TextureMapBase
		{
			return _technique.texture;
		}

		public function get lightmap():TextureMapBase
		{
			return _technique.lightmap;
		}
	}
}

