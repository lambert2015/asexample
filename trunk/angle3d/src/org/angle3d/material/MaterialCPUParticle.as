package org.angle3d.material
{
	import org.angle3d.material.technique.TechniqueCPUParticle;
	import org.angle3d.texture.TextureMapBase;

	/**
	 * CPU计算粒子运动，颜色变化等，GPU只负责渲染部分
	 * @author andy
	 */
	public class MaterialCPUParticle extends Material
	{
		private var _technique:TechniqueCPUParticle;

		public function MaterialCPUParticle(texture:TextureMapBase)
		{
			super();

			_technique=new TechniqueCPUParticle();
			addTechnique(_technique);

			this.texture=texture;
		}

		override public function set influence(value:Number):void
		{
		}

		public function get technique():TechniqueCPUParticle
		{
			return _technique;
		}

		public function set texture(value:TextureMapBase):void
		{
			_technique.texture=value;
		}


		public function get texture():TextureMapBase
		{
			return _technique.texture;
		}
	}
}

