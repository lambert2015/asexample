package yanyan.parse.dcollada
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Shape;
	import flash.display3D.Context3DProgramType;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import yanyan.GeometryModel;
	import yanyan.MaterialModel;
	import yanyan.YObject3DContainer;
	import yanyan.materials.BitmapMaterial;
	import yanyan.materials.ColorMaterial;
	
	/**
	 * collada 1.4模型，骨骼动画解析器、渲染器 
	 * 
	 * 
	 * @author harry
	 * @date 11.07 2012
	 * 
	 */
	public class DAE extends YObject3DContainer
	{
		include "ParseAnimation.as";
		
		// root
		private var mRootDae:YObject3DContainer = null;
		
		
		public function DAE()
		{
			super();
			
			mRootDae = new YObject3DContainer();
			addChild( mRootDae );
		}
		
		// load model
		private var loader:URLLoader = null;
		private var filePath:String = null;
		private var mDaeModelData:XML = null;
		public function load(url:String):void
		{
			filePath = url;
			
			loader = new URLLoader();
			loader.load( new URLRequest(filePath) );
			loader.addEventListener('complete', onLoadCompleteHandler);
		}
		
		private function onLoadCompleteHandler(evt:Event):void
		{
			mDaeModelData = new XML( loader.data );
			//trace( mDaeModelData );
			
			trace('$info: ', 'Load complete, start parse dae file!');
			parseDAE();
		}
		
		/*
		 * 读取xml格式完毕，开始解析dae 
		 * 
		 * 
		 */
		private var mIsHasBonesAnimation:Boolean = false;
		private var mIsComplexMesh:Boolean = false;
		public var mIsAxisZUP:Boolean = false;
		private function parseDAE():void
		{
			mIsHasBonesAnimation = mDaeModelData.collada::library_animations.length() > 0;
			mIsComplexMesh = mDaeModelData.collada::library_nodes.length() > 0;
			trace('$info: has bone animation=',mIsHasBonesAnimation, ' is complex mesh: ',mIsComplexMesh);
			
			parseBaseInfo();
			
			mWorkCompleteFun = parseScene;
			parseGeometrys();
			//parseScene();
		}
		
		private function parseBaseInfo():void
		{
			var itemAsset:XML = mDaeModelData.collada::asset[0];
			if( !itemAsset )
			{
				trace('$info: there isnot any mesh basic info.');	
			}
			
			var author_tool:String = '';
			var createTimes:String, modifiedTime:String, unitName:String, meterName:String;
			var upAxis:String = '';
			
			if( itemAsset.collada::contributor && itemAsset.collada::contributor.collada::authoring_tool )
			{
				author_tool = itemAsset.collada::contributor.collada::authoring_tool.toString();
			}
			
			if( itemAsset.collada::created )
			{
				createTimes = itemAsset.collada::created.toString();
			}
			if( itemAsset.collada::modified )
			{
				modifiedTime = itemAsset.collada::modified.toString();
			}
			
			if( itemAsset.collada::unit )
			{
				unitName  = itemAsset.collada::unit.@name;
				meterName = itemAsset.collada::unit.@meter;
			}
			if( itemAsset.collada::up_axis )
			{
				upAxis = itemAsset.collada::up_axis.toString();
				
				if( upAxis == 'Z_UP' )
					mIsAxisZUP = true;
			}
			
			trace('$info: basic model info,	[author_tool]=',author_tool,
					'[createTimes]=',createTimes,
					'[modifiedTime]=',modifiedTime,
					'[unitName]=',unitName,
					'[upAxis]=',upAxis
				);
		}
		
		/*
		 * 解析模型结构 
		 * 
		 */
		private function parseGeometrys():void
		{
			//trace( this.mDaeModelData.collada::library_geometries[0] );
			var nodesGeometry:XMLList = this.mDaeModelData.collada::library_geometries.collada::geometry;
			
			// loop for parse every geometry
			var preGeometryLink:GeometryModel;
			for each(var itemNodeGeometry:XML in nodesGeometry)
			{
				var nodeGeometry:XML = itemNodeGeometry;
				var idGeometry:String = nodeGeometry.@id;
				var nodeMesh:XML = nodeGeometry.collada::mesh[0];
				var xmlList:XMLList = nodeMesh..collada::source;
				
				
				// fetch all geometry source node
				var dictSource:Dictionary = new Dictionary();
				for each(var item:XML in xmlList)
				{
					dictSource[item.@id.toString()] = new DAESource().parse(item);
				}
				
				// NOTICE: many triangles may share some vertex position
				//
				// reset vertices pointer(顶点位置信息)
				var texcoordSource:DAESource = null;
				var verticesSource:DAESource = dictSource[ String(nodeMesh.collada::vertices.collada::input.@source.toString()).substr(1) ];
				
				// parse triangles or lines
				if( nodeMesh.collada::lines && nodeMesh.collada::lines.length() )
				{
					trace('$error: sorry cannot load line-struct geometry.');
					continue;
				}
				
				// parse polygons
				if( nodeMesh.collada::polygons && nodeMesh.collada::polygons.length() )
				{
					trace('$error: sorry cannot load polygons-struct geometry.');
					continue;
				}
				
				if( idGeometry == 'mesh76-geometry' )
					trace('pause!');
				
				var listTriangles:XMLList = nodeMesh.collada::triangles;
				preGeometryLink = null;// reset it
				for each(var itemTriangle:XML in listTriangles)
				{
					// fetch triangles
					var values_p:Vector.<uint> = new Vector.<uint>();
					var strPValues:String = trimArrayElements(itemTriangle.collada::p.toString(), " ");
					var values:Array = strPValues.split(/\s+/);
					
					// parse material
					var instanceGeometry:GeometryModel = new GeometryModel();
					dictGeometryReference[idGeometry] = instanceGeometry;// 保存模型引用
				
				
					// parse this geometry material
					parseMaterial( itemTriangle.@material, instanceGeometry );
				
				
					// original link
					if( preGeometryLink )
					{
						preGeometryLink.mNextLink = instanceGeometry;
						instanceGeometry.mPreLink = preGeometryLink;
					}
				
				
				
					// parse one triangle by one, one vertice has 3 point index, that is 
					// vertexIndex, normalIndex, textcoordIndex.
					var PER_VERTEX_SIZE:uint = 3;// x,y,z,u,v
					var xmlInputList:XMLList = itemTriangle.collada::input;
					var intOffset:uint = 0;
					var arrayTypes:Array = new Array();
					for each(item in xmlInputList)
					{
						intOffset = Math.max( intOffset, int(item.@offset.toString())+1 );// 总偏差
						arrayTypes.push( {'s':item.@semantic.toString(),'offset': int( item.@offset.toString()) } );
						
						if( item.@semantic == 'TEXCOORD' )
						{
							texcoordSource = dictSource[ item.@source.toString().substr(1) ];
							
							// if has texture info, reset per_vertex_size
							//
							//
							PER_VERTEX_SIZE = 5;
						}
					}
				
					// set data to GeometryModel
					instanceGeometry.setContext3DHolder( mContext3DPointer );
					instanceGeometry.mMeshIndexData = new Vector.<uint>();
					instanceGeometry.mMeshVertexData = new Vector.<Number>();
					
					instanceGeometry.mMeshVertexData.fixed = false;
					instanceGeometry.mMeshVertexData.length = verticesSource.values.length*PER_VERTEX_SIZE;
				
					// loop all indexs
					var intIndexValue:uint = 0;
					var intVertexLocalIndex:uint = 0;
					for(var index:uint=0; index<values.length; index += intOffset)
					{
						var obj:Object = null;
						for(var p:uint=0; p<arrayTypes.length; p++)
						{
							obj = arrayTypes[p];
							switch(obj.s)
							{
								case 'VERTEX':
									intIndexValue = values[ index+obj.offset ];// index pointer
									instanceGeometry.mMeshIndexData.push( intIndexValue );
									
									instanceGeometry.mMeshVertexData[intIndexValue*PER_VERTEX_SIZE] = verticesSource.values[intIndexValue].x;
									instanceGeometry.mMeshVertexData[intIndexValue*PER_VERTEX_SIZE+1] = verticesSource.values[intIndexValue].y;
									instanceGeometry.mMeshVertexData[intIndexValue*PER_VERTEX_SIZE+2] = verticesSource.values[intIndexValue].z;
									
									intVertexLocalIndex = intIndexValue*PER_VERTEX_SIZE;
									break;
								case 'TEXCOORD':
									intIndexValue = values[ index+obj.offset ];// index pointer
									
									instanceGeometry.mMeshVertexData[intVertexLocalIndex+3] = texcoordSource.values[intIndexValue].x;
									instanceGeometry.mMeshVertexData[intVertexLocalIndex+4] = 1-texcoordSource.values[intIndexValue].y;
									break;
								case 'NORMAL':
									
									continue;
									break;
								default:
									
									continue;
									break;
							}
						}
					}
					instanceGeometry.mMeshIndexData.fixed = true;
					instanceGeometry.mMeshVertexData.fixed = true;
					
					// create buffer
					instanceGeometry.mMeshIndexBuffer  = mContext3DPointer.createIndexBuffer(instanceGeometry.mMeshIndexData.length);
					instanceGeometry.mMeshIndexBuffer.uploadFromVector( instanceGeometry.mMeshIndexData, 0, 
																		instanceGeometry.mMeshIndexData.length );
					
					instanceGeometry.mMeshVertexBuffer = mContext3DPointer.createVertexBuffer(instanceGeometry.mMeshVertexData.length/PER_VERTEX_SIZE, 
																								PER_VERTEX_SIZE);
					instanceGeometry.mMeshVertexBuffer.uploadFromVector(instanceGeometry.mMeshVertexData, 0, 
																			instanceGeometry.mMeshVertexData.length/PER_VERTEX_SIZE);
					
					trace('$info: ','parse geometry complete, vertex count=', instanceGeometry.mMeshVertexData.length/PER_VERTEX_SIZE);
					
					mDebug_VertexCount += instanceGeometry.mMeshVertexData.length/PER_VERTEX_SIZE;
					
					// save link pointer
					preGeometryLink = instanceGeometry;
					
				}// end loop parse triangles or lines
				
			}// end geometry loop
			
			// check thread pause
			if( !mIsHasWorkWait )
				parseScene();
		}
		
		/*
		 * 解析材质信息 
		 * 
		 * 
		 */
		private function parseMaterial(sid:String, instanceGeometryModel:GeometryModel):void
		{
			// get effect id from library_materials
			var listMaterials:XMLList = this.mDaeModelData.collada::library_materials.collada::material;
			var itemMaterial:XML = listMaterials.(@name == sid)[0];
			if( !itemMaterial )
			{
				trace('$error: cannot find geometry triangles bind materil info, sid=',sid);
				
				var colorCommonMaterial:ColorMaterial = new ColorMaterial(0xFFFFFF, 1.0);
				
				instanceGeometryModel.mMaterialModel = colorCommonMaterial;
				instanceGeometryModel.mMaterialModel.registGeometryOwner( instanceGeometryModel );
				
				return;
			}
			
			var effectId:String = itemMaterial.collada::instance_effect.@url.toString().substr(1);
			var effectList:XMLList = this.mDaeModelData.collada::library_effects.collada::effect;
			var xmlEffectItem:XML = effectList.(@id == effectId)[0];
			
			// parse colorMaterial or bitmap texture
			var itemProfile:XML = xmlEffectItem.collada::profile_COMMON[0];
			var newparamList:XMLList = itemProfile.collada::newparam;
			var itemTechnique:XML = itemProfile.collada::technique.collada::phong[0];
			
			// parse color material
			if( !newparamList || !newparamList.length() )
			{
				var arrayDiffuse:Array = itemTechnique.collada::diffuse.collada::color.toString().split(' ');
				var color:uint = getColorFromCollada(arrayDiffuse);
				var alpha:Number = arrayDiffuse[3];
				var colorMaterial:ColorMaterial = new ColorMaterial(color, alpha);
				
				instanceGeometryModel.mMaterialModel = colorMaterial;
				instanceGeometryModel.mMaterialModel.registGeometryOwner( instanceGeometryModel );
				
				return;
			}
			
			// parse bitmap material
			var imageSid:String = '';
			for each(var item:XML in newparamList)
			{
				if( item.@sid.toString().lastIndexOf( 'surface' ) != -1 )
				{
					imageSid = item.collada::surface.collada::init_from.toString();
				}
			}
			
			var imagesList:XMLList = this.mDaeModelData.collada::library_images.collada::image;
			var xmlImageItem:XML = imagesList.(@id == imageSid)[0];
			var path:String = xmlImageItem.collada::init_from.toString();
			
			// start load material
			var model:BitmapMaterial = new BitmapMaterial();
			model.mImagePath = path;
			
			// add a work item, so main thread will wait this work complete
			addWorkItem();
			
			// load texture
			instanceGeometryModel.mMaterialModel = model;
			instanceGeometryModel.mMaterialModel.registGeometryOwner( instanceGeometryModel );
			BitmapMaterial(instanceGeometryModel.mMaterialModel).loadAsset( onLoadMaterialHandler );
		}
		
		private function getColorFromCollada(d:Array):uint
		{
			var color:uint = 0;
			var r:uint = d[0]*255;
			var b:uint = d[1]*255;
			var g:uint = d[2]*255;
			color = r<<16 | b<<8 | g;
			
			return color;
		}
		
		private function onLoadMaterialHandler():void
		{
			//parseScene();
			
			removeWorkItem();
		}
		
		/*
		 * 协调等待操作 
		 * 
		 * 
		 */
		private var mIsHasWorkWait:Boolean = false;
		private var mMaxWorkItem:int = 0;
		private var mWorker:Shape = null;
		private var mWorkCompleteFun:Function = null;
		private function addWorkItem():void
		{
			mMaxWorkItem++;
			mIsHasWorkWait = true;
			trace('$info: add a waitting item.');
			
			if( !mWorker )
				startWorkCheck();
		}
		
		private function removeWorkItem():void
		{
			mMaxWorkItem--;
			mIsHasWorkWait = (mMaxWorkItem != 0);
			trace('$info: remove a waitting item.');
		}
		
		private function startWorkCheck():void
		{
			mWorker = new Shape();
			mWorker.addEventListener(Event.ENTER_FRAME, onCheckWorkHandler);
			trace('$info: start work items checking.');
		}
		
		private function stopWorkCheck():void
		{
			if( mWorker )
			{
				mWorker.removeEventListener(Event.ENTER_FRAME, onCheckWorkHandler);
				mWorker = null;
			}
		}
		
		private function onCheckWorkHandler(evt:Event):void
		{
			if(	!mIsHasWorkWait )
			{
				trace('$info: waitting work item complete! resume thread!!');
				stopWorkCheck();
				mWorkCompleteFun.apply();
			}
		}
		
		
		override public function project(parent:Matrix3D, session:Object):void
		{
			// first update animation controller
			// 计算骨骼节点们在动画中相对的转换矩阵
			//
			// @UPDATE 11.08 2012
			//
			// 
			if( mAnimation3DController )
				mAnimation3DController.update();
			
			// update all bone pose
			updateSkeletonPose();
			
			super.project(parent, session);
		}
		
		/*
		 * 更新骨骼pose,以便于蒙皮控制 
		 * 
		 * 
		 */
		protected function updateSkeletonPose():void
		{
			if( !mJointsStageContainer )
				return;
			
			updateAllBonesPoseWithAnimation( mJointsStageContainer );
		}
		
		protected function updateAllBonesPoseWithAnimation( parent:Joint3D ):void
		{
			var itemJoint3D:Joint3D = null;
			for each(itemJoint3D in parent.child)
			{
				// get animated matrix
				var animationedMatrix:Matrix3D = itemJoint3D.transform;
				
				//if( itemJoint3D.name == "Bone37" )
					//trace('pause!');
				
				// combine parent matrix
				itemJoint3D.mCombineWorldTransform.copyFrom( animationedMatrix );
				if( itemJoint3D.hasParent() )
					itemJoint3D.mCombineWorldTransform.append( Joint3D(itemJoint3D.mParent).mCombineWorldTransform );// paramM * this( world*local )
				
				// combine pose
				itemJoint3D.mSkinnedLastMatrix.copyFrom( itemJoint3D.mCombineWorldTransform );// get the absolute transform( world )
				itemJoint3D.mSkinnedLastMatrix.prepend( itemJoint3D.mBindPoseTransform );// INV_BIND_MATRIX pose( world * paramM )
				
				if( itemJoint3D.mNumChildren )
				{
					updateAllBonesPoseWithAnimation( itemJoint3D );
				}
			}
		}
		
		// DAE统计信息
		private var mDebug_VertexCount:uint = 0;
		private var mDebug_BonesCount:uint = 0;
		private var mDebug_MaxVertexBlend:uint = 0;
		public function dumpDAEDebugInfo():String
		{
			var result:String = '';
			result = 'vertexCount='+mDebug_VertexCount.toString()+', bonesCount='+mDebug_BonesCount.toString()
						+', maxVertexBlend='+mDebug_MaxVertexBlend.toString();
			
			return result;
		}
		
		
		
		//
		//
		// String Utils
		//
		//
		//
		//
		private function trimArrayElements(value:String, delimiter:String):String
		{
			if (value != "" && value != null)
			{
				// first split it
				var items:Array = value.split(delimiter);
				
				// trim every elements
				var len:int = items.length;
				for (var i:int = 0; i < len; i++)
				{
					items[i] = trim(items[i]);
				}
				
				if (len > 0)
				{
					value = items.join(delimiter);
				}
			}
			
			return value;
		}
		
		private function trim(str:String):String
		{
			var startIndex:int = 0;
			while (isWhitespace(str.charAt(startIndex)))
				++startIndex;
			
			var endIndex:int = str.length - 1;
			while (isWhitespace(str.charAt(endIndex)))
				--endIndex;
			
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}
		
		private function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
					
				default:
					return false;
			}
		}
		
		
		
	}
}
import flash.geom.Vector3D;

import yanyan.namespaces.collada;

class DAESource
{
	public var sid:String = '';
	public var originalValues:Array = null;
	public var stride:uint = 0;
	public var count:uint = 0;
	public var values:Vector.<Vector3D> = null;
	
	public function parse(node:XML):DAESource
	{
		this.sid = node.@id;
		
		var strFloatArray:String = trimArrayElements(node.collada::float_array.toString(), " ");
		this.originalValues = strFloatArray.split(/\s+/);
		
		this.stride = node.collada::technique_common.collada::accessor.@stride;
		this.count  = node.collada::technique_common.collada::accessor.@count;
		
		var p:Vector3D = null;
		var index:uint = 0;
		values = new Vector.<Vector3D>;
		for(var i:uint=0; i<count; i++)
		{
			if( this.stride == 3 )
			{
				p = new Vector3D(originalValues[index], originalValues[index+1], originalValues[index+2]);
			}
			else if( this.stride == 2 )
			{
				p = new Vector3D(originalValues[index], originalValues[index+1], 0);
			}
			values.push( p );
			
			index += this.stride;// 步长
		}
		
		return this;
	}
	
	//
	//
	// String Utils
	//
	//
	//
	//
	private function trimArrayElements(value:String, delimiter:String):String
	{
		if (value != "" && value != null)
		{
			// first split it
			var items:Array = value.split(delimiter);
			
			// trim every elements
			var len:int = items.length;
			for (var i:int = 0; i < len; i++)
			{
				items[i] = trim(items[i]);
			}
			
			if (len > 0)
			{
				value = items.join(delimiter);
			}
		}
		
		return value;
	}
	
	private function trim(str:String):String
	{
		var startIndex:int = 0;
		while (isWhitespace(str.charAt(startIndex)))
			++startIndex;
		
		var endIndex:int = str.length - 1;
		while (isWhitespace(str.charAt(endIndex)))
			--endIndex;
		
		if (endIndex >= startIndex)
			return str.slice(startIndex, endIndex + 1);
		else
			return "";
	}
	
	private function isWhitespace(character:String):Boolean
	{
		switch (character)
		{
			case " ":
			case "\t":
			case "\r":
			case "\n":
			case "\f":
				return true;
				
			default:
				return false;
		}
	}
}
