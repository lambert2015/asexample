package org.angle3d.app
{
	import flash.ui.Keyboard;
	import org.angle3d.input.controls.ActionListener;
	import org.angle3d.input.controls.KeyTrigger;
	import org.angle3d.input.FlyByCamera;
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.queue.QueueBucket;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.scene.CullHint;
	import org.angle3d.scene.Node;
	import org.angle3d.utils.Logger;
	import org.angle3d.material.sgsl.SgslVersion;

	/**
	 * <code>SimpleApplication</code> extends the {@link com.jme3.app.Application}
	 * public class to provide default functionality like a first-person camera,
	 * and an accessible root node that is updated and rendered regularly.
	 * Additionally, <code>SimpleApplication</code> will display a statistics view
	 * using the {@link com.jme3.app.StatsView} public class. It will display
	 * the current frames-per-second value on-screen in addition to the statistics.
	 * Several keys have special functionality in <code>SimpleApplication</code>:<br/>
	 *
	 * <table>
	 * <tr><td>Esc</td><td>- Close the application</td></tr>
	 * <tr><td>C</td><td>- Display the camera position and rotation in the console.</td></tr>
	 * <tr><td>M</td><td>- Display memory usage in the console.</td></tr>
	 * </table>
	 */
	public class SimpleApplication extends Application implements ActionListener
	{
		public static const INPUT_MAPPING_EXIT:String="SIMPLEAPP_Exit";
		public static const INPUT_MAPPING_CAMERA_POS:String="SIMPLEAPP_CameraPos";

		protected var _scene:Node;
		protected var _gui:Node;

		protected var flyCam:FlyByCamera;

		public function SimpleApplication(sgslVersion:int=1)
		{
			super(sgslVersion);
		}

		public function onAction(name:String, value:Boolean, tpf:Number):void
		{
			if (!value)
			{
				return;
			}

			if (name == INPUT_MAPPING_EXIT)
			{
				stop();
			}
			else if (name == INPUT_MAPPING_CAMERA_POS)
			{
				if (cam != null)
				{
					var loc:Vector3f=cam.location;
					var rot:Quaternion=cam.rotation;

					CF::DEBUG
					{
						Logger.log("Camera Position: (" + loc.x + ", " + loc.y + ", " + loc.z + ")");
						Logger.log("Camera Rotation: " + rot);
						Logger.log("Camera Direction: " + cam.getDirection());
					}

				}
			}
		}

		/**
		 * Retrieves flyCam
		 * @return flyCam Camera object
		 *
		 */
		public function getFlyByCamera():FlyByCamera
		{
			return flyCam;
		}

		/**
		 * Retrieves guiNode
		 * @return guiNode Node object
		 *
		 */
		public function get gui():Node
		{
			return _gui;
		}

		/**
		 * Retrieves rootNode
		 * @return rootNode Node object
		 *
		 */
		public function get scene():Node
		{
			return _scene;
		}

		override protected function initialize(width:int, height:int):void
		{
			super.initialize(width, height);

			_scene=new Node("Root Node");
			viewPort.attachScene(_scene);

			_gui=new Node("Gui Node");
			_gui.localQueueBucket=QueueBucket.Gui;
			_gui.localCullHint=CullHint.Never;
			guiViewPort.attachScene(_gui);

			if (inputManager != null)
			{
				flyCam=new FlyByCamera(cam);
				flyCam.setMoveSpeed(1.0);
				flyCam.setRotationSpeed(3.0);
				flyCam.registerWithInput(inputManager);

				inputManager.addSingleMapping(INPUT_MAPPING_CAMERA_POS, new KeyTrigger(Keyboard.C));

				var arr:Array=[INPUT_MAPPING_CAMERA_POS];

				inputManager.addListener(this, arr);
			}

			// call user code
			simpleInitApp();
		}

		override public function update():void
		{
			super.update();

			//update states
			stateManager.update(timePerFrame);

			// simple update and root node
			simpleUpdate(timePerFrame);

			_scene.update(timePerFrame);
			_gui.update(timePerFrame);

//			_scene.updateLogicalState(timePerFrame);
//			_scene.updateGeometricState();
//
//			_gui.updateLogicalState(timePerFrame);
//			_gui.updateGeometricState();

			// render states
			stateManager.render(renderManager);

			renderManager.render(timePerFrame);

			simpleRender(renderManager);

			stateManager.postRender();
		}

		public function simpleInitApp():void
		{
			start();
		}

		public function simpleUpdate(tpf:Number):void
		{

		}

		public function simpleRender(rm:RenderManager):void
		{

		}
	}
}

