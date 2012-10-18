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
		protected var _width:int;
		protected var _height:int;

		protected var _mipmap:Boolean;

		protected var _dirty:Boolean;

		protected var _texture:TextureBase;

		protected var _optimizeForRenderToTexture:Boolean;

		public function TextureMapBase(mipmap:Boolean = false)
		{
			_mipmap = mipmap;
			_dirty = false;
			_optimizeForRenderToTexture = false;
		}

		public function getTexture(context:Context3D):TextureBase
		{
			if (_texture == null || _dirty)
			{
				if (_texture != null)
					_texture.dispose();

				_texture = createTexture(context);
				uploadTexture();
				_dirty = false;
			}

			return _texture;
		}

		public function setMipMap(value:Boolean):void
		{
			if (_mipmap != value)
			{
				_mipmap = value;
				_dirty = true;
			}
		}

		public function getMipMap():Boolean
		{
			return _mipmap;
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}

		/**
		 *  如果纹理很可能用作呈现目标，则设置为 true。
		 */
		public function get optimizeForRenderToTexture():Boolean
		{
			return _optimizeForRenderToTexture;
		}

		/**
		 *  如果纹理很可能用作呈现目标，则设置为 true。
		 */
		public function set optimizeForRenderToTexture(value:Boolean):void
		{
			if (_optimizeForRenderToTexture != value)
			{
				_optimizeForRenderToTexture = value;
				_dirty = true;
			}
		}

		public function invalidateContent():void
		{
			_dirty = true;
		}

		public function dispose():void
		{
			if (_texture != null)
			{
				_texture.dispose();
				_texture = null;
				_dirty = false;
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
			if (_width != width || _height != height)
				dispose();

			_width = width;
			_height = height;
		}
	}
}

