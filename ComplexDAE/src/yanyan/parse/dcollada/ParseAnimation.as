import flash.display.Scene;
import flash.events.Event;
import flash.geom.Matrix3D;
import flash.utils.Dictionary;

import yanyan.GeometryModel;
import yanyan.YObject3D;
import yanyan.YObject3DContainer;
import yanyan.animation.Animation3DChannel;
import yanyan.animation.Animation3DController;
import yanyan.animation.Joint3D;
import yanyan.animation.PairJointWeight;
import yanyan.animation.Skin3D;
import yanyan.namespaces.collada;


	/**
	 * 解析场景结构 
	 * 
	 * 
	 */
	private var mMainSceneSID:String = '';
	private var mJointsStageContainer:Joint3D = null;
	private var mCountBonesQuantity:uint = 0;// 骨骼数量
	private var mVectorJointsNames:Vector.<String> = new Vector.<String>();// 所有骨骼名称

	private var mAnimationFPS:uint = 30;// default value
	private var mAnimationStartTime:Number = .0;// 动画开始时间
	private var mAnimationEndTime:Number = .0;// 动画总时间
	private var mAnimationDelayStarTime:Number = 4.0;// 动画播放到帧尾时延迟时间
	private function parseScene():void
	{
		mMainSceneSID = this.mDaeModelData.collada::scene.collada::instance_visual_scene[0].@url;
		mMainSceneSID = mMainSceneSID.substr(1);
		
		var visualSceneList:XMLList = this.mDaeModelData.collada::library_visual_scenes.collada::visual_scene.(@id == mMainSceneSID);
		if( !visualSceneList[0] )
		{
			trace('$error: ', 'cannot find visual_scene, id=',mMainSceneSID);
			return;
		}
		
		
		// loop add nodes
		var nodeList:XMLList = visualSceneList[0].collada::node;
		mJointsStageContainer = new Joint3D();// 所有骨骼节点的根舞台
		mJointsStageContainer.mBindPoseTransform = new Matrix3D();
		for each(var itemNode:XML in nodeList)
		{
			// loop parse all nodes
			parseNode( itemNode );
		}
		parseAnimationExtraInfo();
		trace('$info: bone hierarchic parsed, bones count=', mCountBonesQuantity.toString());
		trace('$info: ','parse all nodes complete, turn to parse skinned mesh.');
		mDebug_BonesCount = mCountBonesQuantity;
		
		
		
		// parse skinned controller
		var item:Object = null;
		while( arrayInstance_Controller.length )
		{
			item = arrayInstance_Controller.shift();
			parseNodeController(item.controller, item.c);
		}
		trace('$info: ','parse all skinned mesh complete, turn to parse animation channels.');
		
		
		
		// parse library_nodes
		parseLibraryNodes();
		
		
		
		// parse all animation channels
		parseAnimationData();
		
		
		
		// start animation
		if( _mIsAutoPlayingAnimation && mIsHasBonesAnimation )
		{
			trace('$info: auto start playing dae animation.');
			mAnimation3DController.mAnimationFPS = mAnimationFPS;
			mAnimation3DController.mAnimationTotalTime = mAnimationEndTime;
			mAnimation3DController.mAnimationDelayStartTime = mAnimationDelayStarTime;
			mAnimation3DController.play();
		}
		
		// complete
		trace('$info: ','ok! parse all complete!');
		this.dispatchEvent( new Event('parseAllCompleteEvent') );
	}

	/**
	 * 解析库节点模型结构
	 *  
	 * 
	 */
	private var dictNodesToGeometryMap:Dictionary = new Dictionary();
	private function parseLibraryNodes():void
	{
		// parse node geometry, and store it
		var listNodes:XMLList = this.mDaeModelData.collada::library_nodes..collada::instance_geometry;
		var itemNode:XML = null, parentNode:XML, frontNode:XML;
		var itemLists:XMLList = null;
		
		for each(itemNode in listNodes)
		{
			parentNode =  itemNode.parent();
			if( parentNode && parentNode.localName() == 'node' )
			{
				createNodeGeometry( parentNode, true );
			}
		}
		
		// parse nodes link
		var item:Object = null, rootNode:XML, rootNodeName:String, 
			rootContainer:YObject3DContainer;
		while( arrayInstance_NodeController.length )
		{
			item = arrayInstance_NodeController.shift();
			rootNodeName = item.node_controller;
			rootContainer = item.c;
			
			rootNode = this.mDaeModelData.collada::library_nodes.collada::node.(@id == rootNodeName)[0];
			if( rootNode )
			{
				recursionNodesTree(rootNode, rootContainer);
			}
		}
	}

	private function recursionNodesTree(nodeItem:XML, c:YObject3DContainer):void
	{
		var nodeId:String = nodeItem.@id;
		var instance:YObject3DContainer = null;
		
		// instance_geometry
		if( nodeItem.collada::instance_geometry.length() )
		{
			if( nodeId == 'mesh76' )
				trace('pause!');
			
			instance = dictNodesToGeometryMap[nodeId];
			if( instance )
			{
				c.addChild( instance );
				return;
			}
		}
		
		// create instance
		instance = new YObject3DContainer();
		instance.name = nodeId;
		c.addChild( instance );
		
		// matrix
		if( nodeItem.collada::matrix.length() )
		{
			var nodeMatrix:Matrix3D = null;
			var valueMatrix:String = trimArrayElements(nodeItem.collada::matrix.toString(), " ");
			var temp:Array = valueMatrix.split(/\s+/);
			nodeMatrix = fromColladaArray( temp );
			
			instance.copyTransform( nodeMatrix );
		}
		
		// instance_node
		if( nodeItem.collada::instance_node.length() )
		{
			var linkURL:String = nodeItem.collada::instance_node.@url.toString().substr(1);
			var linkContainer:YObject3DContainer = dictNodesToGeometryMap[linkURL]
			if( linkContainer )
				instance.addChild( linkContainer );// if it just a geometry node, add it simplely.
			else
			{
				// recursion link node, and add it
				var xmlLinkNode:XML = this.mDaeModelData.collada::library_nodes..collada::node.(@id == linkURL)[0];
				if( xmlLinkNode )
				{
					recursionNodesTree( xmlLinkNode, instance );
				}
				else
					trace('$error: cannot find instance_node link xml, url=',linkURL);
			}
		}
		
		// recursion it
		var children:XMLList = nodeItem.collada::node;
		var childItem:XML;
		for each(childItem in children)
		{
			recursionNodesTree( childItem, instance );
		}
	}

	private function createNodeGeometry(node:XML, b:Boolean):void
	{
		var nodeId:String = node.@id;
		
		// create link instance
		var container:YObject3DContainer = new YObject3DContainer();
		container.name = nodeId;
		
		// matrix
		if( node.collada::matrix.length() )
		{
			var nodeMatrix:Matrix3D = null;
			var valueMatrix:String = trimArrayElements(node.collada::matrix.toString(), " ");
			var temp:Array = valueMatrix.split(/\s+/);
			nodeMatrix = fromColladaArray( temp );
			container.copyTransform( nodeMatrix );
		}
		
		// geometry info
		if( node.collada::instance_geometry.length() )
		{
			var linkURL:String = node.collada::instance_geometry.@url.toString().substr(1);
			var instanceGeometry:GeometryModel = dictGeometryReference[ linkURL ];
			if( !instanceGeometry )
			{
				//trace('$error: cannot find geometry instance, id=', linkURL);
				//return;
				// allow doesnot exist
			}
			else
				container.mGeometryData = instanceGeometry;
		}
		
		if( b )
		{
			dictNodesToGeometryMap[nodeId] = container;
		}
	}

	/**
	 * 解析场景节点数，并场景蒙皮控制器 
	 * 
	 * 
	 */
	private var dictJointsReference:Dictionary = new Dictionary();
	private var arrayInstance_Controller:Array = new Array();// skin controller
	private var arrayInstance_NodeController:Array = new Array();// nodes controller
	private function parseNode(itemNode:XML, parent:YObject3DContainer=null):void
	{
		var isJoint:Boolean = itemNode.@type == 'JOINT';
		var pContainer:YObject3DContainer = parent? parent : (isJoint ? this.mJointsStageContainer : this.mRootDae);
		var instance:YObject3DContainer = isJoint ? new Joint3D() : new YObject3DContainer();
		
		if( itemNode.collada::instance_controller.length() )
		{
			//
			// 蒙皮控制器
			//
			//
			//
			arrayInstance_Controller.push( {'controller':itemNode.collada::instance_controller, 'c':instance} );
		}
		
		if( itemNode.collada::instance_node.length() )
		{
			//
			// link library_nodes
			//
			//
			arrayInstance_NodeController.push( {'node_controller':itemNode.collada::instance_node.@url.toString().substr(1), 
													'c':instance} );	
		}
		
		if( itemNode.collada::instance_geometry.length() )
		{
			//
			// 关联模型
			//
			//
			//
			var linkGeometryName:String = itemNode.collada::instance_geometry.@url.toString().substr(1);
			var instanceGeometry:GeometryModel = dictGeometryReference[linkGeometryName];
			
			var container:YObject3D = new YObject3D();
			container.mGeometryData = instanceGeometry;
			
			instance.addChild( container );
			container.name = 'instance_geometry$'+linkGeometryName;
		}
		
		// parse transform and it's children
		if( itemNode.collada::matrix.length() )
		{
			instance.copyTransform( buildMatrix3D( itemNode.collada::matrix[0] ) );
		}
		else
		{
			// use the IDENTITY matrix
		}
		
		// add to container
		if( !isJoint )
			pContainer.addChild( instance );
		else
		{
			if( pContainer is Joint3D )
				pContainer.addChild( instance );
			
			mCountBonesQuantity++;
		}
		
		var name:String = isJoint ? itemNode.@sid.toString() : itemNode.@name.toString();
		instance.name = name;
		
		if( isJoint )
		{
			dictJointsReference[ itemNode.@sid.toString() ] = instance;// sid - instance
			dictBoneIdToSIDMap[ itemNode.@id.toString() ] = itemNode.@sid.toString();;// id - sid
			mVectorJointsNames.push( itemNode.@sid.toString() );
			
			//
			// @NOTICE: 可能一个节点没有bindMatrix，初始化下
			//
			Joint3D(instance).mBindPoseTransform = new Matrix3D();
		}
		
		// save map for joints
		if( isJoint )
			dictJointsReference[ itemNode.@sid.toString() ] = instance;
		
		// loop all children node list
		if( itemNode.collada::node )
		{
			for each(var item:XML in itemNode.collada::node)
				parseNode(item, instance);// loop
		}
	}

	private function parseAnimationExtraInfo():void
	{
		var itemVisualScene:XML = this.mDaeModelData.collada::library_visual_scenes.collada::visual_scene[0];
		if( itemVisualScene && itemVisualScene.collada::extra.length() )
		{
			var itemExtraList:XMLList = itemVisualScene.collada::extra;
			for each(var item:XML in itemExtraList)
			{
				// fps
				if( item.collada::technique.length() && item.collada::technique.collada::frame_rate.length() )
				{
					mAnimationFPS = parseInt( item.collada::technique.collada::frame_rate.toString() );
				}
				
				if( item.collada::technique.length() && item.collada::technique.collada::start_time.length() )
				{
					mAnimationStartTime = Number( item.collada::technique.collada::start_time.toString() );
				}
				
				if( item.collada::technique.length() && item.collada::technique.collada::end_time.length() )
				{
					mAnimationEndTime = Number( item.collada::technique.collada::end_time.toString() );
				}
			}
		}
	}
	
	private function buildMatrix3D( item:XML ):Matrix3D
	{
		var strValue:String = trimArrayElements(item.toString(), " ");
		var values:Array = strValue.split(/\s+/);
		var type:String = item.@sid;
		var matrix:Matrix3D = fromColladaArray( values );
		
		return matrix;
	}

	private function fromColladaArray(a:Array):Matrix3D
	{
		var raw:Vector.<Number> = new Vector.<Number>(a.length);
		raw[0] = a[0];
		raw[1] = a[4];
		raw[2] = a[8];
		raw[3] = a[12];// x
		
		raw[4] = a[1];
		raw[5] = a[5];
		raw[6] = a[9];
		raw[7] = a[13];// y
		
		raw[8] = a[2];
		raw[9] = a[6];
		raw[10] = a[10];
		raw[11] = a[14];// z
		
		raw[12] = a[3];
		raw[13] = a[7];
		raw[14] = a[11];
		raw[15] = a[15];// 1
		
		var matrix:Matrix3D = new Matrix3D(raw);
		
		return matrix;
	}

	/**
	 * 解析节点下的蒙皮控制器 
	 * 
	 * 
	 */
	private function parseNodeController( items:XMLList, c:YObject3DContainer ):void
	{
		var skinURL:String = '', bindMaterailMap:Object={};
		for each(var item:XML in items)
		{
			skinURL = item.@url.toString().substr(1);
			var list:XMLList = item.collada::bind_material.collada::technique_common.collada::instance_material;
			for each(var instanceMaterial:XML in list)
			{
				// key - geometryID, value - materialID
				bindMaterailMap[ instanceMaterial.@target.toString().substr(1) ] = instanceMaterial.@symbol;
			}
			
			// skinID, materials, container
			parseSkinController(skinURL, bindMaterailMap, c);
		}
	}

	/**
	 * 解析蒙皮控制器 
	 * 
	 * 
	 */
	private var dictGeometryReference:Dictionary = new Dictionary();
	private function parseSkinController(url:String, material:Object, c:YObject3DContainer):void
	{
		var itemController:XML = this.mDaeModelData.collada::library_controllers.collada::controller.(@id == url )[0];
		if( !itemController )
		{
			trace('error','cannot find controller, id=',url);
			return;
		}
		
		// parse skin
		var skin:XML = itemController.collada::skin[0];
		var skinMeshLinkName:String = skin.@source.toString().substr(1);
		var strValue:String = trimArrayElements(skin.collada::bind_shape_matrix.toString(), ' ');
		var bindValues:Array = strValue.split(/\s+/);
		var bindMatrix3D:Matrix3D = fromColladaArray( bindValues );
		
		// joints
		var xmlJoints:XMLList = skin.collada::joints.collada::input;
		var urlJoints:String, urlPoses:String;
		for each(var itemInput:XML in xmlJoints)
		{
			if(itemInput.@semantic == 'JOINT')
				urlJoints = itemInput.@source.toString().substr(1);
			else if(itemInput.@semantic == 'INV_BIND_MATRIX')
				urlPoses = itemInput.@source.toString().substr(1);
		}
		
		// get joints list
		var xmlJointsList:XML = skin.collada::source.(@id == urlJoints)[0];
		var xmlPosesList:XML = skin.collada::source.(@id == urlPoses)[0];
		var strJointsNames:String = trimArrayElements(xmlJointsList.collada::Name_array.toString(), " ");
		var arrayJointsName:Vector.<String> = Vector.<String>( strJointsNames.split(/\s+/) );
		var strPosesMatrix:String = trimArrayElements(xmlPosesList.collada::float_array.toString(), " ");
		var arrayPoses:Vector.<Matrix3D> = parseMatrix( strPosesMatrix.split(/\s+/) );
		
		// parse vertex_weights
		var urlWeights:String;
		var vInputList:XMLList = skin.collada::vertex_weights.collada::input;
		for each(var vInput:XML in vInputList)
		{
			if( vInput.@semantic == 'WEIGHT' )
				urlWeights = vInput.@source.toString().substr(1);
		}
		var strWeightsValue:String = XML(skin.collada::source.(@id == urlWeights)[0]).collada::float_array.toString();
		var arrayWeights:Vector.<Number> = Vector.<Number>( strWeightsValue.split(/\s+/) );
		
		// ok, we must parse the weights for vertex
		var skinMesh:Skin3D = new Skin3D();
		c.addChild( skinMesh );
		c.name = url;
		
		// 链接蒙皮网络
		skinMesh.mBindShapeMatrix = bindMatrix3D;// 设置模型绑定matrix
		skinMesh.mGeometryData = dictGeometryReference[skinMeshLinkName];
		
		
		// 统计骨骼数据
		skinMesh.mInflBonesCount = arrayJointsName.length;
		skinMesh.mVectorJointsNames = arrayJointsName.concat();
		// may be sort it
		skinMesh.mDictJointsMap = dictJointsReference;
		
		var itemVertexWeights:XML = skin.collada::vertex_weights[0];
		var strValues:String = trimArrayElements(itemVertexWeights.collada::vcount.toString(), " ");
		var arrayVCount:Vector.<uint> = Vector.<uint>( strValues.split(/\s+/) );// vertex_weights.vcount
		strValues = trimArrayElements(itemVertexWeights.collada::v.toString(), " ");
		var arrayVInfo:Vector.<uint> = Vector.<uint>( strValues.split(/\s+/) );// vertex_weights.v
		
		var count:uint = arrayVCount.length;
		var numBoneAffect:uint = 0;// 一个顶点受到作用的骨骼数
		var intBondId:uint, intWeightId:uint, intIndexLocal:uint=0;
		var itemPair:PairJointWeight = null, itemPrePair:PairJointWeight, itemTempPair:PairJointWeight;
		var intActualBoneAffect:uint = 0;
		for(var i:uint=0; i<count; i++) // loop all vertexs
		{
			numBoneAffect = arrayVCount[i];
			
			intActualBoneAffect = 0;
			itemPair = itemPrePair = null;
			itemTempPair = null;
			
			for(var k:uint=intIndexLocal; k < intIndexLocal+numBoneAffect*2; k += 2)
			{
				intBondId = arrayVInfo[k];// bone index
				intWeightId = arrayVInfo[k+1];// weight index
				
				if( arrayWeights[intWeightId] == undefined )
					throw new Error('error!');
				
				if( arrayWeights[intWeightId] != 0.0 )
				{
					intActualBoneAffect++;// 统计实际受作用于的骨骼数
					
					itemPair = new PairJointWeight();
					
					itemPair.numWeight = arrayWeights[intWeightId];
					itemPair.mJointPointer = dictJointsReference[ arrayJointsName[intBondId] ];// get joints pointer
					
					if( itemPrePair )
						itemPrePair.mNextLink = itemPair;
					
					if(itemPrePair)
						itemPair.mPreLink = itemPrePair;
					
					itemPrePair = itemPair;// save pointer
				}
				if( !itemTempPair && k == intIndexLocal )
				{
					//
					// 独立的缓冲展位骨骼权重设置
					//
					itemTempPair = new PairJointWeight();
					itemTempPair.numWeight = 0.0;// .0;
					itemTempPair.mJointPointer = dictJointsReference[ arrayJointsName[intBondId] ];// get joints pointer
					
					itemTempPair.mNextLink = null;// Just for a temp
				}

			}// end for
			
			if( itemPair )
				skinMesh.pushVertexWeightPair( itemPair );
			else
				skinMesh.pushVertexWeightPair( itemTempPair );
			
			// reset max bone infl
			if( numBoneAffect != intActualBoneAffect )
			{
				trace("info: has cut some empty infl bones. intActualBoneAffect=",intActualBoneAffect, ' vertexIndex=', i);
				if( skinMesh.intMaxBoneBlend < intActualBoneAffect )
					skinMesh.intMaxBoneBlend = intActualBoneAffect;// 当前蒙皮最大的顶点混合
			}
			else
			{
				if( skinMesh.intMaxBoneBlend < numBoneAffect )
					skinMesh.intMaxBoneBlend = numBoneAffect;// 当前蒙皮最大的顶点混合
			}
			
			// statics max vertex blend
			if( skinMesh.intMaxBoneBlend > mDebug_MaxVertexBlend )
				mDebug_MaxVertexBlend = skinMesh.intMaxBoneBlend;
			
			intIndexLocal += numBoneAffect*2;
			
		}// end for
		
		// fectch joint's mBindPoseTransform for it
		var jcount:uint = arrayJointsName.length, itemJointPointer:Joint3D=null;
		for(var kk:uint=0; kk < jcount; kk++)
		{
			itemJointPointer = dictJointsReference[ arrayJointsName[kk] ];
			if( itemJointPointer )
				itemJointPointer.mBindPoseTransform = arrayPoses[kk];
			else
				trace("lose joint instance!");
		}
		
		
		// origine vertex skinned buffer
		trace('info: ',"current skin mesh max bones infl,count=",skinMesh.intMaxBoneBlend);
		skinMesh.updateVertexSkinnedBuffer();
		
	}

	private function parseMatrix(values:Array):Vector.<Matrix3D>
	{
		var count:uint = values.length/16;
		var temp:Array = null;
		var matrix:Matrix3D, vector:Vector.<Number>;
		var result:Vector.<Matrix3D> = new Vector.<Matrix3D>();
		for(var i:uint=0; i<count; i++)
		{
			temp = values.splice(0, 16);
			matrix = fromColladaArray( temp );
			result.push( matrix );
		}
		
		return result;
	}

	/**
	 * 解析所有的骨骼节点对应的channel动画信息 
	 * 
	 * 
	 */
	private var dictAnimationChannel:Dictionary = new Dictionary();
	private var dictBoneIdToSIDMap:Dictionary = new Dictionary();// key(id) - sid
	private var mAnimation3DController:Animation3DController = null;
	private function parseAnimationData():void
	{
		mAnimation3DController = new Animation3DController();
		
		var animationChannel:Animation3DChannel = null;
		var animations:XMLList = this.mDaeModelData.collada::library_animations.collada::animation;
		for each(var itemAnimation:XML in animations)
		{
			animationChannel = new Animation3DChannel();
			animationChannel.parse( itemAnimation );
			animationChannel.mJointPointer = dictJointsReference[ dictBoneIdToSIDMap[animationChannel.mAffectTargetId] ];
			
			// push to animation controller
			mAnimation3DController.addChannel( animationChannel );
			
			// key - value
			dictAnimationChannel[ animationChannel.mAffectTargetId ] = animationChannel;
		}
	}


	protected var _mIsAutoPlayingAnimation:Boolean = true;
	public function get isAutoPlayingAnimation():Boolean 
	{
		return _mIsAutoPlayingAnimation;
	}




