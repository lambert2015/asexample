package org.angle3d.texture
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;

	/**
	 * ...
	 * @author andy
	 */

	public class TextureMapBase
	{
		protected var mWidth:int;
		protected var mHeight:int;

		protected var mMipmap:Boolean;

		protected var mDirty:Boolean;

		protected var mTexture:TextureBase;

		protected var mOptimizeForRenderToTexture:Boolean;

		public function TextureMapBase(mipmap:Boolean=false)
		{
			mMipmap=mipmap;
			mDirty=false;
			mOptimizeForRenderToTexture=false;
		}

		public function getTexture(context:Context3D):TextureBase
		{
			if (mTexture == null || mDirty)
			{
				if (mTexture != null)
					mTexture.dispose();

				mTexture=createTexture(context);
				uploadTexture();
				mDirty=false;
			}

			return mTexture;
		}

		public function setMipMap(value:Boolean):void
		{
			if (mMipmap != value)
			{
				mMipmap=value;
				mDirty=true;
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
				mOptimizeForRenderToTexture=value;
				mDirty=true;
			}
		}

		public function invalidateContent():void
		{
			mDirty=true;
		}

		public function dispose():void
		{
			if (mTexture != null)
			{
				mTexture.dispose();
				mTexture=null;
				mDirty=false;
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

			mWidth=width;
			mHeight=height;
		}
	}
}

