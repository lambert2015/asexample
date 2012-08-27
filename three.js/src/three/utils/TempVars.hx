package three.utils;

import three.math.Color;
import three.math.Matrix3;
import three.math.Matrix4;
import three.math.Vector2;
import three.math.Vector3;
import three.math.Vector4;
import three.utils.Assert;

/**
 * Temporary variables . Engine public classes may access
 * these temp variables with TempVars.getTempVars(), all retrieved TempVars
 * instances must be returned via TempVars.release().
 * This returns an available instance of the TempVar public class ensuring this
 * particular instance is never used elsewhere in the mean time.
 */
class TempVars
{
	/**
	 * Allow X instances of TempVars.
	 */
	private static var STACK_SIZE : Int = 5;

	private static var currentIndex : Int = 0;

	private static var varStack : Array<TempVars> = new Array<TempVars>();

	public static function getTempVars() : TempVars
	{
		var instance : TempVars = varStack[currentIndex];
		if (instance == null)
		{
			instance = new TempVars();
			varStack[currentIndex] = instance;
		}

		currentIndex++;

		instance.isUsed = true;

		return instance;
	}

	private var isUsed : Bool;

	/**
	 * Color
	 */
	public var color : Color;

	/**
	 * General vectors.
	 */
	public var vect1 : Vector3;
	public var vect2 : Vector3;
	public var vect3 : Vector3;
	public var vect4 : Vector3;
	public var vect5 : Vector3;
	public var vect6 : Vector3;
	public var vect7 : Vector3;
	public var vect8: Vector3;

	public var vect4f : Vector4;

	/**
	 * 2D vector
	 */
	public var vect2d : Vector2;
	public var vect2d2 : Vector2;
	/**
	 * General matrices.
	 */
	public var tempMat3 : Matrix3;
	public var tempMat4 : Matrix4;
	public var tempMat42 : Matrix4;

	public function new()
	{
		isUsed = false;

		color = new Color();

		vect1 = new Vector3();
		vect2 = new Vector3();
		vect3 = new Vector3();
		vect4 = new Vector3();
		vect5 = new Vector3();
		vect6 = new Vector3();
		vect7 = new Vector3();

		vect4f = new Vector4();

		vect2d = new Vector2();
		vect2d2 = new Vector2();

		tempMat3 = new Matrix3();
		tempMat4 = new Matrix4();
		tempMat42 = new Matrix4();
	}

	public function release() : Void
	{
		#if debug
		Assert.assert(isUsed, "This instance of TempVars was already released!");
		#end

		isUsed = false;

		currentIndex--;

		#if debug
		Assert.assert(varStack[currentIndex] == this, "An instance of TempVars has not been released in a called method!");
		#end
	}
}

