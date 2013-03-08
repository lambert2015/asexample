package org.angle3d.material;

import org.angle3d.material.technique.TechniqueTexture;
import org.angle3d.texture.TextureMapBase;
import haxe.ds.Vector;
/**
 * andy
 * @author andy
 */

class MaterialTexture extends Material
{
	private var _technique:TechniqueTexture;

	public function new(texture:TextureMapBase, lightmap:TextureMapBase = null, useTexCoord2:Bool = false)
	{
		super();

		_technique = new TechniqueTexture();
		addTechnique(_technique);

		this.texture = texture;
		this.lightmap = lightmap;
		this.useTexCoord2 = useTexCoord2;

		sortingId = 2;
	}

	override private function set_skinningMatrices(data:Vector<Float>):Vector<Float>
	{
		_technique.skinningMatrices = data;
		return data;
	}

	override private function set_influence(value:Float):Float
	{
		_technique.influence = value;
		return value;
	}

	public var technique(get, null):TechniqueTexture;
	private function get_technique():TechniqueTexture
	{
		return _technique;
	}

	public var useTexCoord2(get, set):Bool;
	private function get_useTexCoord2():Bool
	{
		return _technique.useTexCoord2;
	}
	
	private function set_useTexCoord2(value:Bool):Bool
	{
		_technique.useTexCoord2 = value;
		return _technique.useTexCoord2;
	}
	
	public var texture(get, set):TextureMapBase;
	private function get_texture():TextureMapBase
	{
		return _technique.texture;
	}

	private function set_texture(value:TextureMapBase):TextureMapBase
	{
		_technique.texture = value;
		return value;
	}

	public var lightmap(get, set):TextureMapBase;
	private function get_lightmap():TextureMapBase
	{
		return _technique.lightmap;
	}
	
	private function set_lightmap(value:TextureMapBase):TextureMapBase
	{
		_technique.lightmap = value;
		return value;
	}
}

