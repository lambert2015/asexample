package org.angle3d.cinematic
{

	import flash.utils.Dictionary;

	import org.angle3d.app.Application;
	import org.angle3d.app.state.AppState;
	import org.angle3d.app.state.AppStateManager;
	import org.angle3d.cinematic.event.AbstractCinematicEvent;
	import org.angle3d.cinematic.event.CinematicEvent;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.scene.CameraNode;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.control.CameraControl;

	/**
	 * ...
	 * @author andy
	 */

	public class Cinematic extends AbstractCinematicEvent implements AppState
	{
		private var scene : Node;
		private var timeLine : TimeLine;
		private var lastFetchedKeyFrame : int;
		private var cinematicEvents : Vector.<CinematicEvent>;
		private var cameraMap : Dictionary; //<String,CameraNode>;
		private var currentCam : CameraNode;
		private var initialized : Boolean;
		private var scheduledPause : int;

		public function Cinematic(scene : Node, initialDuration : Number = 10, loopMode : int = 0)
		{
			super(initialDuration, loopMode);

			timeLine = new TimeLine();
			lastFetchedKeyFrame = -1;
			cinematicEvents = new Vector.<CinematicEvent>();
			cameraMap = new Dictionary();
			initialized = false;
			scheduledPause = -1;

			this.scene = scene;
		}

		override public function onPlay() : void
		{
			if (isInitialized())
			{
				scheduledPause = -1;
				//enableCurrentCam(true);
				if (playState == PlayState.Paused)
				{
					var length : int = cinematicEvents.length;
					for (var i : int = 0; i < length; i++)
					{
						var ct : CinematicEvent = cinematicEvents[i];
						if (ct.getPlayState() == PlayState.Paused)
						{
							ct.play();
						}
					}
				}
			}
		}

		override public function onStop() : void
		{
			time = 0;
			lastFetchedKeyFrame = -1;
			var length : int = cinematicEvents.length;
			for (var i : int = 0; i < length; i++)
			{
				var ct : CinematicEvent = cinematicEvents[i];
				ct.setTime(0);
				ct.stop();
			}
			enableCurrentCam(false);
		}

		override public function onPause() : void
		{
			var length : int = cinematicEvents.length;
			for (var i : int = 0; i < length; i++)
			{
				var ct : CinematicEvent = cinematicEvents[i];
				if (ct.getPlayState() == PlayState.Playing)
				{
					ct.pause();
				}
			}
			//enableCurrentCam(false);
		}

		override public function setSpeed(speed : Number) : void
		{
			super.setSpeed(speed);
			var length : int = cinematicEvents.length;
			for (var i : int = 0; i < length; i++)
			{
				var ct : CinematicEvent = cinematicEvents[i];
				ct.setSpeed(speed);
			}
		}

		public function initialize(stateManager : AppStateManager, app : Application) : void
		{
			init(app, this);
			var length : int = cinematicEvents.length;
			for (var i : int = 0; i < length; i++)
			{
				var ct : CinematicEvent = cinematicEvents[i];
				ct.init(app, this);
			}

			initialized = true;
		}

		public function set enabled(value : Boolean) : void
		{
			if (value)
			{
				play();
			}
		}

		public function get enabled() : Boolean
		{
			return playState == PlayState.Playing;
		}

		public function stateAttached(stateManager : AppStateManager) : void
		{
		}

		public function stateDetached(stateManager : AppStateManager) : void
		{
			stop();
		}

		public function update(tpf : Number) : void
		{
			if (isInitialized())
			{
				internalUpdate(tpf);
			}
		}

		private function step() : void
		{
			if (playState != PlayState.Playing)
			{
				play();
				scheduledPause = 2;
			}
		}

		override public function onUpdate(tpf : Number) : void
		{
			if (scheduledPause >= 0)
			{
				if (scheduledPause == 0)
				{
					pause();
				}
				scheduledPause--;
			}

			var length : int = cinematicEvents.length;
			for (var i : int = 0; i < length; i++)
			{
				var ct : CinematicEvent = cinematicEvents[i];
				ct.internalUpdate(tpf);
			}

			var keyFrameIndex : int = timeLine.getKeyFrameIndexFromTime(time);

			//iterate to make sure every key frame is triggered
			i = lastFetchedKeyFrame + 1;
			while (i <= keyFrameIndex)
			{
				var keyFrame : KeyFrame = timeLine.getKeyFrameAtIndex(i);
				if (keyFrame != null)
				{
					keyFrame.trigger();
				}

				i++;
			}

			lastFetchedKeyFrame = keyFrameIndex;
		}

		override public function setTime(time : Number) : void
		{
			//stopping all events
			onStop();

			super.setTime(time);

			var keyFrameIndex : int = timeLine.getKeyFrameIndexFromTime(time);

			//triggering all the event from start to "time" 
			//then computing timeOffset for each event
			for (var i : int = 0; i < (keyFrameIndex + 1); i++)
			{
				var keyFrame : KeyFrame = timeLine.getKeyFrameAtIndex(i);
				if (keyFrame != null)
				{
					var tracks : Vector.<CinematicEvent> = keyFrame.getTracks();
					var length : int = tracks.length;
					for (var j : int = 0; j < length; j++)
					{
						var track : CinematicEvent = tracks[j];
						var t : Number = time - timeLine.getKeyFrameTime(keyFrame);
						if (t >= 0 && (t <= track.getInitialDuration() || track.getLoopMode() != LoopMode.DontLoop))
						{
							track.play();
						}
						track.setTime(t);
					}
				}
			}

			lastFetchedKeyFrame = keyFrameIndex;
			if (playState != PlayState.Playing)
			{
				pause();
			}
		}

		public function addTrack(timeStamp : Number, track : CinematicEvent) : KeyFrame
		{
			var keyFrame : KeyFrame = timeLine.getKeyFrameAtTime(timeStamp);
			if (keyFrame == null)
			{
				keyFrame = new KeyFrame();
				timeLine.addKeyFrameAtTime(timeStamp, keyFrame);
			}

			keyFrame.addTrack(track);
			cinematicEvents.push(track);
			return keyFrame;
		}

		public function render(rm : RenderManager) : void
		{
		}

		public function postRender() : void
		{
		}

		public function cleanup() : void
		{

		}

		public function fitDuration() : void
		{
			var kf : KeyFrame = timeLine.getKeyFrameAtTime(timeLine.getLastKeyFrameIndex());
			var d : Number = 0;
			var tracks : Vector.<CinematicEvent> = kf.getTracks();
			var length : int = tracks.length;
			for (var i : int = 0; i < length; i++)
			{
				var ck : CinematicEvent = tracks[i];
				if (d < (ck.getDuration() * ck.getSpeed()))
				{
					d = (ck.getDuration() * ck.getSpeed());
				}
			}

			initialDuration = d;
		}

		public function bindCamera(cameraName : String, cam : Camera3D) : CameraNode
		{
			var node : CameraNode = new CameraNode(cameraName, cam);
			node.controlDir = CameraControl.SpatialToCamera;
			node.getCameraControl().enabled = false;
			cameraMap[cameraName] = node;
			scene.attachChild(node);
			return node;
		}

		public function getCamera(cameraName : String) : CameraNode
		{
			return cameraMap[cameraName];
		}

		private function enableCurrentCam(enabled : Boolean) : void
		{
			if (currentCam != null)
			{
				currentCam.getControl(0).enabled = enabled;
			}
		}

		public function setActiveCamera(cameraName : String) : void
		{
			enableCurrentCam(false);
			currentCam = cameraMap[cameraName];
			enableCurrentCam(true);
		}

		public function setScene(scene : Node) : void
		{
			this.scene = scene;
		}

		public function getScene() : Node
		{
			return this.scene;
		}

		public function isInitialized() : Boolean
		{
			return this.initialized;
		}
	}
}

