package org.angle3d.texture;

import flash.display3D.Context3D;
import flash.display3D.Context3DMipFilter;
import flash.display3D.Context3DTextureFilter;
import flash.display3D.Context3DWrapMode;
import flash.display3D.textures.TextureBase;
import haxe.ds.Vector;
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
class TextureMapBase
{
	private var mWidth:Int;
	private var mHeight:Int;

	private var mMipmap:Bool;

	private var mDirty:Bool;

	private var mTexture:TextureBase;

	private var mOptimizeForRenderToTexture:Bool;

	private var mMipFilter:Context3DMipFilter;
	private var mTextureFilter:Context3DTextureFilter;
	private var mWrapMode:Context3DWrapMode;

	private var shadowCompareMode:Int;

	private var mFormat:String;
	private var type:Int;

	public function new(mipmap:Bool = false)
	{
		mMipmap = mipmap;
		mDirty = false;
		mOptimizeForRenderToTexture = false;
		
		
		mMipFilter = Context3DMipFilter.MIPNONE;
		mTextureFilter = Context3DTextureFilter.LINEAR;
		mWrapMode = Context3DWrapMode.CLAMP;

		shadowCompareMode = ShadowCompareMode.Off;

		mFormat = TextureFormat.RGBA;
		type = TextureType.TwoDimensional;
	}

	public var shaderKeys(get, null):Vector<String>;
	private function get_shaderKeys():Vector<String>
	{
		return Vector.fromArrayCopy([mFormat, mMipFilter.getName(), 
		mTextureFilter.getName(), mWrapMode.getName()]);
	}

	public function getWrapMode():Context3DWrapMode
	{
		return mWrapMode;
	}

	public function setWrapMode(wrapMode:Context3DWrapMode):Void
	{
		this.mWrapMode = wrapMode;
	}

	public function getFormat():String
	{
		return mFormat;
	}

	public function setFormat(format:String):Void
	{
		this.mFormat = format;
	}

	public function getType():Int
	{
		return type;
	}

	public function setType(type:Int):Void
	{
		this.type = type;
	}

	/**
	 * @return the MinificationFilterMode of this texture.
	 */
	public function getMipFilter():Context3DMipFilter
	{
		return mMipFilter;
	}

	/**
	 * @param minificationFilter
	 *            the new MinificationFilterMode for this texture.
	 * @throws IllegalArgumentException
	 *             if minificationFilter is null
	 */
	public function setMipFilter(minFilter:Context3DMipFilter):Void
	{
		this.mMipFilter = minFilter;
	}

	/**
	 * @return the MagnificationFilterMode of this texture.
	 */
	public function getTextureFilter():Context3DTextureFilter
	{
		return mTextureFilter;
	}

	/**
	 * @param magnificationFilter
	 *            the new MagnificationFilter for this texture.
	 * @throws IllegalArgumentException
	 *             if magnificationFilter is null
	 */
	public function setTextureFilter(magFilter:Context3DTextureFilter):Void
	{
		this.mTextureFilter = magFilter;
	}

	/**
	 * @return The ShadowCompareMode of this texture.
	 * @see ShadowCompareMode
	 */
	public function getShadowCompareMode():Int
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
	public function setShadowCompareMode(compareMode:Int):Void
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

	public function setMipMap(value:Bool):Void
	{
		if (mMipmap != value)
		{
			mMipmap = value;
			mDirty = true;
		}
	}

	public function getMipMap():Bool
	{
		return mMipmap;
	}

	public var width(get, null):Int;
	private function get_width():Int
	{
		return mWidth;
	}

	public var height(get, null):Int;
	private function get_height():Int
	{
		return mHeight;
	}

	public var optimizeForRenderToTexture(get, set):Bool;
	/**
	 *  如果纹理很可能用作呈现目标，则设置为 true。
	 */
	private function get_optimizeForRenderToTexture():Bool
	{
		return mOptimizeForRenderToTexture;
	}

	/**
	 *  如果纹理很可能用作呈现目标，则设置为 true。
	 */
	private function set_optimizeForRenderToTexture(value:Bool):Bool
	{
		if (mOptimizeForRenderToTexture != value)
		{
			mOptimizeForRenderToTexture = value;
			mDirty = true;
		}
		
		return mOptimizeForRenderToTexture;
	}

	public function invalidateContent():Void
	{
		mDirty = true;
	}

	public function dispose():Void
	{
		if (mTexture != null)
		{
			mTexture.dispose();
			mTexture = null;
			mDirty = false;
		}
	}

	private function createTexture(context:Context3D):TextureBase
	{
		return null;
	}

	private function uploadTexture():Void
	{

	}

	private function setSize(width:Int, height:Int):Void
	{
		if (mWidth != width || mHeight != height)
			dispose();

		mWidth = width;
		mHeight = height;
	}
}

