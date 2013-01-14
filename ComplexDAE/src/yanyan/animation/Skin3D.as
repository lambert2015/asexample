package yanyan.animation
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import yanyan.YObject3DContainer;
	import yanyan.math.Quaternion;
	
	/**
	 * 蒙皮网格 
	 * 
	 * @date 11.05 2012
	 * @author harry
	 * 
	 */
	public class Skin3D extends YObject3DContainer
	{
		include "AssembleBonesBlend.as";
		
		public function Skin3D()
		{
			super();
			
			mSkinVertex = new Vector.<PairJointWeight>();
		}
		
		private var mSkinVertex:Vector.<PairJointWeight> = null;
		public function pushVertexWeightPair(pair:PairJointWeight):void
		{
			if( pair )
				mSkinVertex.push( pair );
			else
				throw new Error('error!');
		}
		
		// bind shape matrix
		public var mBindShapeMatrix:Matrix3D = null;
		
		
		/*
		 * 调试配置
		 * 
		 * 
		 */
		protected var mIsRenderMeshOnly:Boolean = false;// 是否只显示网格模型,不播放骨骼动画
		protected var mIsUseSoftwareBlendVertex:Boolean = false;// 软件混合
		
		
		public var intMaxBoneBlend:uint = 0;
		public const INT_SYSTEM_SUPPORT_MAX_BONEBLEND:uint = 4;
		protected var mVertexBlendWeightVector:Vector.<Number> = null;
		protected var mVertexBlendJointsTransform:Vector.<Matrix3D> = null;
		protected var mDebugJointNames:Vector.<String> = null;
		
		protected var mVertexBlendComboneTransform:Vector.<Number> = null;
		protected var mVertexBlendComboneBuffer:VertexBuffer3D = null;
		protected var mVertexBlendComboneWeights:Vector.<Number> = null;
		protected var mVertexBlendComboneWeightsBuffer:VertexBuffer3D = null;
		
		protected static const MATRIX_IDENTITY:Matrix3D = new Matrix3D();
		public var mInflBonesCount:uint = 0;// 骨骼数量
		public var mVectorJointsNames:Vector.<String> = new Vector.<String>();// 所有骨骼名称
		public var mDictJointsMap:Dictionary = null;// key - jointInstance
		
		// 设计无数量限制的骨骼动画
		protected var r$OneBonesUseRegister:uint = 2;// q+translation
		protected var r$MaxUseConstRegister:uint = 59;
		protected var r$ConstRegisterStartIndex:uint = 10;
		protected var r$IsNeedBatchUploadVertex:Boolean = false;
		protected var r$NeedUploadBatchTimes:uint = 0;
		protected var mCurrentRenderCell:StructRenderCell = null;
		
		// 蒙皮材质控制
		protected var mIsHasTexture:Boolean = true;
		protected var PER_VERTEX_OFFSET:uint = 5;
		public function updateVertexSkinnedBuffer():void
		{
			if( intMaxBoneBlend > INT_SYSTEM_SUPPORT_MAX_BONEBLEND )
			{
				trace( "$error: max support bones blend count="+INT_SYSTEM_SUPPORT_MAX_BONEBLEND.toString() );
				mIsUseSoftwareBlendVertex = true;
			}
			
			// check texture
			mIsHasTexture = (mGeometryData.mMaterialTexture != null);
			PER_VERTEX_OFFSET = mIsHasTexture ? 5:3;
			
			// origine vertex buffer like this
			// x,y,z - va0
			// u,v	 - va1
			// 
			// 
			// 
			// boneIds - va5(vc中的位置, vc从10开始)
			// weights - va6
			//		   - va7
			if( mInflBonesCount > r$MaxUseConstRegister )
			{
				r$IsNeedBatchUploadVertex = true;
				r$NeedUploadBatchTimes = Math.floor( mInflBonesCount/r$MaxUseConstRegister );
			}
			
			if( r$IsNeedBatchUploadVertex )
			{
				// todo
			}
			else
			{
				mCurrentRenderCell = new StructRenderCell();
				
				// get index and vertex reference
				mCurrentRenderCell.mCellVertexBuffer = mGeometryData.mMeshVertexBuffer;
				mCurrentRenderCell.mCellIndexBuffer  = mGeometryData.mMeshIndexBuffer;
				
				mCurrentRenderCell.mCellBonesCount   = mVectorJointsNames.length;
				
				//
				// 两个原始的针对每一个顶点的数据：骨骼变换+权重
				//
				//
				mVertexBlendWeightVector = new Vector.<Number>();
				mVertexBlendJointsTransform = new Vector.<Matrix3D>();
				mDebugJointNames = new Vector.<String>();
				
				// set weights and joints transform
				var count:uint = mSkinVertex.length;
				var pair:PairJointWeight = null, intEmptyValue:uint;
				for(var index:uint=0; index < count; index++)
				{
					intEmptyValue = 0;
					pair = mSkinVertex[index];
					if( !pair )
						throw new Error("error: every vertex must be infl at least one bone.");
					
					while(pair)
					{
						mVertexBlendWeightVector.push( pair.numWeight );
						mVertexBlendJointsTransform.push( pair.mJointPointer.mSkinnedLastMatrix );// the last matrix
						mDebugJointNames.push( pair.mJointName );
						
						intEmptyValue++;
						pair = pair.mPreLink;
					}
					
					// 进行位置补齐
					intEmptyValue = intMaxBoneBlend-intEmptyValue;
					while(intEmptyValue)
					{
						mVertexBlendWeightVector.push( 0.0 );
						mVertexBlendJointsTransform.push( MATRIX_IDENTITY );
						mDebugJointNames.push( 'spaceBone!' );
						
						intEmptyValue--;
					}
				}	
				
				// vertex struct - ((x,y,z,w), (), (), (), (), ());
				mVertexBlendComboneTransform = new Vector.<Number>();
				mVertexBlendComboneWeights = new Vector.<Number>();
			}
			
		}
		
		override public function project(parent:Matrix3D, session:Object):void 
		{
			this.transform.copyFrom( parent );
			var b:Boolean = this.transform.invert();
			var raw:Vector.<Number> = Vector.<Number>([1,0,0,0,
														0,0,1,0,
														0,1,0,0,
														0,0,0,1]);
			this.transform.copyFrom( new Matrix3D(raw) );
			
			super.project(parent, session);
		}
		
		protected var mZeroVector:Vector.<Number> = Vector.<Number>([0,0,0,0]);
		protected var mIdentityVector:Vector.<Number> = Vector.<Number>([0,0,0,1]);
		override public function renderMesh(session:Object):void
		{
			//
			// 如果所有的顶点被没有受到任何骨骼的作用，自动转换
			// 为渲染网格模型
			// @UPDATE 11.12 2012
			//
			//
			//
			if(  intMaxBoneBlend == 0 )
				mIsRenderMeshOnly = true;
			
			if( !mIsRenderMeshOnly )
			{
				if( mIsUseSoftwareBlendVertex )
					blendVertexUseSoftware();
				else
					updateVertexBlendDataWhenAnimated();// // when animated, matrix has dirty
			}
			
			// set vertex and texture register local
			//
			//
			setVertexTextureRegisterLocal();
			
			
			if( !mIsRenderMeshOnly && !mIsUseSoftwareBlendVertex )
			{
				//
				// 设置对应的权重
				//
				//
				// weights
				mContext3DPointer.setVertexBufferAt(6, mVertexBlendComboneWeightsBuffer, 0, 'float'+intMaxBoneBlend.toString());
				
				// bone index
				mContext3DPointer.setVertexBufferAt(7, mVertexBlendComboneWeightsBuffer, intMaxBoneBlend, 'float'+intMaxBoneBlend.toString());
				
				// bone translate index
				mContext3DPointer.setVertexBufferAt(5, mVertexBlendComboneWeightsBuffer, intMaxBoneBlend*2, 'float'+intMaxBoneBlend.toString());
				
				// set matrix const - bind shape matrix
				mContext3DPointer.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, mBindShapeMatrix, true);// 4
				mContext3DPointer.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, mZeroVector, 1);
				mContext3DPointer.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, mIdentityVector, 1);
				
				// set bone blend matrix
				//
				// 补齐对于的骨骼旋转转矩阵,和local
				//
				mContext3DPointer.setProgramConstantsFromVector(Context3DProgramType.VERTEX, r$ConstRegisterStartIndex, 
																	mIdentityVector, 1);// q - vc10
				mContext3DPointer.setProgramConstantsFromVector(Context3DProgramType.VERTEX, r$ConstRegisterStartIndex+1, 
																	mZeroVector, 1);// local - vc11
				
				var temp:Vector.<Number> = null;
				for(var boneIndex:uint=0; boneIndex<mCurrentRenderCell.mCellBonesCount; boneIndex++)
				{
					// rotation matrix - 4
					temp = mVertexBlendComboneTransform.splice(0, 4);
					mContext3DPointer.setProgramConstantsFromVector(Context3DProgramType.VERTEX, r$ConstRegisterStartIndex+2+boneIndex*2, 
																		temp, 1);
					
					// translation matrix - 3
					temp = mVertexBlendComboneTransform.splice(0, 3);
					temp.push(0);
					mContext3DPointer.setProgramConstantsFromVector(Context3DProgramType.VERTEX, r$ConstRegisterStartIndex+2+boneIndex*2+1, 
																		temp, 1);
				}
			}
			
			// texture
			if(mGeometryData.mMaterialTexture)
				mContext3DPointer.setTextureAt(0, mGeometryData.mMaterialTexture);
			
			
			// program shaders
			if(!mShaderProgram)
			{
				initShaders3();
			}
			mContext3DPointer.setProgram( mShaderProgram );
			
			// set matrix const
			var modelViewProjection:Matrix3D = session.shareProjectMatrix;
			modelViewProjection.identity();
			modelViewProjection.append( worldTransform );// model's
			modelViewProjection.append( session.camera.eye );// camera transform
			modelViewProjection.append( session.camera.projectionMatrix );// projection const
			mContext3DPointer.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, modelViewProjection, true );
			
			// draw
			mContext3DPointer.setCulling('none');
			mContext3DPointer.drawTriangles( mGeometryData.mMeshIndexBuffer );
			
			// clear
			recoverRegister();
		}
		
		protected var mArrayMeskSkinColor:Vector.<Number> = Vector.<Number>([1.0,0.0, 0.0, 1.0]);
		protected function setVertexTextureRegisterLocal():void
		{
			// vertex
			mContext3DPointer.setVertexBufferAt(0, mGeometryData.mMeshVertexBuffer, 0, 'float3');// va0: x,y,z
			if( mIsHasTexture )
			{
				mContext3DPointer.setVertexBufferAt(1, mGeometryData.mMeshVertexBuffer, 3, 'float2');// va1: u,v
			}
			else
			{
				mContext3DPointer.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 10, mArrayMeskSkinColor, 1);
				r$ConstRegisterStartIndex = 10+1;
			}
		}
		
		protected function recoverRegister():void
		{
			if( mGeometryData.mMaterialTexture )
				mContext3DPointer.setTextureAt(0, null);
			
			mContext3DPointer.setVertexBufferAt(0, null);// va0: x,y,z
			if( mIsHasTexture )
				mContext3DPointer.setVertexBufferAt(1, null);// va1: u,v
			
			if( !mIsRenderMeshOnly && !mIsUseSoftwareBlendVertex )
			{
				// weigths
				mContext3DPointer.setVertexBufferAt(6, null);
				
				// bone index
				mContext3DPointer.setVertexBufferAt(7, null);
				
				// bone translate index
				mContext3DPointer.setVertexBufferAt(5, null);
			}
		}
		
		/*
		 * 当骨骼动作更新时，重新计算骨骼的新变化矩阵，同时
		 * 需要更新顶点混合缓冲
		 * 
		 * 
		 */
		protected function updateVertexBlendDataWhenAnimated():void
		{
			//mVertexBlendComboneWeights.splice(0, mVertexBlendComboneWeights.length);
			
			var count:uint = mSkinVertex.length;
			var intLocalIndex:uint = 0;
			var weight:Number, matrix:Matrix3D, debugJointName:String;
			var q:Quaternion = null;
			var arrayBonesIndex:Array = [];
			var arrayBonesTranslateIndex:Array = null;
			
			if( !mVertexBlendComboneWeights.length )
			{
				for(var index:uint=0; index < count; index++)
				{
					// loop所有的顶点
					//
					//
					intLocalIndex = intMaxBoneBlend*index;
					
					for(var kk:uint=intLocalIndex; kk < intLocalIndex+intMaxBoneBlend; kk++)
					{
						weight = mVertexBlendWeightVector[kk];
						debugJointName = mDebugJointNames[kk];
						
						mVertexBlendComboneWeights.push( weight );
						if( debugJointName == 'spaceBone!' )
							arrayBonesIndex.push( r$ConstRegisterStartIndex );// space matrix
						else
							arrayBonesIndex.push( mVectorJointsNames.indexOf(debugJointName)*2+r$ConstRegisterStartIndex+2 );
					}
					
					// append it
					arrayBonesTranslateIndex = arrayBonesIndex.concat();
					while( arrayBonesIndex.length )
						mVertexBlendComboneWeights.push( arrayBonesIndex.shift() );// [x,y,z,w], bones Quaternion Index
					
					while(arrayBonesTranslateIndex.length)
						mVertexBlendComboneWeights.push( arrayBonesTranslateIndex.shift()+1 );// [x,y,z,w] bones translate Index
				}
				
				// 上传权重和boneIndex数据
				var numPerVertexComboneValues:uint = 0;
				numPerVertexComboneValues = intMaxBoneBlend*3;// 3个3个
				mVertexBlendComboneWeightsBuffer = mContext3DPointer.createVertexBuffer(mVertexBlendComboneWeights.length/numPerVertexComboneValues, numPerVertexComboneValues);
				mVertexBlendComboneWeightsBuffer.uploadFromVector(mVertexBlendComboneWeights, 0, mVertexBlendComboneWeights.length/numPerVertexComboneValues);
			}
			
			// clear old data
			mVertexBlendComboneTransform.splice(0, mVertexBlendComboneTransform.length);
			
			// 重新收集骨骼转换数据
			count = mVectorJointsNames.length;
			var itemJoint:Joint3D = null;
			for(var tt:uint=0; tt < count; tt++)
			{
				itemJoint = mDictJointsMap[ mVectorJointsNames[tt] ];
				matrix = itemJoint.mSkinnedLastMatrix;
				q = new Quaternion();
				q.fromMatrix( matrix );
				//q.normalize();// 无须normalize
				
				// 收集每块骨骼对应的混合矩阵
				//
				//
				mVertexBlendComboneTransform.push( q.x, q.y, q.z, q.w, matrix.rawData[12], matrix.rawData[13], matrix.rawData[14]);
			}
			
		}
		
		/*
		 * 进行软件混合顶点 
		 * 
		 * 
		 */
		private var mCacheOriginVertexts:Vector.<Number> = null;
		protected function blendVertexUseSoftware():void
		{
			var intCountVertexs:uint = 0;
			if( !mCacheOriginVertexts )
			{
				//
				// copy all origin vertexs
				//
				mCacheOriginVertexts = mGeometryData.mMeshVertexData.concat();
				
				var len:uint = mCacheOriginVertexts.length/PER_VERTEX_OFFSET;
				var tempVertex:Vector3D = null, tempNewVertex:Vector3D = null;
				intCountVertexs = mCacheOriginVertexts.length;
				for(var v:uint=0; v < intCountVertexs; v += PER_VERTEX_OFFSET)
				{
					tempVertex = new Vector3D(mCacheOriginVertexts[v], mCacheOriginVertexts[v+1], mCacheOriginVertexts[v+2]);
					tempNewVertex = mBindShapeMatrix.transformVector(tempVertex);
					
					// cache it
					mCacheOriginVertexts[v]   = tempNewVertex.x;
					mCacheOriginVertexts[v+1] = tempNewVertex.y;
					mCacheOriginVertexts[v+2] = tempNewVertex.z;
				}
			}
			
			if( false )
			{
				mGeometryData.mMeshVertexData = mCacheOriginVertexts.concat();
			}
			else
			{
				// clear origine values
				intCountVertexs = mCacheOriginVertexts.length;
				for(v=0; v < intCountVertexs; v += PER_VERTEX_OFFSET)
				{
					mGeometryData.mMeshVertexData[ v ] = .0;
					mGeometryData.mMeshVertexData[v+1] = .0;
					mGeometryData.mMeshVertexData[v+2] = .0;
				}
				
				// start blend vertexs
				var count:uint = mSkinVertex.length;
				var intLocalIndex:uint = 0;
				var weight:Number, matrix:Matrix3D, debugJointName:String;
				var q:Quaternion = null;
				var vertexOrigin:Vector3D = null, vertexChanged:Vector3D = null;
				for(var index:uint=0; index < count; index++)
				{
					intLocalIndex = intMaxBoneBlend*index;
					vertexOrigin = new Vector3D(mCacheOriginVertexts[index*PER_VERTEX_OFFSET], mCacheOriginVertexts[index*PER_VERTEX_OFFSET+1], 
													mCacheOriginVertexts[index*PER_VERTEX_OFFSET+2]); 
					
					for(var kk:uint=intLocalIndex; kk < intLocalIndex+intMaxBoneBlend; kk++)
					{
						weight = mVertexBlendWeightVector[kk];
						matrix = mVertexBlendJointsTransform[kk];// itemJoint3D.mSkinnedLastMatrix
						debugJointName = mDebugJointNames[kk];
						
						//if( debugJointName == 'Bone37' )
							//trace('pause!');
						
						if( weight > 0.0 )
						{
							q = new Quaternion();
							q.fromMatrix( matrix );
							var tt:Vector3D = q.rotatePoint(vertexOrigin);
							tt.x += matrix.rawData[12];
							tt.y += matrix.rawData[13];
							tt.z += matrix.rawData[14];
							
							vertexChanged = tt.clone();
							
							
							//vertexChanged = matrix.transformVector( vertexOrigin );
							
							vertexChanged.x *= weight;
							vertexChanged.y *= weight;
							vertexChanged.z *= weight;
							
							mGeometryData.mMeshVertexData[ index*PER_VERTEX_OFFSET   ] += vertexChanged.x;
							mGeometryData.mMeshVertexData[ index*PER_VERTEX_OFFSET+1 ] += vertexChanged.y;
							mGeometryData.mMeshVertexData[ index*PER_VERTEX_OFFSET+2 ] += vertexChanged.z;
							
							if( matrix.rawData[0] == 1 && matrix.rawData[1] == 0 && matrix.rawData[2] == 0 &&
								matrix.rawData[4] == 0 && matrix.rawData[5] == 1 && matrix.rawData[6] == 0 &&
								matrix.rawData[8] == 0 && matrix.rawData[9] == 0 && matrix.rawData[10] == 1 )
							{
								//trace("blend vertex index=", index, ' weight: ',weight, ' name: ', debugJointName, ' matrix:', matrix.rawData);
							}
							else
							{
								//trace("			##blend vertex index=", index, ' weight: ',weight, ' name: ', debugJointName, ' matrix:', matrix.rawData);
							}
						}
					}
				}
			}
			
			// upload to gpu agian
			if( mGeometryData.mMeshVertexBuffer )
				mGeometryData.mMeshVertexBuffer.dispose();
			
			mGeometryData.mMeshVertexBuffer = mContext3DPointer.createVertexBuffer(mGeometryData.mMeshVertexData.length/PER_VERTEX_OFFSET, PER_VERTEX_OFFSET);
			mGeometryData.mMeshVertexBuffer.uploadFromVector(mGeometryData.mMeshVertexData, 0, 
																mGeometryData.mMeshVertexData.length/PER_VERTEX_OFFSET);
		}
		
		private var mVertexShaderAssembler:AGALMiniAssembler = null;
		private var mFragmentShaderAssembler:AGALMiniAssembler = null;
		private var mShaderProgram:Program3D = null;
		
	}
}
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;

class StructRenderCell
{
	// index
	public var mCellIndexVector:Vector.<Number> = null;
	public var mCellIndexBuffer:IndexBuffer3D = null;
	
	// vertex
	// x,y,z,u,v
	public var mCellVertexVector:Vector.<Number> = null;
	public var mCellVertexBuffer:VertexBuffer3D = null;
	
	// weights[x,y,z,w] bonesIndex[x,y,z,w]
	public var mCellBonesWeightsBonesIndex:Vector.<Number> = null;
	public var mCellBonesWeightsBonesIndexBuffer:VertexBuffer3D = null;
	
	// for vc
	// cell bones matrix [x,y,z,w]+[x,y,z]
	public var mCellBonesQuaternionMatrix:Vector.<Number> = null;
	public var mCellBonesQuaternionMatrixBuffer:VertexBuffer3D = null;
	public var mCellBonesCount:uint = 0;
	
}










