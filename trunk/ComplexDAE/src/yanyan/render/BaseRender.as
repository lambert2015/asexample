package yanyan.render
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;

	/**
	 * 基础的渲染器 
	 * 
	 * @author harry
	 * @date 11.07 2012
	 * 
	 */
	public class BaseRender
	{
		protected var mOpaqueRenderables:Vector.<IRenderable> = null;
		protected var mBlendedRenderables:Vector.<IRenderable> = null;
		
		protected var mContext3D:Context3D = null;
		
		public function BaseRender()
		{
			mOpaqueRenderables = new Vector.<IRenderable>();
			mBlendedRenderables = new Vector.<IRenderable>();
		}
		
		public function setContext3D(c:Context3D):void
		{
			mContext3D = c;
		}
		
		public function addToRenderList(item:IRenderable):void
		{
			if( item.isTransparentMesh )
				mBlendedRenderables.push( item );
			else
				mOpaqueRenderables.push( item );
		}
		
		public function clearAllRenderList():void
		{
			mBlendedRenderables.splice(0, mBlendedRenderables.length);
			mOpaqueRenderables.splice(0,  mOpaqueRenderables.length);
		}
		
		public function render(session:Object):void
		{
			/*
			 * 渲染非透明的贴图的模型
			 *
			 *
			 */
			if( mOpaqueRenderables.length )
			{
				mContext3D.setDepthTest(true, Context3DCompareMode.LESS);
				mContext3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				
				var item:IRenderable = null;
				for each(item in mOpaqueRenderables)
					item.renderMesh(session);
			}
			
			
			
			/*
			 * 渲染透明贴图的模型
			 *
			 *
			 */
			if( mBlendedRenderables.length )
			{
				// todo
				mBlendedRenderables.sort( funZIndexCompare );
				
				//trace(' zIndex:: ', mBlendedRenderables);
				mContext3D.setDepthTest(false, Context3DCompareMode.LESS);
				mContext3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				for each(item in mBlendedRenderables)
				{
					item.renderMesh(session);
				}
			}
		}
		
		private function funZIndexCompare(a:IRenderable, b:IRenderable):int
		{
			if( a.zIndex > b.zIndex )
				return 1;
			else if( a.zIndex > b.zIndex ) 
				return -1;
			
			return 0;
		}
		
	}
}