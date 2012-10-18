package org.angle3d.material;

import flash.Vector;
import org.angle3d.renderer.IRenderer;

/**
 * Describes a material parameter. This is used for both defining a name and type
 * as well as a material parameter value.
 *
 */
class MatParam 
{
	public var type:String;
    public var name:String;
    public var value:Vector<Float>;

	public function new(type:String, name:String, value:Vector<Float>) 
	{
		this.type = type;
		this.name = name;
		this.value = value;
	}

    public inline function apply(render:IRenderer,mat:Material):Void 
	{
        mat.updateUniformParam(type, name, value);
    }
}