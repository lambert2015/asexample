package org.angle3d.renderer
{
	import org.angle3d.bounding.BoundingBox;
	import org.angle3d.bounding.BoundingVolume;
	import org.angle3d.math.FastMath;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Plane;
	import org.angle3d.math.PlaneSide;
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Rect;
	import org.angle3d.math.Vector2f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.math.Vector4f;
	import org.angle3d.scene.FrustumIntersect;
	import org.angle3d.utils.TempVars;

	/**
	 * Camera is a standalone, purely mathematical public class for doing
	 * camera-related computations.
	 *
	 * <p>
	 * Given input data such as location, orientation (direction, left, up),
	 * and viewport settings, it can compute data neccessary to render objects
	 * with the graphics library. Two matrices are generated, the view matrix
	 * transforms objects from world space into eye space, while the projection
	 * matrix transforms objects from eye space into clip space.
	 * </p>
	 * <p>Another purpose of the camera public class is to do frustum culling operations,
	 * defined by six planes which define a 3D frustum shape, it is possible to
	 * test if an object bounded by a mathematically defined volume is inside
	 * the camera frustum, and thus to avoid rendering objects that are outside
	 * the frustum
	 * </p>
	 *
	 */
	//TODO 简化，提出Frustum,Camera3D继承Frustum
	public class Camera3D extends Frustum
	{
		/** The camera's name. */
		public var name:String;

		public var width:int;
		public var height:int;

		/**
		 * Camera's location
		 */
		protected var mLocation:Vector3f;
		/**
		 * The orientation of the camera.
		 */
		protected var mRotation:Quaternion;

		//view port coordinates
		protected var mViewPortRect:Rect;

		protected var mViewPortChanged:Boolean;

		protected var mViewMatrix:Matrix4f;
		protected var mViewProjectionMatrix:Matrix4f;
		protected var mProjectionMatrixOverride:Matrix4f;

		protected var mGuiBounding:BoundingBox;

		/**
		 * A mask value set during contains() that allows fast culling of a Node's
		 * children.
		 */
		protected var mPlaneState:int;

		public function Camera3D(width:int, height:int)
		{
			super();

			this.width=width;
			this.height=height;

			onFrustumChange();
			onViewPortChange();
		}

		override protected function _init():void
		{
			super._init();

			mViewPortChanged=true;

			mViewMatrix=new Matrix4f();
			mViewProjectionMatrix=new Matrix4f();

			mGuiBounding=new BoundingBox();

			mLocation=new Vector3f();
			mRotation=new Quaternion();

			mViewPortRect=new Rect(0.0, 1.0, 0.0, 1.0);
		}

		public function copyFrom(cam:Camera3D):void
		{
			mLocation.copyFrom(cam.mLocation);
			mRotation.copyFrom(cam.mRotation);

			mFrustumNear=cam.mFrustumNear;
			mFrustumFar=cam.mFrustumFar;
			mFrustumRect.copyFrom(cam.mFrustumRect);

			mCoeffLeft[0]=cam.mCoeffLeft[0];
			mCoeffLeft[1]=cam.mCoeffLeft[1];
			mCoeffRight[0]=cam.mCoeffRight[0];
			mCoeffRight[1]=cam.mCoeffRight[1];
			mCoeffBottom[0]=cam.mCoeffBottom[0];
			mCoeffBottom[1]=cam.mCoeffBottom[1];
			mCoeffTop[0]=cam.mCoeffTop[0];
			mCoeffTop[1]=cam.mCoeffTop[1];

			mViewPortRect.copyFrom(cam.mViewPortRect);

			this.width=cam.width;
			this.height=cam.height;

			this.mPlaneState=cam.mPlaneState;
			this.mViewPortChanged=cam.mViewPortChanged;
			for (var i:int=0; i < FRUSTUM_PLANES; i++)
			{
				mWorldPlanes[i].normal.copyFrom(cam.mWorldPlanes[i].normal);
				mWorldPlanes[i].constant=cam.mWorldPlanes[i].constant;
			}

			this.mParallelProjection=cam.mParallelProjection;
			if (cam.mProjectionMatrixOverride != null)
			{
				if (mProjectionMatrixOverride == null)
				{
					mProjectionMatrixOverride=cam.mProjectionMatrixOverride.clone();
				}
				else
				{
					mProjectionMatrixOverride.copyFrom(cam.mProjectionMatrixOverride);
				}
			}
			else
			{
				this.mProjectionMatrixOverride=null;
			}
			this.mViewMatrix.copyFrom(cam.mViewMatrix);
			this.mProjectionMatrix.copyFrom(cam.mProjectionMatrix);
			this.mViewProjectionMatrix.copyFrom(cam.mViewProjectionMatrix);

			this.mGuiBounding.copyFrom(cam.mGuiBounding);
		}

		public function clone(newName:String):Camera3D
		{
			var cam:Camera3D=new Camera3D(width, height);
			cam.name=newName;
			cam.mViewPortChanged=true;
			cam.mPlaneState=PlaneSide.None;

			for (var i:int=0; i < FRUSTUM_PLANES; i++)
			{
				cam.mWorldPlanes[i].copyFrom(mWorldPlanes[i]);
			}

			cam.mLocation.copyFrom(mLocation);
			cam.mRotation.copyFrom(mRotation);

			if (mProjectionMatrixOverride != null)
			{
				cam.mProjectionMatrixOverride=mProjectionMatrixOverride.clone();
			}

			cam.mViewMatrix.copyFrom(mViewMatrix);
			cam.mProjectionMatrix.copyFrom(mProjectionMatrix);
			cam.mViewProjectionMatrix.copyFrom(mViewProjectionMatrix);
			cam.mGuiBounding=mGuiBounding.clone() as BoundingBox;

			cam.update();

			return cam;
		}

		/**
		 * Sets a clipPlane for this camera.
		 * The cliPlane is used to recompute the projectionMatrix using the plane as the near plane
		 * This technique is known as the oblique near-plane clipping method introduced by Eric Lengyel
		 * more info here
		 * http://www.terathon.com/code/oblique.html
		 * http://aras-p.info/texts/obliqueortho.html
		 * http://hacksoflife.blogspot.com/2008/12/every-now-and-then-i-come-across.html
		 *
		 * Note that this will work properly only if it's called on each update, and be aware that it won't work properly with the sky bucket.
		 * if you want to handle the sky bucket, look at how it's done in SimpleWaterProcessor.java
		 * @param clipPlane the plane
		 * @param side the side the camera stands from the plane
		 */
		public function setClipPlane(clipPlane:Plane, side:int=-1):void
		{
			if (side <= -1)
			{
				side=clipPlane.whichSide(mLocation);
			}

			var sideFactor:Number=1.0;
			if (side == PlaneSide.Negative)
			{
				sideFactor=-1.0;
			}

			//we are on the other side of the plane no need to clip anymore.
			if (clipPlane.whichSide(mLocation) == side)
			{
				return;
			}

			var newProjectionMatrix:Matrix4f=mProjectionMatrix.clone();
			var ivm:Matrix4f=mViewMatrix.clone();

			var point:Vector3f=clipPlane.normal.clone();
			point.scaleLocal(clipPlane.constant);

			var pp:Vector3f=ivm.multVec(point);
			var pn:Vector3f=ivm.multNormal(clipPlane.normal);

			var clipPlaneV:Vector4f=new Vector4f();
			clipPlaneV.x=pn.x * sideFactor;
			clipPlaneV.y=pn.y * sideFactor;
			clipPlaneV.z=pn.z * sideFactor;
			clipPlaneV.w=-pp.dot(pn) * sideFactor;

			var v:Vector4f=new Vector4f();
			v.x=(FastMath.signum(clipPlaneV.x) + newProjectionMatrix.m02) / newProjectionMatrix.m00;
			v.y=(FastMath.signum(clipPlaneV.y) + newProjectionMatrix.m12) / newProjectionMatrix.m11;
			v.z=-1.0;
			v.w=(1.0 + newProjectionMatrix.m22) / newProjectionMatrix.m23;

			var dot:Number=clipPlaneV.dot(v);
			var c:Vector4f=clipPlaneV.scale(2.0 / dot);

			newProjectionMatrix.m20=c.x - newProjectionMatrix.m30;
			newProjectionMatrix.m21=c.y - newProjectionMatrix.m31;
			newProjectionMatrix.m22=c.z - newProjectionMatrix.m32;
			newProjectionMatrix.m23=c.w - newProjectionMatrix.m33;
			setProjectionMatrix(newProjectionMatrix);
		}

		/**
		 * Resizes this camera's view with the given width and height. This is
		 * similar to constructing a new camera, but reusing the same Object. This
		 * method is called by RenderManager to notify the camera of
		 * changes in the display dimensions.
		 *
		 * @param width the view width
		 * @param height the view height
		 * @param fixAspect If true, the camera's aspect ratio will be recomputed.
		 * Recomputing the aspect ratio requires changing the frustum values.
		 */
		public function resize(width:int, height:int, fixAspect:Boolean=true):void
		{
			this.width=width;
			this.height=height;
			onViewPortChange();

			if (fixAspect)
			{
				mFrustumRect.right=mFrustumRect.top * width / height;
				mFrustumRect.left=-mFrustumRect.right;
				onFrustumChange();
			}
		}

		/**
		 * <code>getLocation</code> retrieves the location vector of the camera.
		 *
		 * @return the position of the camera.
		 * @see Camera#getLocation()
		 */
		public function get location():Vector3f
		{
			return mLocation;
		}

		/**
		 * <code>getRotation</code> retrieves the rotation quaternion of the camera.
		 *
		 * @return the rotation of the camera.
		 */
		public function get rotation():Quaternion
		{
			return mRotation;
		}

		/**
		 * <code>getDirection</code> retrieves the direction vector the camera is
		 * facing.
		 *
		 * @return the direction the camera is facing.
		 * @see Camera#getDirection()
		 */
		public function getDirection(result:Vector3f=null):Vector3f
		{
			return mRotation.getRotationColumn(2, result);
		}

		/**
		 * <code>getLeft</code> retrieves the left axis of the camera.
		 *
		 * @return the left axis of the camera.
		 * @see Camera#getLeft()
		 */
		public function getLeft(result:Vector3f=null):Vector3f
		{
			return mRotation.getRotationColumn(0, result);
		}

		/**
		 * <code>getUp</code> retrieves the up axis of the camera.
		 *
		 * @return the up axis of the camera.
		 * @see Camera#getUp()
		 */
		public function getUp(result:Vector3f=null):Vector3f
		{
			return mRotation.getRotationColumn(1, result);
		}

		/**
		 * <code>getPlaneState</code> returns the state of the frustum planes. So
		 * checks can be made as to which frustum plane has been examined for
		 * culling thus far.
		 *
		 * @return the current plane state int.
		 */
		public function get planeState():int
		{
			return mPlaneState;
		}

		/**
		 * <code>setPlaneState</code> sets the state to keep track of tested
		 * planes for culling.
		 *
		 * @param planeState the updated state.
		 */
		public function set planeState(planeState:int):void
		{
			mPlaneState=planeState;
		}

		/**
		 * <code>setLocation</code> sets the position of the camera.
		 *
		 * @param location the position of the camera.
		 * @see Camera#setLocation(com.jme.math.Vector3f)
		 */
		public function set location(location:Vector3f):void
		{
			mLocation.copyFrom(location);
			onFrameChange();
		}

		/**
		 * <code>setRotation</code> sets the orientation of this camera.
		 * This will be equivelant to setting each of the axes:
		 * <code><br>
		 * cam.setLeft(rotation.getRotationColumn(0));<br>
		 * cam.setUp(rotation.getRotationColumn(1));<br>
		 * cam.setDirection(rotation.getRotationColumn(2));<br>
		 * </code>
		 *
		 * @param rotation the rotation of this camera
		 */
		public function set rotation(rotation:Quaternion):void
		{
			mRotation.copyFrom(rotation);
			onFrameChange();
		}

		/**
		 * <code>lookAtDirection</code> sets the direction the camera is facing
		 * given a direction and an up vector.
		 *
		 * @param direction the direction this camera is facing.
		 */
		public function lookAtDirection(direction:Vector3f, upVector:Vector3f):void
		{
			mRotation.lookAt(direction, upVector);
			onFrameChange();
		}

		/**
		 * <code>setAxes</code> sets the axes (left, up and direction) for this
		 * camera.
		 *
		 * @param left      the left axis of the camera.
		 * @param up        the up axis of the camera.
		 * @param direction the direction the camera is facing.
		 * @see Camera#setAxes(com.jme.math.Vector3f,com.jme.math.Vector3f,com.jme.math.Vector3f)
		 */
		public function setAxes(left:Vector3f, up:Vector3f, direction:Vector3f):void
		{
			mRotation.fromAxes(left, up, direction);
			onFrameChange();
		}

		/**
		 * <code>setAxes</code> uses a rotational matrix to set the axes of the
		 * camera.
		 *
		 * @param axes the matrix that defines the orientation of the camera.
		 */
		public function setAxesFromQuat(axes:Quaternion):void
		{
			mRotation.copyFrom(axes);
			onFrameChange();
		}

		/**
		 * normalizes the camera vectors.
		 */
		public function normalize():void
		{
			mRotation.normalizeLocal();
			onFrameChange();
		}

		/**
		 * <code>setFrame</code> sets the orientation and location of the camera.
		 *
		 * @param location  the point position of the camera.
		 * @param left      the left axis of the camera.
		 * @param up        the up axis of the camera.
		 * @param direction the facing of the camera.
		 */
		public function setFrame(location:Vector3f, left:Vector3f, up:Vector3f, direction:Vector3f):void
		{
			mLocation.copyFrom(location);
			mRotation.fromAxes(left, up, direction);
			onFrameChange();
		}

		/**
		* <code>setFrame</code> sets the orientation and location of the camera.
		*
		* @param location
		*            the point position of the camera.
		* @param axes
		*            the orientation of the camera.
		*/
		public function setFrameFromQuat(location:Vector3f, axes:Quaternion):void
		{
			mLocation.copyFrom(location);
			mRotation.copyFrom(axes);
			onFrameChange();
		}

		/**
		 * <code>lookAt</code> is a convienence method for auto-setting the frame
		 * based on a world position the user desires the camera to look at. It
		 * repoints the camera towards the given position using the difference
		 * between the position and the current camera location as a direction
		 * vector and the worldUpVector to compute up and left camera vectors.
		 *
		 * @param pos      where to look at in terms of world coordinates
		 * @param upVector a normalized vector indicating the up direction of the world.
		 */
		//TODO 优化
		public function lookAt(pos:Vector3f, upVector:Vector3f):void
		{
			var newDirection:Vector3f=pos.subtract(mLocation);
			newDirection.normalizeLocal();

			var newUp:Vector3f=upVector.clone();
			newUp.normalizeLocal();
			if (newUp.isZero())
			{
				newUp.setTo(0, 1, 0);
			}

			var newLeft:Vector3f=newUp.cross(newDirection);
			newLeft.normalizeLocal();
			if (newLeft.isZero())
			{
				if (newDirection.x != 0)
				{
					newLeft.setTo(newDirection.y, -newDirection.x, 0);
				}
				else
				{
					newLeft.setTo(0, newDirection.z, -newDirection.y);
				}
			}

			newUp.copyFrom(newDirection);
			newUp=newUp.cross(newLeft);
			newUp.normalizeLocal();

			mRotation.fromAxes(newLeft, newUp, newDirection);
			mRotation.normalizeLocal();
			onFrameChange();
		}

		/**
		 * <code>update</code> updates the camera parameters by calling
		 * <code>onFrustumChange</code>,<code>onViewPortChange</code> and
		 * <code>onFrameChange</code>.
		 *
		 * @see Camera#update()
		 */
		public function update():void
		{
			onFrustumChange();
			onViewPortChange();
			onFrameChange();
		}

		public function get viewPortRect():Rect
		{
			return mViewPortRect;
		}

		/**
		 * <code>setViewPort</code> sets the boundaries of the viewport
		 *
		 * @param left   the left boundary of the viewport (default: 0)
		 * @param right  the right boundary of the viewport (default: 1)
		 * @param bottom the bottom boundary of the viewport (default: 0)
		 * @param top    the top boundary of the viewport (default: 1)
		 */
		public function setViewPortRect(left:Number, right:Number, bottom:Number, top:Number):void
		{
			mViewPortRect.setTo(left, right, bottom, top);
			onViewPortChange();
		}

		/**
		 * Returns the pseudo distance from the given position to the near
		 * plane of the camera. This is used for render queue sorting.
		 * @param pos The position to compute a distance to.
		 * @return Distance from the far plane to the point.
		 */
		public function distanceToNearPlane(pos:Vector3f):Number
		{
			return mWorldPlanes[NEAR_PLANE].pseudoDistance(pos);
		}

		/**
		 * <code>contains</code> tests a bounding volume against the planes of the
		 * camera's frustum. The frustums planes are set such that the normals all
		 * face in towards the viewable scene. Therefore, if the bounding volume is
		 * on the negative side of the plane is can be culled out.
		 *
		 * NOTE: This method is used internally for culling, for public usage,
		 * the plane state of the bounding volume must be saved and restored, e.g:
		 * <code>BoundingVolume bv;<br/>
		 * Camera c;<br/>
		 * int planeState = bv.getPlaneState();<br/>
		 * bv.setPlaneState(0);<br/>
		 * c.contains(bv);<br/>
		 * bv.setPlaneState(plateState);<br/>
		 * </code>
		 *
		 * @param bound the bound to check for culling
		 * @return See enums in <code>FrustumIntersect</code>
		 */
		//此函数很费时，需要进行优化
		public function contains(bound:BoundingVolume):int
		{
			if (bound == null)
			{
				return FrustumIntersect.Inside;
			}

			var mask:int;
			var rVal:int=FrustumIntersect.Inside;

			var planeCounter:int=FRUSTUM_PLANES;
			while (planeCounter-- > 0)
			{
				if (planeCounter == bound.getCheckPlane())
				{
					continue; // we have already checked this plane at first iteration
				}

				var planeId:int=(planeCounter == FRUSTUM_PLANES) ? bound.getCheckPlane() : planeCounter;

				mask=1 << planeId;
				if ((mPlaneState & mask) == 0)
				{
					var side:int=bound.whichSide(mWorldPlanes[planeId]);

					if (side == PlaneSide.Negative)
					{
						//object is outside of frustum
						bound.setCheckPlane(planeId);
						return FrustumIntersect.Outside;
					}
					else if (side == PlaneSide.Positive)
					{
						//object is visible on *this* plane, so mark this plane
						//so that we don't check it for sub nodes.
						mPlaneState|=mask;
					}
					else
					{
						rVal=FrustumIntersect.Intersects;
							//TODO 直接返回就可以了吧？
					}
				}
			}

			return rVal;
		}

		/**
		 * <code>containsGui</code> tests a bounding volume against the ortho
		 * bounding box of the camera. A bounding box spanning from
		 * 0, 0 to Width, Height. Constrained by the viewport settings on the
		 * camera.
		 *
		 * @param bound the bound to check for culling
		 * @return True if the camera contains the gui element bounding volume.
		 */
		public function containsGui(bound:BoundingVolume):Boolean
		{
			return mGuiBounding.intersects(bound);
		}

		/**
		 * @return the view matrix of the camera.
		 * The view matrix transforms world space into eye space.
		 * This matrix is usually defined by the position and
		 * orientation of the camera.
		 */
		public function getViewMatrix():Matrix4f
		{
			return mViewMatrix;
		}

		/**
		 * Overrides the projection matrix used by the camera. Will
		 * use the matrix for computing the view projection matrix as well.
		 * Use null argument to return to normal functionality.
		 *
		 * @param projMatrix
		 */
		public function setProjectionMatrix(mat:Matrix4f):void
		{
			mProjectionMatrixOverride=mat;
			updateViewProjection();
		}

		/**
		 * @return the projection matrix of the camera.
		 * The view projection matrix  transforms eye space into clip space.
		 * This matrix is usually defined by the viewport and perspective settings
		 * of the camera.
		 */
		public function getProjectionMatrix():Matrix4f
		{
			if (mProjectionMatrixOverride != null)
			{
				return mProjectionMatrixOverride;
			}

			return mProjectionMatrix;
		}

		/**
		 * Updates the view projection matrix.
		 */
		public function updateViewProjection():void
		{
			if (mProjectionMatrixOverride != null)
			{
				mProjectionMatrixOverride.mult(mViewMatrix, mViewProjectionMatrix);
//				mViewProjectionMatrix.copyFrom(mProjectionMatrixOverride);
//				mViewProjectionMatrix.multLocal(mViewMatrix);
			}
			else
			{
				mProjectionMatrix.mult(mViewMatrix, mViewProjectionMatrix);
//				mViewProjectionMatrix.copyFrom(mProjectionMatrix);
//				mViewProjectionMatrix.multLocal(mViewMatrix);
			}
		}

		/**
		 * @return The result of multiplying the projection matrix by the view
		 * matrix. This matrix is required for rendering an object. It is
		 * precomputed so as to not compute it every time an object is rendered.
		 */
		public function getViewProjectionMatrix():Matrix4f
		{
			return mViewProjectionMatrix;
		}

		/**
		 * @return True if the viewport (width, height, left, right, bottom, up)
		 * has been changed. This is needed in the renderer so that the proper
		 * viewport can be set-up.
		 */
		public function isViewportChanged():Boolean
		{
			return mViewPortChanged;
		}

		/**
		 * Clears the viewport changed flag once it has been updated inside
		 * the renderer.
		 */
		public function clearViewportChanged():void
		{
			mViewPortChanged=false;
		}

		/**
		 * Called when the viewport has been changed.
		 */
		public function onViewPortChange():void
		{
			mViewPortChanged=true;
			updateGuiBounding();
		}

		private function updateGuiBounding():void
		{
			var sx:Number=width * mViewPortRect.left;
			var ex:Number=width * mViewPortRect.right;
			var sy:Number=height * mViewPortRect.bottom;
			var ey:Number=height * mViewPortRect.top;
			var xExtent:Number=Math.max(0, (ex - sx) * 0.5);
			var yExtent:Number=Math.max(0, (ey - sy) * 0.5);

			mGuiBounding.setCenter(new Vector3f(sx + xExtent, sy + yExtent, 0));
			mGuiBounding.xExtent=xExtent;
			mGuiBounding.yExtent=yExtent;
			mGuiBounding.zExtent=Number.MAX_VALUE;
		}

		/**
		 * <code>onFrameChange</code> updates the view frame of the camera.
		 */
		override public function onFrameChange():void
		{
			var vars:TempVars=TempVars.getTempVars();

			var left:Vector3f=getLeft(vars.vect1);
			var direction:Vector3f=getDirection(vars.vect2);
			var up:Vector3f=getUp(vars.vect3);

			var dirDotLocation:Number=direction.dot(mLocation);

			// left plane
			var plane:Plane=mWorldPlanes[LEFT_PLANE];
			var normal:Vector3f=plane.normal;
			normal.x=left.x * mCoeffLeft[0] + direction.x * mCoeffLeft[1];
			normal.y=left.y * mCoeffLeft[0] + direction.y * mCoeffLeft[1];
			normal.z=left.z * mCoeffLeft[0] + direction.z * mCoeffLeft[1];
			plane.constant=mLocation.dot(normal);

			// right plane
			plane=mWorldPlanes[RIGHT_PLANE];
			normal=plane.normal;
			normal.x=left.x * mCoeffRight[0] + direction.x * mCoeffRight[1];
			normal.y=left.y * mCoeffRight[0] + direction.y * mCoeffRight[1];
			normal.z=left.z * mCoeffRight[0] + direction.z * mCoeffRight[1];
			plane.constant=mLocation.dot(normal);

			// bottom plane
			plane=mWorldPlanes[BOTTOM_PLANE];
			normal=plane.normal;
			normal.x=up.x * mCoeffBottom[0] + direction.x * mCoeffBottom[1];
			normal.y=up.y * mCoeffBottom[0] + direction.y * mCoeffBottom[1];
			normal.z=up.z * mCoeffBottom[0] + direction.z * mCoeffBottom[1];
			plane.constant=mLocation.dot(normal);

			// top plane
			plane=mWorldPlanes[TOP_PLANE];
			normal=plane.normal;
			normal.x=up.x * mCoeffTop[0] + direction.x * mCoeffTop[1];
			normal.y=up.y * mCoeffTop[0] + direction.y * mCoeffTop[1];
			normal.z=up.z * mCoeffTop[0] + direction.z * mCoeffTop[1];
			plane.constant=mLocation.dot(normal);

			if (parallelProjection)
			{
				mWorldPlanes[LEFT_PLANE].constant+=mFrustumRect.left;
				mWorldPlanes[RIGHT_PLANE].constant-=mFrustumRect.right;
				mWorldPlanes[TOP_PLANE].constant-=mFrustumRect.top;
				mWorldPlanes[BOTTOM_PLANE].constant+=mFrustumRect.bottom;
			}

			// far plane
			mWorldPlanes[FAR_PLANE].normal.setTo(-direction.x, -direction.y, -direction.z);
			mWorldPlanes[FAR_PLANE].constant=-(dirDotLocation + mFrustumFar);

			// near plane
			mWorldPlanes[NEAR_PLANE].normal.setTo(direction.x, direction.y, direction.z);
			mWorldPlanes[NEAR_PLANE].constant=dirDotLocation + mFrustumNear;

			mViewMatrix.fromFrame(mLocation, direction, up, left);

			vars.release();

			updateViewProjection();
		}

		/**
		 * @see Camera#getWorldCoordinates
		 */
		public function getWorldCoordinates(screenPos:Vector2f, zPos:Number, result:Vector3f=null):Vector3f
		{
			if (result == null)
				result=new Vector3f();

			var inverseMat:Matrix4f=mViewProjectionMatrix.invert();

			result.setTo((screenPos.x / width - mViewPortRect.left) / mViewPortRect.width * 2 - 1, (screenPos.y / height - mViewPortRect.bottom) / mViewPortRect.height * 2 - 1, zPos * 2 - 1);

			var w:Number=inverseMat.multProj(result, result);
			result.scaleLocal(1 / w);

			return result;
		}

		/**
		 * Converts the given position from world space to screen space.
		 *
		 * @see Camera#getScreenCoordinates(Vector3f, Vector3f)
		 */
		public function getScreenCoordinates(worldPos:Vector3f, result:Vector3f=null):Vector3f
		{
			if (result == null)
				result=new Vector3f();

			var w:Number=mViewProjectionMatrix.multProj(worldPos, result);
			result.scaleLocal(1 / w);

			result.x=((result.x + 1) * mViewPortRect.width * 0.5 + mViewPortRect.left) * width;
			result.y=((result.y + 1) * mViewPortRect.height * 0.5 + mViewPortRect.bottom) * height;
			result.z=(result.z + 1) * 0.5;

			return result;
		}
	}
}

