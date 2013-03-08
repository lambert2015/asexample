package org.angle3d.material;

import org.angle3d.material.technique.TechniqueCPUParticle;
import org.angle3d.texture.TextureMapBase;

/**
 * CPU计算粒子运动，颜色变化等，GPU只负责渲染部分
 * @author andy
 */
class MaterialCPUParticle extends Material
{
	private var _technique:TechniqueCPUParticle;

	public function new(texture:TextureMapBase)
	{
		super();

		_technique = new TechniqueCPUParticle();
		addTechnique(_technique);

		this.texture = texture;
	}

	override public function set influence(value:Float):Void
	{
	}

	public function get technique():TechniqueCPUParticle
	{
		return _technique;
	}

	public function set texture(value:TextureMapBase):Void
	{
		_technique.texture = value;
	}


	public function get texture():TextureMapBase
	{
		return _technique.texture;
	}
}

