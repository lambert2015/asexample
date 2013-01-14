package yanyan.materials
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3DProgramType;
	
	import yanyan.MaterialModel;
	
	/**
	 * 颜色材质
	 *  
	 * @author harry
	 * @date 11.15 2012
	 * 
	 */
	public class ColorMaterial extends MaterialModel
	{
		protected var mColor:uint = 0x00FF00;
		protected var mAlpha:Number = 1.0;
		protected var mColorVector:Vector.<Number> = null;
		
		public function ColorMaterial(color:uint, alpha:Number)
		{
			super();
			
			this.mColor = color;
			this.mAlpha = alpha;
			
			mColorVector = new Vector.<Number>();
			mColorVector.push( (color>>16)/255 );
			mColorVector.push( (color>>8 & 0x0000FF)/255 );
			mColorVector.push( (color&0x0000FF)/255 );
			mColorVector.push( alpha );
			
			/*mColorVector.push( 1.0 );
			mColorVector.push( 0 );
			mColorVector.push( 0 );
			mColorVector.push( alpha );*/
		}
		
		public function get color():uint
		{
			return mColor;
		}
		
		/*
		 * 设置顶点纹理寄存器的位置 
		 * 
		 * 
		 */
		protected var mPositionBufferOffset:uint = 0;
		protected var mColorBufferOffset:uint = 3;
		override public function setVertexAndTextureRegisterLocal():void
		{
			mContext3DPointer.setVertexBufferAt(0, _mGeometryModelPointer.mMeshVertexBuffer, mPositionBufferOffset, 'float3');// va0: x,y,z
			
			/*
			 * set color const 
			 * 
			 */
			mContext3DPointer.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, mColorVector, 1);
		}
		
		
		
		/*
		 * 设计color_material对应的shader 
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
					"mov v0, vc4"				// move uv to v0
				);
			
			// textured using UV coordinates
			mFragmentShaderAssembler = new AGALMiniAssembler();
			mFragmentShaderAssembler.assemble
				(
					Context3DProgramType.FRAGMENT,
					"mov oc, v0\n"
				);
			
			mShaderProgram = mContext3DPointer.createProgram();
			mShaderProgram.upload(mVertexShaderAssembler.agalcode,
									mFragmentShaderAssembler.agalcode);
		}
		
		
		
	}
}