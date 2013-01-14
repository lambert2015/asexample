package
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	import yanyan.Yz3D;
	import yanyan.camera.BaseCamera;
	import yanyan.parse.dcollada.DAE;
	import yanyan.render.BaseRender;
	import yanyan.scene.Scene3D;



	[SWF(width = '1000', height = '600', backgroundColor = '0xCCCC', frameRate = '60')]
	public class ParseDAE extends Sprite
	{
		// stage3d
		private var mStage3D:Stage3D = null;
		private var mContext3D:Context3D = null;

		public function ParseDAE()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedHandler);
		}

		private function onAddedHandler(evt:Event):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;

			mStage3D = stage.stage3Ds[0];
			mStage3D.addEventListener(Event.CONTEXT3D_CREATE, onCreatedHandler);
			mStage3D.requestContext3D(Context3DRenderMode.AUTO);
		}

		private function onCreatedHandler(evt:Event):void
		{
			mDebug_DriveInfo = mStage3D.context3D.driverInfo;
			if (mDebug_DriveInfo.indexOf('Software') == -1)
				mDebug_IsSupportHd = true;


			// add stats
			addChild(new Stats());

			initStag3D();
		}

		private function initStag3D():void
		{
			mContext3D = mStage3D.context3D;
			mContext3D.configureBackBuffer(1000, 600, 16, true);
			mContext3D.enableErrorChecking = true;

			// save pointer
			Yz3D.context3DHolder = mContext3D;

			initEngine();
			loadDaeFile();
		}


		private var mScene:Scene3D = null;
		private var mCamera:BaseCamera = null;
		private var mRenderEngine:BaseRender = null;
		private var mRenderSession:Object = {};

		protected function initEngine():void
		{
			mScene = new Scene3D();
			mCamera = new BaseCamera();
			mRenderEngine = new BaseRender();
			mRenderEngine.setContext3D(mContext3D);

			mRenderSession.scene = mScene;
			mRenderSession.camera = mCamera;
			mRenderSession.render = mRenderEngine;
			mRenderSession.shareProjectMatrix = new Matrix3D;
		}


		private var dae:DAE = null;

		private function loadDaeFile():void
		{
			dae = new DAE();

			/*
			 * 更改路径，设置其他模型进行渲染测试
			 *
			 *
			 *
			 */
			var path:String = 'assets/airplane/models/airplane.dae';
			// 'assets/Citizen Extras_Female 02/models/Citizen Extras_Female 02.dae';
			// 'assets/airplane/models/airplane.dae';
			// 'assets/Wall-E mark 2/models/Wall-E mark 2.dae';
			// "model/model.DAE";
			// "assets/lego robot/models/lego robot.dae";


			dae.load(path);
			mScene.addChild(dae);
			dae.addEventListener('parseAllCompleteEvent', completeHandler);
		}


		private function completeHandler(evt:Event):void
		{
			showDebugStaticsInfo();

			// reset dae file aix-x
			if (dae.mIsAxisZUP)
			{
				dae.transform.appendRotation(-90, new Vector3D(1, 0, 0));
				dae.transform.appendRotation(180, new Vector3D(0, 1, 0));
			}

			// setup camera
			updateCameraTransform();

			// rendering
			startRender();

			// listeners
			addStageMouseEventListener();
		}

		private var mDebug_IsSupportHd:Boolean = false;
		private var mDebug_DriveInfo:String = '';

		private function showDebugStaticsInfo():void
		{
			var txt:TextField = new TextField();
			txt.selectable = false;
			txt.autoSize = TextFieldAutoSize.LEFT;
			var format:TextFormat = new TextFormat('Arial', 12, 0x00FF00);
			txt.defaultTextFormat = format;
			txt.text = 'DriveInfo=' + mDebug_DriveInfo.toString() + ',support hd=' + mDebug_IsSupportHd.toString() + ',' + dae.dumpDAEDebugInfo()
				+ " use mouse control camera!";
			addChild(txt);

			txt.y = stage.stageHeight - txt.height - 10;
		}

		private function startRender():void
		{
			stage.addEventListener(Event.ENTER_FRAME, enterframeHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);

			trace('info: ', 'start rendering charactor animation.');
			trace('-----------------------------------------------------------------------------------\n');
		}

		private function enterframeHandler(evt:Event):void
		{
			if (mContext3D.driverInfo == "Disposed")
				return;

			mContext3D.clear();

			// reset
			//updateCameraTransform();
			mRenderEngine.clearAllRenderList();

			// project all objects
			mScene.project(null, mRenderSession);

			// excute renderlist
			mRenderEngine.render(mRenderSession);


			mContext3D.present();
		}

		/*
		 * 控制camera
		 *
		 *
		 */
		private var intCameraDistance:int = -836;
		private var numCameraRotationZ:Number = 270;

		private function onKeyDownHandler(evt:KeyboardEvent):void
		{
			var code:uint = evt.keyCode;
			if (intCameraDistance >= -5000 && intCameraDistance <= 5000)
			{
				switch (code)
				{
					case Keyboard.UP:
						intCameraDistance += 5;
						break;
					case Keyboard.DOWN:
						intCameraDistance += -5;
						break;
				}
			}
		}

		private function onMouseWheelHandler(evt:MouseEvent):void
		{
			if (intCameraDistance >= -5000 && intCameraDistance <= 5000)
			{
				intCameraDistance += evt.delta * 2;

				updateCameraTransform();
			}
		}

		private function updateCameraTransform():void
		{
			mCamera.transform.identity();

			//numCameraRotationZ += 3;
			numCameraRotationZ %= 360;
			if (numCameraRotationZ < 0)
				numCameraRotationZ += 360;
			mCamera.transform.appendRotation(numCameraRotationZ - 90, new Vector3D(0, 1, 0));

			var vx:Number = intCameraDistance * Math.cos(numCameraRotationZ * Math.PI / 180);
			var vz:Number = -intCameraDistance * Math.sin(numCameraRotationZ * Math.PI / 180);
			mCamera.transform.copyColumnFrom(3, new Vector3D(vx, 0, vz, 1));
		}


		/*
		 * camera视图控制
		 *
		 *
		 */
		private var mRoundAxisXDegress:Number = 0; // up-down
		private var mRoundAxisYDegress:Number = 180; // lef-right
		private var mOrbitTarget:Vector3D = new Vector3D(0, 0, 0, 1.0);
		private var mLookAtTarget:Matrix3D = new Matrix3D();
		private var previousMouseX:Number = .0;
		private var previousMouseY:Number = .0;

		protected function orbit(pitch:Number, yaw:Number, target:Vector3D):void
		{
			pitch *= Math.PI / 180; // rotation aroud axis-x
			yaw *= Math.PI / 180; // rotation aroud axis-y

			// sub
			var dx:Number = target.x - mCamera.transform.rawData[12];
			var dy:Number = target.y - mCamera.transform.rawData[13];
			var dz:Number = target.z - mCamera.transform.rawData[14];

			// modulo
			var distance:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);

			// rotation
			var rx:Number = Math.sin(yaw) * Math.cos(pitch);
			var rz:Number = Math.cos(yaw) * Math.cos(pitch);
			var ry:Number = Math.sin(pitch);

			// reset local
			var nx:Number = target.x + (rx * distance);
			var ny:Number = target.y + (ry * distance);
			var nz:Number = target.z + (rz * distance);

			// copy to transform
			mCamera.transform.copyColumnFrom(3, new Vector3D(nx, ny, nz, 1));

			// lookat it
			lookAtTarget(mLookAtTarget);
		}

		protected function lookAtTarget(target:Matrix3D, upAxis:Vector3D = null):void
		{
			if (!upAxis)
				upAxis = new Vector3D(0, 1, 0);

			var _lookatTarget:Vector3D = new Vector3D(target.rawData[12], target.rawData[13], target.rawData[14], 0);
			var _position:Vector3D = new Vector3D(mCamera.transform.rawData[12], mCamera.transform.rawData[13],
				mCamera.transform.rawData[14], 0);

			var _zAxis:Vector3D = new Vector3D();
			var _xAxis:Vector3D = null;
			var _yAxis:Vector3D = null;

			_zAxis.copyFrom(_lookatTarget);
			_zAxis.x = _zAxis.x - _position.x;
			_zAxis.y = _zAxis.y - _position.y;
			_zAxis.z = _zAxis.z - _position.z;
			_zAxis.scaleBy(-1);
			_zAxis.normalize();

			if (_zAxis.length > 0.1)
			{
				_xAxis = _zAxis.crossProduct(upAxis);
				_xAxis.normalize();

				_yAxis = _zAxis.crossProduct(_xAxis);
				_yAxis.normalize();

				var look:Matrix3D = mCamera.transform;

				_xAxis.w = _yAxis.w = _zAxis.w = 0;
				_yAxis.y = 1;

				look.copyColumnFrom(0, _xAxis);
				look.copyColumnFrom(1, _yAxis);
				look.copyColumnFrom(2, _zAxis);
			}
			else
			{
				trace('$error: look at target failed!');
			}
		}

		private function addStageMouseEventListener():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}

		private function onMouseDownHandler(evt:MouseEvent):void
		{
			previousMouseX = evt.stageX;
			previousMouseY = evt.stageY;

			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}

		private function onMouseUpHandler(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}

		private function onMouseMoveHandler(evt:MouseEvent):void
		{
			var differenceX:Number = evt.stageX - previousMouseX;
			var differenceY:Number = evt.stageY - previousMouseY;

			mRoundAxisXDegress += differenceY; // rotation axis-x
			mRoundAxisYDegress += differenceX;

			mRoundAxisXDegress %= 360; //x
			mRoundAxisYDegress %= 360; //y

			mRoundAxisXDegress = mRoundAxisXDegress > 0 ? mRoundAxisXDegress : 0.0001; //y
			mRoundAxisXDegress = mRoundAxisXDegress < 45 ? mRoundAxisXDegress : 45; //x

			// save it
			previousMouseX = evt.stageX;
			previousMouseY = evt.stageY;

			//mRoundAxisXDegress = 0;
			//mRoundAxisYDegress = 180;

			// orbit the target: mOrbitTarget
			orbit(mRoundAxisXDegress, mRoundAxisYDegress, mOrbitTarget);
		}



	}
}










