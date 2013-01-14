package yanyan.scene
{
	import flash.geom.Matrix3D;
	
	import yanyan.YObject3D;

	/**
	 * 场景容器 
	 * 
	 * @author harry
	 * @date 11.07 2012
	 * 
	 */
	public class Scene3D
	{
		public function Scene3D()
		{
			mChildList = new Vector.<YObject3D>();
		}
		
		/*
		 * 场景容器的树形结构管理 
		 * 
		 * 
		 */
		protected var mChildList:Vector.<YObject3D> = null;
		public function addChild(child:YObject3D):void
		{
			mChildList.push( child );
		}
		
		public function removeChild(child:YObject3D):void
		{
			var localIndex:int = mChildList.indexOf(child);
			if( localIndex != -1 )
				mChildList.splice(localIndex, 1);
		}
		
		
		/*
		 * 进行世界坐标变换,相机变换,透视变换
		 *  
		 * 
		 */
		public function project(parentMatrix:Matrix3D, session:Object):void
		{
			for each(var child:YObject3D in mChildList)
			{
				//
				// 深度遍历，进行世界变换
				//
				//
				child.project(null, session);
			}
		}
		
	}
}