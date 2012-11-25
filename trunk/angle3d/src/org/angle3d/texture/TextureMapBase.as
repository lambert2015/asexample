package org.angle3d.texture
{
	import flash.display3D.Context3D;
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
	 * @see com.jme3.texture.Image
	 * @author Mark Powell
	 * @author Joshua Slack
	 * @version $Id: Texture.java 4131 2009-03-19 20:15:28Z blaine.dev $
	 */
	public class TextureMapBase
	{
		protected var mWidth:int;
		protected var mHeight:int;

		protected var mMipmap:Boolean;

		protected var mDirty:Boolean;

		protected var mTexture:TextureBase;

		protected var mOptimizeForRenderToTexture:Boolean;

		private var minificationFilter:String = MinFilter.NoMip;
		private var magnificationFilter:String = MagFilter.Bilinear;
		private var shadowCompareMode:int = ShadowCompareMode.Off;
		private var wrapMode:String = WrapMode.Repeat;
		private var format:String = TextureFormat.RGBA;
		private var type:int = TextureType.TwoDimensional;

		public function TextureMapBase(mipmap:Boolean = false)
		{
			mMipmap = mipmap;
			mDirty = false;
			mOptimizeForRenderToTexture = false;
		}

		public final function get shaderKeys():Vector.<String>
		{
			return Vector.<String>([format, minificationFilter, magnificationFilter, wrapMode]);
		}

		public function getWrapMode():String
		{
			return wrapMode;
		}

		public function setWrapMode(wrapMode:String):void
		{
			this.wrapMode = wrapMode;
		}

		public function getFormat():String
		{
			return format;
		}

		public function setFormat(format:String):void
		{
			this.format = format;
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
		public function getMinFilter():String
		{
			return minificationFilter;
		}

		/**
		 * @param minificationFilter
		 *            the new MinificationFilterMode for this texture.
		 * @throws IllegalArgumentException
		 *             if minificationFilter is null
		 */
		public function setMinFilter(minificationFilter:String):void
		{
			this.minificationFilter = minificationFilter;
		}

		/**
		 * @return the MagnificationFilterMode of this texture.
		 */
		public function getMagFilter():String
		{
			return magnificationFilter;
		}

		/**
		 * @param magnificationFilter
		 *            the new MagnificationFilter for this texture.
		 * @throws IllegalArgumentException
		 *             if magnificationFilter is null
		 */
		public function setMagFilter(magnificationFilter:String):void
		{
			this.magnificationFilter = magnificationFilter;
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

