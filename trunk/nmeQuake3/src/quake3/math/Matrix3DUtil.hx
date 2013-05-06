package quake3.math;
import nme.geom.Matrix3D;
import flash.Vector;

/**
 * Matrix3D Helper
 * @author andy
 */

class Matrix3DUtil 
{
	/*
     * Generates a frustum matrix with the given bounds
	 * 
     * left, right - scalar, left and right bounds of the frustum
     * bottom, top - scalar, bottom and top bounds of the frustum
     * near, far - scalar, near and far bounds of the frustum
     * dest - Optional, mat4 frustum matrix will be written into
     */
	public static function makeFrustum(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float):Matrix3D
	{
		var result:Matrix3D = new Matrix3D();
		var dest:Vector<Float> = result.rawData;
		
		var rl:Float = (right - left);
		var tb:Float = (top - bottom);
		var fn:Float = (far - near);
		
		dest[0] = (near * 2) / rl;
		dest[1] = 0;
		dest[2] = 0;
		dest[3] = 0;
		dest[4] = 0;
		dest[5] = (near * 2) / tb;
		dest[6] = 0;
		dest[7] = 0;
		dest[8] = (right + left) / rl;
		dest[9] = (top + bottom) / tb;
		dest[10] = -(far + near) / fn;
		dest[11] = -1;
		dest[12] = 0;
		dest[13] = 0;
		dest[14] = -(far * near * 2) / fn;
		dest[15] = 0;
		
		result.rawData = dest;
		
		return result;
	}
	
	/*
	 * Generates a perspective projection matrix with the given bounds
	 *
	 * fovy - scalar, vertical field of view
	 * aspect - scalar, aspect ratio. typically viewport width/height
	 * near, far - scalar, near and far bounds of the frustum
	 * dest - Optional, mat4 frustum matrix will be written into
	 */
	public static function makePerspective(fovy:Float, aspect:Float, near:Float, far:Float):Matrix3D
	{
		var top:Float = near * Math.tan(fovy * Math.PI / 360.0);
		var right:Float = top * aspect;
		return makeFrustum(-right, right, -top, top, near, far);
	}
	
}