package org.angle3d.texture
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DMipFilter;
	import flash.display3D.Context3DTextureFilter;
	import flash.display3D.Context3DWrapMode;
	import flash.display3D.textures.TextureBase;

	/**
	 * <code>Texture</code> defines a texture object to be used to display an
	 * image on a piece of geometry. The image to be displayed is defined by the
	 * <code>Image</code> class. All attributes required for texture mapping are
	 * contained within this class. This includes mipmapping if desired,
	 * magnificationFilter options, apply options and correction options. Default
	 * values are as follows: minificationFilter - NearestNeighborNoMipMaps,
	 * magnificationFilter - NearestNeighbor, wrap - EdgeClamp on S,T and R, apply -
	 * Modulate, environment - None.
	 *
	 */
	public class TextureMapBase
	{
		protected var mWidth:int;
		protected var mHeight:int;

		protected var mMipmap:Boolean;

		protected var mDirty:Boolean;

		protected var mTexture:TextureBase;

		protected var mOptimizeForRenderToTexture:Boolean;

		private var mMipFilter:String = Context3DMipFilter.MIPNONE;
		private var mTextureFilter:String = Context3DTextureFilter.LINEAR;
		private var mWrapMode:String = Context3DWrapMode.CLAMP;

		private var shadowCompareMode:int = ShadowCompareMode.Off;

		private var mFormat:String = TextureFormat.RGBA;
		private var type:int = TextureType.TwoDimensional;

		public function TextureMapBase(mipmap:Boolean = false)
		{
			mMipmap = mipmap;
			mDirty = false;
			mOptimizeForRenderToTexture = false;
		}

		public final function get shaderKeys():Vector.<String>
		{
			return Vector.<String>([mFormat, mMipFilter, mTextureFilter, mWrapMode]);
		}

		public function getWrapMode():String
		{
			return mWrapMode;
		}

		public function setWrapMode(wrapMode:String):void
		{
			this.mWrapMode = wrapMode;
		}

		public function getFormat():String
		{
			return mFormat;
		}

		public function setFormat(format:String):void
		{
			this.mFormat = format;
		}

		public function getType():int
		{
			return type;
		}

		public function setType(type:int):void
		{
			this.type = type;
		}

		/**
		 * @return the MinificationFilterMode of this texture.
		 */
		public function getMipFilter():String
		{
			return mMipFilter;
		}

		/**
		 * @param minificationFilter
		 *            the new MinificationFilterMode for this texture.
		 * @throws IllegalArgumentException
		 *             if minificationFilter is null
		 */
		public function setMipFilter(minFilter:String):void
		{
			this.mMipFilter = minFilter;
		}

		/**
		 * @return the MagnificationFilterMode of this texture.
		 */
		public function getTextureFilter():String
		{
			return mTextureFilter;
		}

		/**
		 * @param magnificationFilter
		 *            the new MagnificationFilter for this texture.
		 * @throws IllegalArgumentException
		 *             if magnificationFilter is null
		 */
		public function setTextureFilter(magFilter:String):void
		{
			this.mTextureFilter = magFilter;
		}

		/**
		 * @return The ShadowCompareMode of this texture.
		 * @see ShadowCompareMode
		 */
		public function getShadowCompareMode():int
		{
			return shadowCompareMode;
		}

		/**
		 * @param compareMode
		 *            the new ShadowCompareMode for this texture.
		 * @throws IllegalArgumentException
		 *             if compareMode is null
		 * @see ShadowCompareMode
		 */
		public function setShadowCompareMode(compareMode:int):void
		{
			this.shadowCompareMode = compareMode;
		}

		public function getTexture(context:Context3D):TextureBase
		{
			if (mTexture == null || mDirty)
			{
				if (mTexture != null)
					mTexture.dispose();

				mTexture = createTexture(context);
				uploadTexture();
				mDirty = false;
			}

			return mTexture;
		}

		public function setMipMap(value:Boolean):void
		{
			if (mMipmap != value)
			{
				mMipmap = value;
				mDirty = true;
			}
		}

		public function getMipMap():Boolean
		{
			return mMipmap;
		}

		public function get width():int
		{
			return mWidth;
		}

		public function get height():int
		{
			return mHeight;
		}

		/**
		 *  如果纹理很可能用作呈现目标，则设置为 true。
		 */
		public function get optimizeForRenderToTexture():Boolean
		{
			return mOptimizeForRenderToTexture;
		}

		/**
		 *  如果纹理很可能用作呈现目标，则设置为 true。
		 */
		public function set optimizeForRenderToTexture(value:Boolean):void
		{
			if (mOptimizeForRenderToTexture != value)
			{
				mOptimizeForRenderToTexture = value;
				mDirty = true;
			}
		}

		public function invalidateContent():void
		{
			mDirty = true;
		}

		public function dispose():void
		{
			if (mTexture != null)
			{
				mTexture.dispose();
				mTexture = null;
				mDirty = false;
			}
		}

		protected function createTexture(context:Context3D):TextureBase
		{
			return null;
		}

		protected function uploadTexture():void
		{

		}

		protected function setSize(width:int, height:int):void
		{
			if (mWidth != width || mHeight != height)
				dispose();

			mWidth = width;
			mHeight = height;
		}
	}
}

