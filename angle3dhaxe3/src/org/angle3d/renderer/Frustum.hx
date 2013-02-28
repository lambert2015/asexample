package org.angle3d.renderer
{
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Plane;
	import org.angle3d.math.Rect;
	import org.angle3d.math.FastMath;

	class Frustum
	{
		/**
		 * LEFT_PLANE represents the left plane of the camera frustum.
		 */
		public static const LEFT_PLANE:Int = 0;
		/**
		 * RIGHT_PLANE represents the right plane of the camera frustum.
		 */
		public static const RIGHT_PLANE:Int = 1;
		/**
		 * BOTTOM_PLANE represents the bottom plane of the camera frustum.
		 */
		public static const BOTTOM_PLANE:Int = 2;
		/**
		 * TOP_PLANE represents the top plane of the camera frustum.
		 */
		public static const TOP_PLANE:Int = 3;
		/**
		 * FAR_PLANE represents the far plane of the camera frustum.
		 */
		public static const FAR_PLANE:Int = 4;
		/**
		 * NEAR_PLANE represents the near plane of the camera frustum.
		 */
		public static const NEAR_PLANE:Int = 5;
		/**
		 * FRUSTUM_PLANES represents the number of planes of the camera frustum.
		 */
		public static const FRUSTUM_PLANES:Int = 6;

		/**
		 * Distance from camera to near frustum plane.
		 */
		private var mFrustumNear:Float;
		/**
		 * Distance from camera to far frustum plane.
		 */
		private var mFrustumFar:Float;

		private var mFrustumRect:Rect;

		//Temporary values computed in onFrustumChange that are needed if a
		//call is made to onFrameChange.
		private var mCoeffLeft:Vector<Float>;
		private var mCoeffRight:Vector<Float>;
		private var mCoeffBottom:Vector<Float>;
		private var mCoeffTop:Vector<Float>;

		/**
		 * Array holding the planes that this camera will check for culling.
		 */
		private var mWorldPlanes:Vector<Plane>;

		private var mParallelProjection:Bool;
		private var mProjectionMatrix:Matrix4f;

		public function Frustum()
		{
			_init();
		}

		private function _init():Void
		{
			mWorldPlanes = new Vector<Plane>(FRUSTUM_PLANES, true);
			for (var i:Int = 0; i < FRUSTUM_PLANES; i++)
			{
				mWorldPlanes[i] = new Plane();
			}

			mProjectionMatrix = new Matrix4f();

			mFrustumNear = 1.0;
			mFrustumFar = 2.0;
			mFrustumRect = new Rect(-0.5, 0.5, -0.5, 0.5);

			mCoeffLeft = new Vector<Float>(2);
			mCoeffRight = new Vector<Float>(2);
			mCoeffBottom = new Vector<Float>(2);
			mCoeffTop = new Vector<Float>(2);
		}

		/**
		 * <code>onFrustumChange</code> updates the frustum to reflect any changes
		 * made to the planes. The new frustum values are kept in a temporary
		 * location for use when calculating the new frame. The projection
		 * matrix is updated to reflect the current values of the frustum.
		 */
		public function onFrustumChange():Void
		{
			if (!parallelProjection)
			{
				var nearSquared:Float = mFrustumNear * mFrustumNear;
				var leftSquared:Float = mFrustumRect.left * mFrustumRect.left;
				var rightSquared:Float = mFrustumRect.right * mFrustumRect.right;
				var bottomSquared:Float = mFrustumRect.bottom * mFrustumRect.bottom;
				var topSquared:Float = mFrustumRect.top * mFrustumRect.top;

				var inverseLength:Float = 1 / Math.sqrt(nearSquared + leftSquared);
				mCoeffLeft[0] = mFrustumNear * inverseLength;
				mCoeffLeft[1] = -mFrustumRect.left * inverseLength;

				inverseLength = 1 / Math.sqrt(nearSquared + rightSquared);
				mCoeffRight[0] = -mFrustumNear * inverseLength;
				mCoeffRight[1] = mFrustumRect.right * inverseLength;

				inverseLength = 1 / Math.sqrt(nearSquared + bottomSquared);
				mCoeffBottom[0] = mFrustumNear * inverseLength;
				mCoeffBottom[1] = -mFrustumRect.bottom * inverseLength;

				inverseLength = 1 / Math.sqrt(nearSquared + topSquared);
				mCoeffTop[0] = -mFrustumNear * inverseLength;
				mCoeffTop[1] = mFrustumRect.top * inverseLength;
			}
			else
			{
				mCoeffLeft[0] = 1;
				mCoeffLeft[1] = 0;

				mCoeffRight[0] = -1;
				mCoeffRight[1] = 0;

				mCoeffBottom[0] = 1;
				mCoeffBottom[1] = 0;

				mCoeffTop[0] = -1;
				mCoeffTop[1] = 0;
			}

			mProjectionMatrix.fromFrustum(mFrustumNear, mFrustumFar, mFrustumRect.left, mFrustumRect.right, mFrustumRect.top, mFrustumRect.bottom, mParallelProjection);

			// The frame is effected by the frustum values update it as well
			onFrameChange();
		}

		/**
		 * @return true if parallel projection is enable, false if in normal perspective mode
		 * @see #setParallelProjection(Bool)
		 */
		public function get parallelProjection():Bool
		{
			return mParallelProjection;
		}

		/**
		 * Enable/disable parallel projection.
		 *
		 * @param value true to set up this camera for parallel projection is enable, false to enter normal perspective mode
		 */
		public function set parallelProjection(value:Bool):Void
		{
			mParallelProjection = value;
			onFrustumChange();
		}

		/**
		 * <code>getFrustumBottom</code> returns the value of the bottom frustum
		 * plane.
		 *
		 * @return the value of the bottom frustum plane.
		 */
		public function getFrustumRect():Rect
		{
			return mFrustumRect;
		}

		public function get frustumBottom():Float
		{
			return mFrustumRect.bottom;
		}

		/**
		 * <code>setFrustumBottom</code> sets the value of the bottom frustum
		 * plane.
		 *
		 * @param frustumBottom the value of the bottom frustum plane.
		 */
		public function set frustumBottom(frustumBottom:Float):Void
		{
			mFrustumRect.bottom = frustumBottom;
			onFrustumChange();
		}

		/**
		 * <code>getFrustumFar</code> returns the value of the far frustum
		 * plane.
		 *
		 * @return the value of the far frustum plane.
		 */
		public function get frustumFar():Float
		{
			return mFrustumFar;
		}

		/**
		 * <code>setFrustumFar</code> sets the value of the far frustum
		 * plane.
		 *
		 * @param frustumFar the value of the far frustum plane.
		 */
		public function set frustumFar(frustumFar:Float):Void
		{
			this.mFrustumFar = frustumFar;
			onFrustumChange();
		}

		public function get frustumLeft():Float
		{
			return mFrustumRect.left;
		}

		/**
		 * <code>setFrustumLeft</code> sets the value of the left frustum
		 * plane.
		 *
		 * @param frustumLeft the value of the left frustum plane.
		 */
		public function set frustumLeft(frustumLeft:Float):Void
		{
			mFrustumRect.left = frustumLeft;
			onFrustumChange();
		}

		/**
		 * <code>getFrustumNear</code> returns the value of the near frustum
		 * plane.
		 *
		 * @return the value of the near frustum plane.
		 */
		public function get frustumNear():Float
		{
			return mFrustumNear;
		}

		/**
		 * <code>setFrustumNear</code> sets the value of the near frustum
		 * plane.
		 *
		 * @param frustumNear the value of the near frustum plane.
		 */
		public function set frustumNear(frustumNear:Float):Void
		{
			this.mFrustumNear = frustumNear;
			onFrustumChange();
		}


		public function get frustumRight():Float
		{
			return mFrustumRect.right;
		}

		/**
		 * <code>setFrustumRight</code> sets the value of the right frustum
		 * plane.
		 *
		 * @param frustumRight the value of the right frustum plane.
		 */
		public function set frustumRight(frustumRight:Float):Void
		{
			mFrustumRect.right = frustumRight;
			onFrustumChange();
		}

		public function get frustumTop():Float
		{
			return mFrustumRect.top;
		}

		/**
		 * <code>setFrustumRight</code> sets the value of the top frustum
		 * plane.
		 *
		 * @param frustumRight the value of the top frustum plane.
		 */
		public function set frustumTop(frustumTop:Float):Void
		{
			mFrustumRect.top = frustumTop;
			onFrustumChange();
		}

		/**
		 * sets the frustum of this camera object.
		 *
		 * @param near   the near plane.
		 * @param far    the far plane.
		 * @param left   the left plane.
		 * @param right  the right plane.
		 * @param top    the top plane.
		 * @param bottom the bottom plane.
		 */
		public function setFrustum(near:Float, far:Float, left:Float, right:Float, bottom:Float, top:Float):Void
		{
			mFrustumNear = near;
			mFrustumFar = far;

			mFrustumRect.setTo(left, right, bottom, top);
			onFrustumChange();
		}

		public function setFrustumRect(left:Float, right:Float, bottom:Float, top:Float):Void
		{
			mFrustumRect.setTo(left, right, bottom, top);
			onFrustumChange();
		}

		/**
		 * <code>setFrustumPerspective</code> defines the frustum for the camera.  This
		 * frustum is defined by a viewing angle, aspect ratio, and near/far planes
		 *
		 * @param fovY   Frame of view angle along the Y in degrees.
		 * @param aspect Width:Height ratio
		 * @param near   Near view plane distance
		 * @param far    Far view plane distance
		 */
		public function setFrustumPerspective(fovY:Float, aspect:Float, near:Float, far:Float):Void
		{
			var h:Float = Math.tan(fovY * FastMath.DEGTORAD * 0.5) * near;
			var w:Float = h * aspect;

			mFrustumNear = near;
			mFrustumFar = far;
			mFrustumRect.setTo(-w, w, -h, h);

			onFrustumChange();
		}

		/**
		 * <code>onFrameChange</code> updates the view frame of the camera.
		 */
		public function onFrameChange():Void
		{

		}
	}
}
