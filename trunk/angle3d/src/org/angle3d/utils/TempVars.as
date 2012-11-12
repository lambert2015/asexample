package org.angle3d.utils
{

	import org.angle3d.collision.bih.BIHStackData;
	import org.angle3d.math.Color;
	import org.angle3d.math.Matrix3f;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Plane;
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Triangle;
	import org.angle3d.math.Vector2f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.math.Vector4f;

	/**
	 * Temporary variables . Engine public classes may access
	 * these temp variables with TempVars.getTempVars(), all retrieved TempVars
	 * instances must be returned via TempVars.release().
	 * This returns an available instance of the TempVar public class ensuring this
	 * particular instance is never used elsewhere in the mean time.
	 */
	public class TempVars
	{
		/**
		 * Allow X instances of TempVars.
		 */
		private static var STACK_SIZE:int = 5;

		private static var currentIndex:int = 0;

		private static var varStack:Vector.<TempVars> = new Vector.<TempVars>(5, true);

		public static function getTempVars():TempVars
		{
			CF::DEBUG
			{
				Assert.assert(currentIndex <= STACK_SIZE - 1, "Only Allow " + STACK_SIZE + " instances of TempVars");
			}

			var instance:TempVars = varStack[currentIndex];
			if (instance == null)
			{
				instance = new TempVars();
				varStack[currentIndex] = instance;
			}

			currentIndex++;

			instance.isUsed = true;

			return instance;
		}

		private var isUsed:Boolean;

		/**
		 * Fetching triangle from mesh
		 */
		public var triangle:Triangle;
		/**
		 * Color
		 */
		public var color:Color;

		/**
		 * General vectors.
		 */
		public var vect1:Vector3f;
		public var vect2:Vector3f;
		public var vect3:Vector3f;
		public var vect4:Vector3f;
		public var vect5:Vector3f;
		public var vect6:Vector3f;
		public var vect7:Vector3f;
		public var vect8:Vector3f;

		public var vect4f:Vector4f;

		/**
		 * 2D vector
		 */
		public var vect2d:Vector2f;
		public var vect2d2:Vector2f;
		/**
		 * General matrices.
		 */
		public var tempMat3:Matrix3f;
		public var tempMat4:Matrix4f;
		public var tempMat42:Matrix4f;
		/**
		 * General quaternions.
		 */
		public var quat1:Quaternion;
		public var quat2:Quaternion;

		/**
		 * Plane
		 */
		public var plane:Plane;

		/**
		 * BoundingBox ray collision
		 */
		public var fWdU:Vector.<Number>;
		public var fAWdU:Vector.<Number>;
		public var fDdU:Vector.<Number>;
		public var fADdU:Vector.<Number>;
		public var fAWxDdU:Vector.<Number>;

		/**
		 * BIHTree
		 */
		public var bihSwapTmp:Vector.<Number> = new Vector.<Number>(9, true);
		public var bihStack:Vector.<BIHStackData> = new Vector.<BIHStackData>();

		public function TempVars()
		{
			isUsed = false;

			triangle = new Triangle();

			color = new Color();

			vect1 = new Vector3f();
			vect2 = new Vector3f();
			vect3 = new Vector3f();
			vect4 = new Vector3f();
			vect5 = new Vector3f();
			vect6 = new Vector3f();
			vect7 = new Vector3f();

			vect4f = new Vector4f();

			vect2d = new Vector2f();
			vect2d2 = new Vector2f();

			tempMat3 = new Matrix3f();
			tempMat4 = new Matrix4f();
			tempMat42 = new Matrix4f();

			quat1 = new Quaternion();
			quat2 = new Quaternion();

			plane = new Plane();

			fWdU = new Vector.<Number>(3, true);
			fAWdU = new Vector.<Number>(3, true);
			fDdU = new Vector.<Number>(3, true);
			fADdU = new Vector.<Number>(3, true);
			fAWxDdU = new Vector.<Number>(3, true);
		}

		public function release():void
		{
			Assert.assert(isUsed, "This instance of TempVars was already released!");

			isUsed = false;

			currentIndex--;

			Assert.assert(varStack[currentIndex] == this, "An instance of TempVars has not been released in a called method!");
		}
	}
}

