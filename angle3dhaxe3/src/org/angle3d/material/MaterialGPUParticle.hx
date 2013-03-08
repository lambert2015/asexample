package org.angle3d.material;

import org.angle3d.material.technique.TechniqueCPUParticle;
import org.angle3d.material.technique.TechniqueGPUParticle;
import org.angle3d.math.Vector3f;
import org.angle3d.texture.TextureMapBase;

/**
 * GPU计算粒子运动，旋转，缩放，颜色变化等
 * @author andy
 */
class MaterialGPUParticle extends Material
{
	private var _technique:TechniqueGPUParticle;

	public function new(texture:TextureMapBase)
	{
		super();

		_technique = new TechniqueGPUParticle();
		addTechnique(_technique);

		this.texture = texture;
	}

	public function set useLocalColor(value:Bool):Void
	{
		_technique.useLocalColor = value;
	}

	public function get useLocalColor():Bool
	{
		return _technique.useLocalColor;
	}

	public function set useLocalAcceleration(value:Bool):Void
	{
		_technique.useLocalAcceleration = value;
	}

	public function get useLocalAcceleration():Bool
	{
		return _technique.useLocalAcceleration;
	}

	public function set blendMode(mode:Int):Void
	{
		_technique.renderState.blendMode = mode;
	}

	public function set loop(value:Bool):Void
	{
		_technique.setLoop(value);
	}

	public function get loop():Bool
	{
		return _technique.getLoop();
	}

	/**
	 * 使用自转
	 */
	public function set useSpin(value:Bool):Void
	{
		_technique.setUseSpin(value);
	}

	public function get useSpin():Bool
	{
		return _technique.getUseSpin();
	}

	public function reset():Void
	{
		_technique.curTime = 0;
	}

	public function update(tpf:Float):Void
	{
		_technique.curTime += tpf;
	}

	public function setAcceleration(acceleration:Vector3f):Void
	{
		_technique.setAcceleration(acceleration);
	}

	/**
	 *
	 * @param animDuration 播放速度,多长时间播放一次（秒）
	 * @param col
	 * @param row
	 *
	 */
	public function setSpriteSheet(animDuration:Float, col:Int, row:Int):Void
	{
		_technique.setSpriteSheet(animDuration, col, row);
	}

	public function setParticleColor(start:UInt, end:UInt):Void
	{
		_technique.setColor(start, end);
	}

	public function setAlpha(start:Float, end:Float):Void
	{
		_technique.setAlpha(start, end);
	}

	public function setSize(start:Float, end:Float):Void
	{
		_technique.setSize(start, end);
	}

	override public function set influence(value:Float):Void
	{
	}

	public function get technique():TechniqueGPUParticle
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
