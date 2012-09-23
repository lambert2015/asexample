package three.renderers;

import three.math.Color;
import three.math.Vector2;
import three.math.Vector3;
import three.math.Vector4;
import three.math.Matrix4;
import three.textures.Texture;
/**
 * ...
 * @author 
 */
class UniformsUtils 
{
	public static function merge(uniforms:Array<Dynamic>):Dynamic
	{
		var merged:Dynamic = { };
		var tmp:Dynamic;

		for ( u in 0...uniforms.length) 
		{
			tmp = clone(uniforms[u]);

			var fields:Array<String> = Type.getClassFields(tmp);
			for (key in fields)
			{
				untyped merged[key] = tmp[key];
			}
		}
		return merged;
	}
	
	public static function clone( uniforms_src:Dynamic):Dynamic
	{
		var uniforms_dst:Dynamic = { };
		
		var parameter_src:Dynamic;
		
		var fields:Array<String> = Type.getClassFields(uniforms_src);
		for (u in fields)
		{
			var srcItem:Dynamic = { };
			var itemFields:Array<String> = Type.getClassFields(srcItem);
			for ( p in itemFields) 
			{
				parameter_src = untyped itemFields[p];

				if ( Std.is(parameter_src,Color) ||
					 Std.is(parameter_src,Vector2) ||
					 Std.is(parameter_src,Vector3) ||
					 Std.is(parameter_src,Vector4) ||
					 Std.is(parameter_src,Matrix4) ||
					 Std.is(parameter_src,Texture) ) 
				{
					untyped srcItem[p] = parameter_src.clone();
				} 
				else if ( Std.is(parameter_src,Array) ) 
				{
					untyped srcItem[p] = cast(parameter_src, Array<Dynamic>).slice(0);
				} 
				else 
				{
					untyped srcItem[p] = parameter_src;
				}
			}
			untyped uniforms_dst[u] = srcItem;
		}
		return uniforms_dst;
	}
	
}