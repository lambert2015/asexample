package yanyan
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	
	import yanyan.resources.AssetCacheManager;

	/**
	 * 模型几何结构
	 * 
	 * @date 11.1 2012
	 * 
	 */
	public class GeometryModel
	{
		// 顶点信息
		public var mMeshVertexBuffer:VertexBuffer3D = null;
		public var mMeshVertexData:Vector.<Number> = null;
		
		// 索引信息
		public var mMeshIndexBuffer:IndexBuffer3D = null;
		public var mMeshIndexData:Vector.<uint> = null;
		
		// 材质
		public var mBindMaterialSID:String = '';
		public var mMaterialModel:MaterialModel = null;
		public var mMaterialTexture:Texture = null;
		
		// 标示信息
		public var mSID:String = '';
		public var mName:String = '';
		
		// 更新材质信息
		private var _context3dPointer:Context3D = null;
		
		// asset cache manager
		protected var mAssetCacheManager:AssetCacheManager = null;
		
		public function setContext3DHolder(p:Context3D):void
		{
			this._context3dPointer = p;
		}
		
		public function uploadTexture():void
		{
			mAssetCacheManager = AssetCacheManager.instance;
			
			if( mAssetCacheManager.hasTextureCache(mMaterialModel.mImagePath) )
			{
				mMaterialTexture = mAssetCacheManager.getTextureCache( mMaterialModel.mImagePath );
			}
			else
			{
				var bit:BitmapData = mMaterialModel.mImageBmp;
				mMaterialTexture = _context3dPointer.createTexture(bit.width, bit.height, Context3DTextureFormat.BGRA, false);
				mMaterialTexture.uploadFromBitmapData(bit);
				
				mAssetCacheManager.addTextureCache(mMaterialModel.mImagePath, mMaterialTexture);
			}
		}
		
		protected var mBufferUVOffset:uint = 3;
		protected var mBufferVertexSize:uint = 5;
		public function updateUV(us:Number, vs:Number):void
		{
			var count:uint = mMeshVertexData.length;
			var u:Number, v:Number;
			for(var i:uint=0; i<count; i += mBufferVertexSize)
			{
				u = mMeshVertexData[i+3];
				v = mMeshVertexData[i+4];
				
				mMeshVertexData[i+3] = u*us;
				mMeshVertexData[i+4] = v*vs;
			}
			
			// reupload
			if( !mMeshVertexBuffer )
				mMeshVertexBuffer.dispose();
			
			mMeshVertexBuffer = _context3dPointer.createVertexBuffer(mMeshVertexData.length/mBufferVertexSize, 
																		mBufferVertexSize);
			mMeshVertexBuffer.uploadFromVector(mMeshVertexData, 0, 
												mMeshVertexData.length/mBufferVertexSize);
		}
		
		
		/*
		 * 添加几何体模型的迭代 访问，当然可以建立children方式
		 * 进行迭代, 这种关系不存在子父关系
		 * 
		 */
		public var mPreLink:GeometryModel = null;
		public var mNextLink:GeometryModel = null;
		
		
		
		
		
		
		
		
		
	}
}