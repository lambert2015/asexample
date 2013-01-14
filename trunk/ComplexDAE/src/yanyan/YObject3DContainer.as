package yanyan
{
	import flash.geom.Matrix3D;

	/**
	 * 3D显示对象容器类 
	 * 
	 * @author harry
	 * @date 11.05 2012
	 * 
	 */
	public class YObject3DContainer extends YObject3D
	{
		protected var _mChildren:Vector.<YObject3D> = null;
		
		public function YObject3DContainer()
		{
			super();
			
			_mChildren = new Vector.<YObject3D>();
		}
		
		public function get child():Vector.<YObject3D>
		{
			return _mChildren;
		}
		
		public function addChild(item:YObject3D):void
		{
			if( _mChildren.indexOf(item) == -1 ) 
			{
				_mChildren.push( item );
				mNumChildren++;
				
				item.parent = this;
			}
		}
		
		public function removeChild(item:YObject3D):void
		{
			var index:int = _mChildren.indexOf(item);
			if( index != -1 )
			{
				_mChildren.splice(index, 1);
				mNumChildren--;
				
				item.parent = null;
			}
		}
		
		override public function project(parent:Matrix3D, session:Object):void
		{
			// project world tranform
			if( parent )
			{
				mWorldTransform.copyFrom( transform );
				mWorldTransform.append( parent );
			}
			else
			{
				mWorldTransform.copyFrom( mLocalTransform );
			}
			
			// loop all children
			for each(var child:YObject3D in _mChildren)
			{
				child.project(this.worldTransform, session);
			}
			
			// add to render list
			if( mGeometryData )
			{
				mRenderEngine = session.render;
				mRenderEngine.addToRenderList( this );
			}
		}

		public function get mParent():YObject3DContainer
		{
			return _mParent;
		}

		public function set mParent(value:YObject3DContainer):void
		{
			_mParent = value;
		}

	}
}