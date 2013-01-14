package yanyan
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	
	import yanyan.render.BaseRender;
	import yanyan.render.IRenderable;

	/**
	 * 基础的3d对象，包括转换、几何体信息 
	 * 
	 * 
	 * @author harry
	 * @date 11.05 2012
	 * 
	 */
	public class YObject3D extends EventDispatcher implements IRenderable
	{
		// transformer
		protected var mLocalTransform:Matrix3D = null;
		protected var mView:Matrix3D = null;
		protected var mWorldTransform:Matrix3D = null;
		protected var _zIndex:Number = .0;
		
		// geometry model
		public var mGeometryData:GeometryModel = null;// 一个网格模型对应自己的material
		
		// 
		protected var _mName:String = '';
		protected var _mNumChildren:uint = 0;
		protected var _mParent:YObject3DContainer = null;
		
		// upload and render context3D
		protected var mRenderEngine:BaseRender = null;
		protected var mContext3DPointer:Context3D = null;
		
		
		public function YObject3D()
		{
			mLocalTransform = new Matrix3D();
			mView = new Matrix3D();
			mWorldTransform = new Matrix3D();
			
			// get context3D
			mContext3DPointer = Yz3D.context3DHolder;
		}
		
		public function copyTransform(m:Matrix3D):void
		{
			this.transform.copyFrom( m );
		}
		
		public function get transform():Matrix3D
		{
			return mLocalTransform;
		}
		
		public function get worldTransform():Matrix3D
		{
			return mWorldTransform;
		}
		
		public function get view():Matrix3D
		{
			return mView;
		}
		
		public function get zIndex():Number
		{
			return _zIndex = this.mWorldTransform.position.z;
		}
		
		public function get name():String
		{
			return _mName;
		}
		
		public function set name(p:String):void
		{
			_mName = p;
		}
		
		public function get parent():YObject3DContainer
		{
			return _mParent;
		}
		
		public function set parent(p:YObject3DContainer):void
		{
			_mParent = p;
		}
		
		public function project(parent:Matrix3D, session:Object):void
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
			
			// add to render list
			if( mGeometryData )
			{
				mRenderEngine = session.render;
				mRenderEngine.addToRenderList( this );
			}
		}
		
		public function get isTransparentMesh():Boolean
		{
			var b:Boolean = false;
			if( mGeometryData && mGeometryData.mMaterialModel &&
				mGeometryData.mMaterialModel.mEffect_Key_transparency)
				b = true;
				
			return b;
		}

		public function get mNumChildren():uint
		{
			return _mNumChildren;
		}

		public function set mNumChildren(value:uint):void
		{
			_mNumChildren = value;
		}
		
		public function renderMesh(session:Object):void
		{
			var count:uint = 0;
			var firstNode:GeometryModel = mGeometryData;
			while(firstNode)
			{
				if( firstNode.mPreLink )
					firstNode = firstNode.mPreLink;
				else
					break;
			}
			
			while( firstNode )
			{
				// vertex and texture setting
				firstNode.mMaterialModel.setVertexAndTextureRegisterLocal();
				
				
				// set other register local and data
				// @add
			
			
			
				// program shaders
				firstNode.mMaterialModel.setProgram3D();
			
			
			
				// set matrix const
				var modelViewProjection:Matrix3D = session.shareProjectMatrix;
				modelViewProjection.identity();
				modelViewProjection.append( worldTransform );// model's
				modelViewProjection.append( session.camera.eye );// camera transform
				modelViewProjection.append( session.camera.projectionMatrix );// projection const
				mContext3DPointer.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewProjection, true );
			
			
				// add other const register
				// @add
				
				
				// draw
				mContext3DPointer.setCulling( firstNode.mMaterialModel.doubleSide ? 'none':'back' );
				mContext3DPointer.drawTriangles( firstNode.mMeshIndexBuffer );
				
				
				// reset
				firstNode.mMaterialModel.resetVertexAndTextureRegisterLocal();
				
				
				
				// loop geometry
				if( firstNode.mNextLink )
				{
					firstNode = firstNode.mNextLink;
					count++;
				}
				else
					break;
			}
			
			firstNode = null;
		}
		
		
		
		
		
		
		
	}
}