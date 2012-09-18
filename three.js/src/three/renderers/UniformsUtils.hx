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
		//var p, tmp;
//
		//for ( u in 0...uniforms.length) 
		//{
			//tmp = clone( uniforms[ u ] );
//
			//for ( p in tmp ) {
//
				//merged[ p ] = tmp[ p ];
//
			//}
//
		//}

		return merged;
	}
	
	public static function clone( uniforms_src:Dynamic):Dynamic
	{
		var uniforms_dst:Dynamic = { };
		
		//var u, p, parameter, parameter_src;
//
		//for ( u in uniforms_src ) {
//
			//uniforms_dst[ u ] = {};
//
			//for ( p in uniforms_src[ u ] ) {
//
				//parameter_src = uniforms_src[ u ][ p ];
//
				//if ( parameter_src instanceof Color ||
					 //parameter_src instanceof Vector2 ||
					 //parameter_src instanceof Vector3 ||
					 //parameter_src instanceof Vector4 ||
					 //parameter_src instanceof Matrix4 ||
					 //parameter_src instanceof Texture ) {
//
					//uniforms_dst[ u ][ p ] = parameter_src.clone();
//
				//} else if ( parameter_src instanceof Array ) {
//
					//uniforms_dst[ u ][ p ] = parameter_src.slice();
//
				//} else {
//
					//uniforms_dst[ u ][ p ] = parameter_src;
//
				//}
//
			//}
//
		//}

		return uniforms_dst;
	}
	
}