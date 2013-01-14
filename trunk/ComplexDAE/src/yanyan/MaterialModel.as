package yanyan
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	
	/**
	 * 贴图材质信息 
	 * 
	 * @date 11.1 2012
	 * 
	 */
	public class MaterialModel
	{
		public function MaterialModel():void
		{
			mContext3DPointer = Yz3D.context3DHolder;
		}
		
		
		// dae data property
		// libray_images
		public var mImageSID:String='';
		public var mImageName:String='';
		public var mImagePath:String = '';
		public var mImageBmp:BitmapData = null;
		
		// libray_materials
		public var mMaterialSID:String = '';
		public var mMaterialName:String = '';
		public var mMaterial_InstanceEffectURL:String = '';
		
		// library_effects
		public var mEffectSID:String = '';
		public var mEffect_Key_ambient:uint = 0;
		public var mEffect_Key_diffuse:Object = null;
		public var mEffect_Key_transparency:Boolean = false;// default false
		// ...
		
		
		
		// bind GeometryModel
		protected var _mGeometryModelPointer:GeometryModel = null;
		public function registGeometryOwner(p:GeometryModel):void
		{
			this._mGeometryModelPointer = p;
		}
		
		
		
		
		// basic property for material
		protected var mDoubleSide:Boolean = true;
		public function get doubleSide():Boolean
		{
			return mDoubleSide;	
		}
		
		public function set doubleSide(b:Boolean):void
		{
			mDoubleSide = b;
		}
		
		protected var mTransparency:Boolean = false;
		public function get transparency():Boolean
		{
			return mTransparency;	
		}
		
		public function set transparency(b:Boolean):void
		{
			mTransparency = b;
		}
		
		/**
		 * 添加shader, 不同的材质设计不同的shader 
		 * 
		 * 
		 */
		protected var mVertexShaderAssembler:AGALMiniAssembler = null;
		protected var mFragmentShaderAssembler:AGALMiniAssembler = null;
		protected var mContext3DPointer:Context3D = null;
		protected var mShaderProgram:Program3D = null;
		protected function initShaders():void
		{
			throw new Error('error: override this function for material.');
		}
		
		public function setVertexAndTextureRegisterLocal():void
		{
			throw new Error('error: override this function for material.');
		}
		
		/**
		 * 上传并设置对应的program: vertex and pixel shader 
		 * 
		 * 
		 */
		public function setProgram3D():void
		{
			if(!mShaderProgram)
				initShaders();
			
			mContext3DPointer.setProgram( mShaderProgram );
		}
		
		public function resetVertexAndTextureRegisterLocal():void
		{
			// override it
		}
		
		
		
		
	}
}