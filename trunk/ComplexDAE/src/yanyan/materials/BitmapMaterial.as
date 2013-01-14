package yanyan.materials
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Point;
	
	import yanyan.MaterialModel;
	import yanyan.resources.AssetCacheManager;
	import yanyan.resources.AssetLoaderManager;
	
	/**
	 * 位图材质 
	 * 
	 * @author harry
	 * @date 11.15 2012
	 * 
	 */
	public class BitmapMaterial extends ColorMaterial
	{
		// manager
		protected var mAssetCacheManager:AssetCacheManager = null;
		
		public function BitmapMaterial()
		{
			super(0xFFFFFF, 1.0);
			
			mAssetCacheManager = AssetCacheManager.instance;
		}
		
		
		protected var _completeFun:Function = null;
		protected var mAssetLoaderManager:AssetLoaderManager = null;
		public function loadAsset(completeFun:Function):void
		{
			_completeFun = completeFun;
			
			//
			// use asset manager to load asset
			//
			//
			mAssetLoaderManager = AssetLoaderManager.instance
			mAssetLoaderManager.loadAsset(mImagePath, completeHandler); 
		}
		
		
		private function completeHandler(result:Object):void
		{
			mImageBmp = (result.data as Bitmap).bitmapData;
			
			// check
			if( !mIsTexturePowerTwo )
			{
				if( isPowerTwo(mImageBmp.width) && isPowerTwo(mImageBmp.height) )
					mIsTexturePowerTwo = true;
				else
				{
					var newSize:uint = 0;
					newSize =  mImageBmp.width > mImageBmp.height ? mImageBmp.width:mImageBmp.height;
					newSize = getMinPowerTwo( newSize );
					var newBit:BitmapData = new BitmapData(newSize, newSize, false);
					newBit.draw(mImageBmp);
					mIsTextureReSize = true;
					
					mReSizeTexturePos = new Point(mImageBmp.width/newSize, mImageBmp.height/newSize);
					
					mImageBmp = newBit;// reset reference
					
					// add to cache
					mAssetCacheManager.addBitmapCache(mImagePath, newBit);
				}
			}
			
			//
			// update texture
			//
			_mGeometryModelPointer.uploadTexture();
			if( mIsTextureReSize )
				_mGeometryModelPointer.updateUV(mReSizeTexturePos.x, mReSizeTexturePos.y);
			
			// notify
			if(_completeFun != null)
				_completeFun();
		}
		
		protected var mIsTexturePowerTwo:Boolean = false;
		protected var mIsTextureReSize:Boolean = false;
		protected var mReSizeTexturePos:Point = null;
		protected function isPowerTwo(value:uint):Boolean
		{
			var result:Boolean = false;
			while( value > 1 )
			{
				if( value % 2 == 0 )
					value = value/2;
				else
					break;
			}
			if( value == 1 )
				result = true;
			
			return result;
		}
		
		protected function getMinPowerTwo(value:uint):uint
		{
			var intPowerValue:uint = 0;
			var temp:uint = 2, index:uint=1;
			while(true)
			{
				temp = Math.pow(2, index);
				index++;
				
				if( temp > value)
					break;
			}
			intPowerValue = temp;
			
			return intPowerValue;
		}
		
		/*
		 * 位图材质shader 
		 * 
		 * 
		 */
		override protected function initShaders():void
		{
			mVertexShaderAssembler = new AGALMiniAssembler();
			mVertexShaderAssembler.assemble
				(
					Context3DProgramType.VERTEX,
					"m44 op, va0, vc0\n"+		// vertex * matrix3d
					"mov v0, va1"				// move uv to v0
				);
			
			// textured using UV coordinates
			mFragmentShaderAssembler = new AGALMiniAssembler();
			mFragmentShaderAssembler.assemble
				(
					Context3DProgramType.FRAGMENT,
					"tex ft1, v0, fs0 <2d,repeat,nomip>\n" +
					"mov oc, ft1\n"
				);
			
			mShaderProgram = mContext3DPointer.createProgram();
			mShaderProgram.upload(mVertexShaderAssembler.agalcode,
				mFragmentShaderAssembler.agalcode);
		}
		
		protected var mTexturePositionBufferOffset:uint = 3;
		override public function setVertexAndTextureRegisterLocal():void
		{
			mContext3DPointer.setVertexBufferAt(0, _mGeometryModelPointer.mMeshVertexBuffer, mPositionBufferOffset, 'float3');// va0: x,y,z
			mContext3DPointer.setVertexBufferAt(1, _mGeometryModelPointer.mMeshVertexBuffer, mTexturePositionBufferOffset, 'float2');// va1: u,v
			
			// texture
			mContext3DPointer.setTextureAt(0, _mGeometryModelPointer.mMaterialTexture);
		}
		
		
		override public function resetVertexAndTextureRegisterLocal():void
		{
			// vertex
			mContext3DPointer.setVertexBufferAt(0, null);
			mContext3DPointer.setVertexBufferAt(1, null);
			
			// texture
			mContext3DPointer.setTextureAt(0, null);
		}
		
	}
}