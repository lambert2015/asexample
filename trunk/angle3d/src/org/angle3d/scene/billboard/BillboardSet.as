package org.angle3d.scene.billboard
{
	import org.angle3d.math.Color;
	import org.angle3d.math.Matrix3f;
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.queue.ShadowMode;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.mesh.BufferType;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.SubMesh;
	import org.angle3d.scene.mesh.VertexBuffer;

	/**
	 * 布告板集合，主要用于粒子效果
	 */
	public class BillboardSet extends Geometry
	{
		private var mOriginType:int;
		private var mRotationType:int;
		// The type of billboard to render
		private var mBillboardType:int;


		private var mDefaultWidth:Number;
		private var mDefaultHeight:Number;

		//全部使用默认尺寸，速度最快
		private var mAllDefaultSize:Boolean;

		// Use 'true' billboard to cam position facing, rather than camera direcion
		private var mAccurateFacing:Boolean;

		// The number of billboard in the pool.
		private var mPoolSize:int;

		private var mAllDefaultRotation:Boolean;
		private var mWorldSpace:Boolean;
		private var mAutoUpdate:Boolean;
		internal var mBillboardDataChanged:Boolean;

		// Boundary offsets based on origin and camera orientation
		// Final vertex offsets, used where sizes all default to save calcs
		private var mVOffset:Vector.<Vector3f>;
		private var mOwnOffset:Vector.<Vector3f>;

		// Parametric offsets of origin
		private var mRectOff:SimpleRect;

		// Camera axes in billboard space
		private var mCamX:Vector3f;
		private var mCamY:Vector3f;

		// Camera direction in billboard space
		internal var mCamDir:Vector3f;
		// Camera orientation in billboard space
		internal var mCamQ:Quaternion;
		// Camera position in billboard space
		internal var mCamPos:Vector3f;


		private var mTextureCoords:Vector.<SimpleRect>;

		// Common direction for billboards of type BBT_ORIENTED_COMMON and BBT_PERPENDICULAR_COMMON
		private var mCommonDirection:Vector3f;
		// Common up-vector for billboards of type BBT_PERPENDICULAR_SELF and BBT_PERPENDICULAR_COMMON
		private var mCommonUpVector:Vector3f;


		private var mFreeBillboards:Vector.<Billboard>;
		private var mBillboardPool:Vector.<Billboard>;
		private var mActiveBillboards:Vector.<Billboard>;

		//Vertex Buffer
		private var mSubMesh:SubMesh;
		private var mPosBuffer:VertexBuffer;
		private var mColorBuffer:VertexBuffer;
		private var mTexCoordBuffer:VertexBuffer;

		private var mVertices:Vector.<Number>;
		private var mColors:Vector.<Number>;
		private var mTexCoords:Vector.<Number>;

		//control
		private var mControl:BillboardSetControl;

		/**
		 *
		 * @param name
		 * @param poolSize 最少需要一个布告板
		 *
		 */
		public function BillboardSet(name:String, poolSize:int = 1)
		{
			super(name);

			mBillboardType = BillboardType.BBT_POINT;
			mOriginType = BillboardOriginType.BBO_CENTER;
			mRotationType = BillboardRotationType.BBR_VERTEX;

			mAutoUpdate = true;
			mBillboardDataChanged = true;
			mAllDefaultSize = true;
			mAccurateFacing = false;
			mAllDefaultRotation = true;
			mWorldSpace = false;

			mCamX = new Vector3f();
			mCamY = new Vector3f();

			mCamDir = new Vector3f();
			mCamQ = new Quaternion();
			mCamPos = new Vector3f();

			mCommonDirection = new Vector3f(0, 0, 1);
			mCommonUpVector = new Vector3f(0, 1, 0);

			setDefaultDimensions(100, 100);
			setTextureStacksAndSlices(1, 1);

			localShadowMode = ShadowMode.Off;

			mVOffset = new Vector.<Vector3f>(4, true);
			mOwnOffset = new Vector.<Vector3f>(4, true);
			for (var i:int = 0; i < 4; i++)
			{
				mVOffset[i] = new Vector3f();
				mOwnOffset[i] = new Vector3f();
			}

			mRectOff = new SimpleRect();

			mBillboardPool = new Vector.<Billboard>();
			mFreeBillboards = new Vector.<Billboard>();
			mActiveBillboards = new Vector.<Billboard>();
			setPoolSize(poolSize);

			mControl = new BillboardSetControl();
			addControl(mControl);
		}

		public function setPoolSize(size:int):void
		{
			var currSize:int = mBillboardPool.length;
			if (currSize >= size)
				return;

			this.increasePool(size);

			for (var i:int = currSize; i < size; ++i)
			{
				// Add new items to the queue
				mFreeBillboards.push(mBillboardPool[i]);
			}

			mPoolSize = size;

			_createBuffers();
		}



		public function increasePool(size:int):void
		{
			var oldSize:int = mBillboardPool.length;

			mBillboardPool.length = size;
			for (var i:int = oldSize; i < size; ++i)
			{
				mBillboardPool[i] = new Billboard(new Vector3f(), this);
			}
		}

		public function destroy():void
		{

		}

		/**
		 * 生成一个新的布告板
		 */
		public function createBillboard(position:Vector3f, color:uint = 0xFFFFFF):Billboard
		{
			if (mFreeBillboards.length == 0)
			{
				return null;
			}

			var newBill:Billboard = mFreeBillboards.shift();
			newBill.reset();

			mActiveBillboards.push(newBill);

			newBill.width = mDefaultWidth;
			newBill.height = mDefaultHeight;
			newBill.parentSet = this;
			newBill.color = color;
			newBill.position.copyFrom(position);
			return newBill;
		}

		public function getNumBillboards():uint
		{
			return mActiveBillboards.length;
		}

		/**
		 * Empties this set of all billboards.
		 */
		public function clear():void
		{
			var activeCount:int = mActiveBillboards.length;
			for (var i:int = 0; i < activeCount; i++)
			{
				mFreeBillboards.push(mActiveBillboards[i]);
			}
			mActiveBillboards.length = 0;
		}

		public function getActiveBillboards():Vector.<Billboard>
		{
			return mActiveBillboards;
		}

		public function getBillboardAt(index:int):Billboard
		{
			return mActiveBillboards[index];
		}

		public function removeBillboardAt(index:int):void
		{
			var bill:Billboard = mActiveBillboards[index];
			mActiveBillboards.splice(index, 1);

			mFreeBillboards.push(bill);
		}

		public function removeBillboard(billboard:Billboard):void
		{
			var index:int = mActiveBillboards.indexOf(billboard);
			if (index > -1)
			{
				mActiveBillboards.splice(index, 1);
				mFreeBillboards.push(billboard);
			}
		}

		/**
		 * 设置布告板的注册点
		 */
		public function setOriginType(origin:int):void
		{
			mOriginType = origin;

			//计算偏移数据
			switch (mOriginType)
			{
				case BillboardOriginType.BBO_CENTER:
					mRectOff.setTo(-0.5, 0.5, 0.5, -0.5);
					break;
				case BillboardOriginType.BBO_TOP_LEFT:
					mRectOff.setTo(0, 1, 0, -1);
					break;
				case BillboardOriginType.BBO_TOP_CENTER:
					mRectOff.setTo(-0.5, 0.5, 0, -1);
					break;
				case BillboardOriginType.BBO_TOP_RIGHT:
					mRectOff.setTo(-1.0, 0, 0, -1);
					break;
				case BillboardOriginType.BBO_CENTER_LEFT:
					mRectOff.setTo(0, 1, 0.5, -0.5);
					break;
				case BillboardOriginType.BBO_CENTER_RIGHT:
					mRectOff.setTo(-1, 0, 0.5, -0.5);
					break;
				case BillboardOriginType.BBO_BOTTOM_LEFT:
					mRectOff.setTo(0, 1, 1, 0);
					break;
				case BillboardOriginType.BBO_BOTTOM_CENTER:
					mRectOff.setTo(-0.5, 0.5, 1, 0);
					break;
				case BillboardOriginType.BBO_BOTTOM_RIGHT:
					mRectOff.setTo(-1.0, 0, 1, 0);
					break;
			}
		}

		public function getOriginType():int
		{
			return mOriginType;
		}

		/**
		 * 设置布告板旋转方式，可以旋转顶点坐标或者是旋转贴图坐标
		 */
		public function setRotationType(rotationType:int):void
		{
			mRotationType = rotationType;
		}

		public function getRotationType():int
		{
			return mRotationType;
		}

		/**
		 * 设置布告板默认大小
		 */
		public function setDefaultDimensions(width:Number, height:Number):void
		{
			mDefaultWidth = width;
			mDefaultHeight = height;
		}

		public function setDefaultWidth(width:Number):void
		{
			mDefaultWidth = width;
		}

		public function getDefaultWidth():Number
		{
			return mDefaultWidth;
		}

		public function setDefaultHeight(height:Number):void
		{
			mDefaultHeight = height;
		}

		public function getDefaultHeight():Number
		{
			return mDefaultHeight;
		}

		/**
		 * 开始修改具体布告板前需要准备的数据
		 */
		/* NOTE: most engines generate world coordinates for the billboards
		directly, taking the world axes of the camera as offsets to the
		center points. I take a different approach, reverse-transforming
		the camera world axes into local billboard space.
		Why?
		Well, it's actually more efficient this way, because I only have to
		reverse-transform using the billboardset world matrix (inverse)
		once, from then on it's simple additions (assuming identically
		sized billboards). If I transformed every billboard center by it's
		world transform, that's a matrix multiplication per billboard
		instead.
		I leave the final transform to the render pipeline since that can
		use hardware TnL if it is available.
		*/
		public function beginBillboards(numBillboards:uint = 0):void
		{
			// Generate axes etc up-front if not oriented per-billboard
			if (mBillboardType != BillboardType.BBT_ORIENTED_SELF && mBillboardType != BillboardType.BBT_PERPENDICULAR_SELF && !(mAccurateFacing && mBillboardType != BillboardType.BBT_PERPENDICULAR_COMMON))
			{
				genBillboardAxes(mCamX, mCamY);

				/* If all billboards are the same size we can precalculate the
				offsets and just use '+' instead of '*' for each billboard,
				and it should be faster.
				*/
				genVertOffsets(mDefaultWidth, mDefaultHeight, mCamX, mCamY, mVOffset);
			}
		}

		/**
		 * 修改布告板的具体数值，位置，贴图坐标等等
		 */
		public function injectBillboard(index:int, bb:Billboard):void
		{
			if (mBillboardType == BillboardType.BBT_ORIENTED_SELF || mBillboardType == BillboardType.BBT_PERPENDICULAR_SELF || (mAccurateFacing && mBillboardType != BillboardType.BBT_PERPENDICULAR_COMMON))
			{
				// Have to generate axes & offsets per billboard
				genBillboardAxes(mCamX, mCamY, bb);
			}

			// If they're all the same size
			if (mAllDefaultSize)
			{
				/* No per-billboard checking, just blast through.
				Saves us an if clause every billboard which may
				make a difference.
				*/
				if (mBillboardType == BillboardType.BBT_ORIENTED_SELF || mBillboardType == BillboardType.BBT_PERPENDICULAR_SELF || (mAccurateFacing && mBillboardType != BillboardType.BBT_PERPENDICULAR_COMMON))
				{
					genVertOffsets(mDefaultWidth, mDefaultHeight, mCamX, mCamY, mVOffset);
				}
				genVertices(index, mVOffset, bb);
			}
			else // not all default size
			{
				// If it has own dimensions, or self-oriented, gen offsets
				if (mBillboardType == BillboardType.BBT_ORIENTED_SELF || mBillboardType == BillboardType.BBT_PERPENDICULAR_SELF || bb.ownDimensions || (mAccurateFacing && mBillboardType != BillboardType.BBT_PERPENDICULAR_COMMON))
				{
					// Generate using own dimensions
					genVertOffsets(bb.width, bb.height, mCamX, mCamY, mOwnOffset);
					// Create vertex data
					genVertices(index, mOwnOffset, bb);
				}
				else // Use default dimension, already computed before the loop, for faster creation
				{
					genVertices(index, mVOffset, bb);
				}
			}
		}

		/**
		 * 布告板修改结束
		 */
		public function endBillboards():void
		{
			/**
			 * 补齐不活动部分坐标，设置所有坐标为0既可，这样他们就不可见了
			 * 颜色部分不需要修改了
			 */
			var i:int;
			var activeCount:int = mActiveBillboards.length * 12;
			var totalCount:int = mPoolSize * 12;
			for (i = activeCount; i < totalCount; i++)
			{
				mVertices[i] = 0;
			}

			mPosBuffer.updateData(mVertices);
			mColorBuffer.updateData(mColors);
			mTexCoordBuffer.updateData(mTexCoords);

			mMesh.validate();

			mBillboardDataChanged = false;
		}

		override public function updateGeometricState():void
		{
			super.updateGeometricState();
		}

		/**
		 * 布告板类型
		 */
		public function setBillboardType(type:int):void
		{
			mBillboardType = type;
		}

		public function getBillboardType():int
		{
			return mBillboardType;
		}

		public function setCommonDirection(vec:Vector3f):void
		{
			mCommonDirection.copyFrom(vec);
		}

		public function getCommonDirection():Vector3f
		{
			return mCommonDirection;
		}

		public function setCommonUpVector(vec:Vector3f):void
		{
			mCommonUpVector.copyFrom(vec);
		}

		public function getCommonUpVector():Vector3f
		{
			return mCommonUpVector;
		}

		/**
		 * 设置布告板是否使用精确的面向模式，
		 * 优化情况下只使用相机的方向
		 * 精确情况下使用布告板的注册点到相机坐标这个向量
		 * 通知只需要使用相机的方向即可，这样速度快很多，精确度大部分情况下也满足视觉需求
		 */
		public function setUseAccurateFacing(acc:Boolean):void
		{
			mAccurateFacing = acc;
		}

		public function getUseAccurateFacing():Boolean
		{
			return mAccurateFacing;
		}

		/**
		 * 布告板是否被视为在世界坐标内，默认为false
		 */
		public function set inWorldSpace(ws:Boolean):void
		{
			mWorldSpace = ws;
		}

		public function get inWorldSpace():Boolean
		{
			return mWorldSpace;
		}

		public function setTextureCoords(coords:Vector.<SimpleRect>, numCoords:uint):void
		{
			if (numCoords == 0 || coords == null)
			{
				setTextureStacksAndSlices(1, 1);
				return;
			}

			mTextureCoords = new Vector.<SimpleRect>(numCoords);
			var count:int = mTextureCoords.length;
			for (var i:int = 0; i < count; i++)
			{
				mTextureCoords[i] = coords[i];
			}
		}

		/**
		 * 贴图包含多个动画时使用
		 */
		public function setTextureStacksAndSlices(stacks:int, slices:int):void
		{
			if (stacks == 0)
				stacks = 1;
			if (slices == 0)
				slices = 1;

			//  clear out any previous allocation (as vectors may not shrink)
			mTextureCoords = new Vector.<SimpleRect>(stacks * slices);
			var count:int = mTextureCoords.length;
			for (var i:int = 0; i < count; i++)
			{
				mTextureCoords[i] = new SimpleRect();
			}

			//  make room
			var coordIndex:uint = 0;
			//  spread the U and V coordinates across the rects
			for (var v:int = 0; v < stacks; ++v)
			{
				//  (float)X / X is guaranteed to be == 1.0f for X up to 8 million, so
				//  our range of 1..256 is quite enough to guarantee perfect coverage.
				var top:Number = v / stacks;
				var bottom:Number = (v + 1) / stacks;
				for (var u:int = 0; u < slices; ++u)
				{
					var r:SimpleRect = mTextureCoords[coordIndex++];
					r.left = u / slices;
					r.bottom = bottom;
					r.right = (u + 1) / slices;
					r.top = top;
				}
			}
		}

		/**
		 *是否自动更新
		 */
		public function setAutoUpdate(autoUpdate:Boolean):void
		{
			mAutoUpdate = autoUpdate;
		}

		public function getAutoUpdate():Boolean
		{
			return mAutoUpdate;
		}

		/**
		 * 用于布告板不使用自动更新手动提示更新布告板
		 * 将在下一帧更新布告板GPU数据
		 */
		public function notifyBillboardDataChanged():void
		{
			mBillboardDataChanged = true;
		}

		/**
		 * 内部使用
		 * 由布告板通知BillboardSet其尺寸变化了
		 */
		internal function notifyBillboardResized():void
		{
			mAllDefaultSize = false;
		}

		/**
		 * 内部使用
		 * 由布告板通知BillboardSet其旋转变化了
		 */
		internal function notifyBillboardRotated():void
		{
			mAllDefaultRotation = false;
		}

		//-----------------------------------------------------------------------
		// The internal methods which follow are here to allow maximum flexibility as to 
		//  when various components of the calculation are done. Depending on whether the
		//  billboards are of fixed size and whether they are point or oriented type will
		//  determine how much calculation has to be done per-billboard. NOT a one-size fits all approach.
		//-----------------------------------------------------------------------
		/**
		 * Internal method for generating billboard corners.
		 * Optional parameter pBill is only present for type BBT_ORIENTED_SELF and BBT_PERPENDICULAR_SELF
		 */
		private function genBillboardAxes(axisX:Vector3f, axisY:Vector3f, billboard:Billboard = null):void
		{
			// If we're using accurate facing, recalculate camera direction per BB
			if (mAccurateFacing && (mBillboardType == BillboardType.BBT_POINT || mBillboardType == BillboardType.BBT_ORIENTED_COMMON || mBillboardType == BillboardType.BBT_ORIENTED_SELF))
			{
				// cam . bb direction
				billboard.position.subtract(mCamPos, mCamDir);
				mCamDir.normalizeLocal();
			}

			switch (mBillboardType)
			{
				case BillboardType.BBT_POINT:
					if (mAccurateFacing)
					{
						// Point billboards will have 'up' based on but not equal to cameras
						// Use pY temporarily to avoid allocation
						mCamQ.multiplyVector(Vector3f.Y_AXIS, axisY);
						mCamDir.cross(axisY, axisX);
						axisX.normalizeLocal();
						axisX.cross(mCamDir, axisY);
					}
					else
					{
						// Get camera axes for X and Y (depth is irrelevant)
						mCamQ.multiplyVector(Vector3f.X_AXIS, axisX);
						mCamQ.multiplyVector(Vector3f.Y_AXIS, axisY);
					}
					break;
				case BillboardType.BBT_ORIENTED_COMMON:
					// Y-axis is common direction
					// X-axis is cross with camera direction
					axisY.copyFrom(mCommonDirection);
					mCamDir.cross(axisY, axisX);
					axisX.normalizeLocal();
					break;
				case BillboardType.BBT_ORIENTED_SELF:
					// Y-axis is direction
					// X-axis is cross with camera direction
					// Scale direction first
					axisY.copyFrom(billboard.direction);
					mCamDir.cross(axisY, axisX);
					axisX.normalizeLocal();
					break;
				case BillboardType.BBT_PERPENDICULAR_COMMON:
					// X-axis is up-vector cross common direction
					// Y-axis is common direction cross X-axis
					mCommonUpVector.cross(mCommonDirection, axisX);
					mCommonDirection.cross(axisX, axisY);
					break;
				case BillboardType.BBT_PERPENDICULAR_SELF:
					// X-axis is up-vector cross own direction
					// Y-axis is own direction cross X-axis
					mCommonUpVector.cross(billboard.direction, axisX);
					axisX.normalizeLocal();
					billboard.direction.cross(axisX, axisY);
					break;
			}
		}

		/** Internal method for generating vertex data.
		 @param offsets Array of 4 Vector3 offsets
		 @param pBillboard Reference to billboard
		 */
		private var mColor:Color = new Color();
		private var mRotationMat:Matrix3f = new Matrix3f();

		private function genVertices(index:int, offsets:Vector.<Vector3f>, bb:Billboard):void
		{
			mColor.setColor(bb.color);

			var r:SimpleRect = bb.useTexcoordRect ? bb.texcoordRect : mTextureCoords[bb.texcoordIndex];

			var bbpx:Number = bb.position.x;
			var bbpy:Number = bb.position.y;
			var bbpz:Number = bb.position.z;

			var index8:int = index * 8;
			var index12:int = index * 12;
			var index16:int = index * 16;

			// Color,颜色都一样
			for (var i:int = 0; i < 4; i++)
			{
				mColors[index16 + i * 4 + 0] = mColor.r;
				mColors[index16 + i * 4 + 1] = mColor.g;
				mColors[index16 + i * 4 + 2] = mColor.b;
				mColors[index16 + i * 4 + 3] = mColor.a;
			}

			if (mAllDefaultRotation || bb.rotation == 0)
			{
				// Left-top
				// Positions
				mVertices[index12 + 0] = offsets[0].x + bbpx;
				mVertices[index12 + 1] = offsets[0].y + bbpy;
				mVertices[index12 + 2] = offsets[0].z + bbpz;

				// Texture coords
				mTexCoords[index8 + 0] = r.left;
				mTexCoords[index8 + 1] = r.top;

				// Right-top
				// Positions
				mVertices[index12 + 3] = offsets[1].x + bbpx;
				mVertices[index12 + 4] = offsets[1].y + bbpy;
				mVertices[index12 + 5] = offsets[1].z + bbpz;

				// Texture coords
				mTexCoords[index8 + 2] = r.right;
				mTexCoords[index8 + 3] = r.top;

				// Left-bottom
				// Positions
				mVertices[index12 + 6] = offsets[2].x + bbpx;
				mVertices[index12 + 7] = offsets[2].y + bbpy;
				mVertices[index12 + 8] = offsets[2].z + bbpz;

				// Texture coords
				mTexCoords[index8 + 4] = r.left;
				mTexCoords[index8 + 5] = r.bottom;

				// Right-bottom
				// Positions
				mVertices[index12 + 9] = offsets[3].x + bbpx;
				mVertices[index12 + 10] = offsets[3].y + bbpy;
				mVertices[index12 + 11] = offsets[3].z + bbpz;

				// Texture coords
				mTexCoords[index8 + 6] = r.right;
				mTexCoords[index8 + 7] = r.bottom;
			}
			else if (mRotationType == BillboardRotationType.BBR_VERTEX)
			{
				// TODO: Cache axis when billboard type is BBT_POINT or BBT_PERPENDICULAR_COMMON
				var offset30:Vector3f = offsets[3].subtract(offsets[0]);
				var offset21:Vector3f = offsets[2].subtract(offsets[1]);

				var axis:Vector3f = offset30.cross(offset21);
				axis.normalizeLocal();

				mRotationMat.fromAngleAxis(bb.rotation, axis);

				var pt:Vector3f = new Vector3f();

				// Left-top
				// Positions
				mRotationMat.multVec(offsets[0], pt);
				mVertices[index12 + 0] = pt.x + bbpx;
				mVertices[index12 + 1] = pt.y + bbpy;
				mVertices[index12 + 2] = pt.z + bbpz;

				// Texture coords
				mTexCoords[index8 + 0] = r.left;
				mTexCoords[index8 + 1] = r.top;

				// Right-top
				// Positions
				mRotationMat.multVec(offsets[1], pt);
				mVertices[index12 + 3] = pt.x + bbpx;
				mVertices[index12 + 4] = pt.y + bbpy;
				mVertices[index12 + 5] = pt.z + bbpz;

				// Texture coords
				mTexCoords[index8 + 2] = r.right;
				mTexCoords[index8 + 3] = r.top;

				// Left-bottom
				// Positions
				mRotationMat.multVec(offsets[2], pt);
				mVertices[index12 + 6] = pt.x + bbpx;
				mVertices[index12 + 7] = pt.y + bbpy;
				mVertices[index12 + 8] = pt.z + bbpz;

				// Texture coords
				mTexCoords[index8 + 4] = r.left;
				mTexCoords[index8 + 5] = r.bottom;

				// Right-bottom
				// Positions
				mRotationMat.multVec(offsets[3], pt);
				mVertices[index12 + 9] = pt.x + bbpx;
				mVertices[index12 + 10] = pt.y + bbpy;
				mVertices[index12 + 11] = pt.z + bbpz;

				// Texture coords
				mTexCoords[index8 + 6] = r.right;
				mTexCoords[index8 + 7] = r.bottom;
			}
			else //if(mRotationType == BillboardRotationType.BBR_TEXCOORD)
			{
				var cos_rot:Number = Math.cos(bb.rotation);
				var sin_rot:Number = Math.sin(bb.rotation);

				var halfWidth:Number = r.width * 0.5;
				var halfHeight:Number = r.height * 0.5;
				var mid_u:Number = r.left + halfWidth;
				var mid_v:Number = r.top + halfHeight;

				var cos_rot_w:Number = cos_rot * halfWidth;
				var cos_rot_h:Number = cos_rot * halfHeight;
				var sin_rot_w:Number = sin_rot * halfWidth;
				var sin_rot_h:Number = sin_rot * halfHeight;

				// Left-top
				// Positions
				mVertices[index12 + 0] = offsets[0].x + bbpx;
				mVertices[index12 + 1] = offsets[0].y + bbpy;
				mVertices[index12 + 2] = offsets[0].z + bbpz;

				// Texture coords
				mTexCoords[index8 + 0] = mid_u - cos_rot_w + sin_rot_h;
				mTexCoords[index8 + 1] = mid_v - sin_rot_w - cos_rot_h;

				// Right-top
				// Positions
				mVertices[index12 + 3] = offsets[1].x + bbpx;
				mVertices[index12 + 4] = offsets[1].y + bbpy;
				mVertices[index12 + 5] = offsets[1].z + bbpz;

				// Texture coords
				mTexCoords[index8 + 2] = mid_u + cos_rot_w + sin_rot_h;
				mTexCoords[index8 + 3] = mid_v + sin_rot_w - cos_rot_h;

				// Left-bottom
				// Positions
				mVertices[index12 + 6] = offsets[2].x + bbpx;
				mVertices[index12 + 7] = offsets[2].y + bbpy;
				mVertices[index12 + 8] = offsets[2].z + bbpz;

				// Texture coords
				mTexCoords[index8 + 4] = mid_u - cos_rot_w - sin_rot_h;
				mTexCoords[index8 + 5] = mid_v - sin_rot_w + cos_rot_h;

				// Right-bottom
				// Positions
				mVertices[index12 + 9] = offsets[3].x + bbpx;
				mVertices[index12 + 10] = offsets[3].y + bbpy;
				mVertices[index12 + 11] = offsets[3].z + bbpz;

				// Texture coords
				mTexCoords[index8 + 6] = mid_u + cos_rot_w - sin_rot_h;
				mTexCoords[index8 + 7] = mid_v + sin_rot_w + cos_rot_h;
			}
		}

		/** Internal method generates vertex offsets.
		 @remarks
		 Takes in parametric offsets as generated from getParametericOffsets, width and height values
		 and billboard x and y axes as generated from genBillboardAxes.
		 Fills output array of 4 vectors with vector offsets
		 from origin for left-top, right-top, left-bottom, right-bottom corners.
		 */
		private var vLeftOff:Vector3f = new Vector3f();
		private var vRightOff:Vector3f = new Vector3f();
		private var vTopOff:Vector3f = new Vector3f();
		private var vBottomOff:Vector3f = new Vector3f();

		private function genVertOffsets(width:Number, height:Number, xAxis:Vector3f, yAxis:Vector3f, pDestVec:Vector.<Vector3f>):void
		{

			/* Calculate default offsets. Scale the axes by
			parametric offset and dimensions, ready to be added to
			positions.
			*/

			xAxis.scale(mRectOff.left * width, vLeftOff);
			xAxis.scale(mRectOff.right * width, vRightOff);
			yAxis.scale(mRectOff.top * height, vTopOff);
			yAxis.scale(mRectOff.bottom * height, vBottomOff);

			// Make final offsets to vertex positions
			pDestVec[0].x = vLeftOff.x + vTopOff.x;
			pDestVec[0].y = vLeftOff.y + vTopOff.y;
			pDestVec[0].z = vLeftOff.z + vTopOff.z;

			pDestVec[1].x = vRightOff.x + vTopOff.x;
			pDestVec[1].y = vRightOff.y + vTopOff.y;
			pDestVec[1].z = vRightOff.z + vTopOff.z;

			pDestVec[2].x = vLeftOff.x + vBottomOff.x;
			pDestVec[2].y = vLeftOff.y + vBottomOff.y;
			pDestVec[2].z = vLeftOff.z + vBottomOff.z;

			pDestVec[3].x = vRightOff.x + vBottomOff.x;
			pDestVec[3].y = vRightOff.y + vBottomOff.y;
			pDestVec[3].z = vRightOff.z + vBottomOff.z;
		}

		/**
		 * 创建Buffer
		 * indices创建后就不需要修改了
		 */

		private function _createBuffers():void
		{
			mVertices = new Vector.<Number>(mPoolSize * 12, true);
			mColors = new Vector.<Number>(mPoolSize * 16, true);
			mTexCoords = new Vector.<Number>(mPoolSize * 8, true);

			var indices:Vector.<uint> = new Vector.<uint>(mPoolSize * 6, true);

			/**
			 *
			 *  0-----1
			 * 	|    /|
			 * 	|  /  |
			 * 	|/    |
			 * 	2-----3
			 */
			//一共mPoolSize个布告板
			for (var i:int = 0; i < mPoolSize; i++)
			{
				var id2:int = i * 2;
				var id4:int = i * 4;
				var id6:int = i * 6;
				var id16:int = i * 16;

				// triangle 1
				indices[id6 + 0] = id4 + 1;
				indices[id6 + 1] = id4 + 0;
				indices[id6 + 2] = id4 + 2;

				// triangle 2
				indices[id6 + 3] = id4 + 1;
				indices[id6 + 4] = id4 + 2;
				indices[id6 + 5] = id4 + 3;

				mTexCoords[id2 + 0] = 0;
				mTexCoords[id2 + 1] = 1;

				mTexCoords[id2 + 2] = 1;
				mTexCoords[id2 + 3] = 1;

				mTexCoords[id2 + 4] = 0;
				mTexCoords[id2 + 5] = 0;

				mTexCoords[id2 + 6] = 1;
				mTexCoords[id2 + 7] = 0;

				for (var j:int = 0; j < 4; j++)
				{
					var id16j4:int = id16 + j * 4;

					mColors[id16j4 + 0] = 1;
					mColors[id16j4 + 1] = 1;
					mColors[id16j4 + 2] = 1;
					mColors[id16j4 + 3] = 1;
				}
			}


			mSubMesh = new SubMesh();
			mSubMesh.setIndices(indices);
			mSubMesh.setVertexBuffer(BufferType.POSITION, 3, mVertices);
			mSubMesh.setVertexBuffer(BufferType.TEXCOORD, 2, mTexCoords);
			mSubMesh.setVertexBuffer(BufferType.COLOR, 4, mColors);

			mPosBuffer = mSubMesh.getVertexBuffer(BufferType.POSITION);
			mColorBuffer = mSubMesh.getVertexBuffer(BufferType.COLOR);
			mTexCoordBuffer = mSubMesh.getVertexBuffer(BufferType.TEXCOORD);

			mMesh = new Mesh();
			mMesh.addSubMesh(mSubMesh);
			this.setMesh(mMesh);
		}

		private function _destroyBuffers():void
		{
			if (mSubMesh != null)
			{
				mMesh.removeSubMesh(mSubMesh);
			}
		}
	}
}
