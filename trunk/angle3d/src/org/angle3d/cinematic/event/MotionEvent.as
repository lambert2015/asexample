package org.angle3d.cinematic.event
{
	import org.angle3d.app.Application;
	import org.angle3d.cinematic.Cinematic;
	import org.angle3d.cinematic.LoopMode;
	import org.angle3d.cinematic.MotionPath;
	import org.angle3d.cinematic.PlayState;
	import org.angle3d.math.Quaternion;
	import org.angle3d.math.Vector2f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.scene.Spatial;
	import org.angle3d.scene.control.Control;
	import org.angle3d.utils.TempVars;

	/**
	 * A MotionTrack is a control over the spatial that manage the position and direction of the spatial while following a motion Path
	 *
	 * You must first create a MotionPath and then create a MotionTrack to associate a spatial and the path.
	 *
	 * @author Nehon
	 */
	public class MotionEvent extends AbstractCinematicEvent implements Control
	{
		private var _spatial:Spatial;

		private var _currentWayPoint:int;
		private var currentValue:Number;

		private var _direction:Vector3f;

		private var lookAt:Vector3f;
		private var upVector:Vector3f;
		private var rotation:Quaternion;
		private var _directionType:int;
		private var path:MotionPath;
		private var isControl:Boolean;

		/**
		 * the distance traveled by the spatial on the path
		 */
		private var traveledDistance:Number;

		/**
		 *
		 * @param	spatial
		 * @param	path
		 * @param	initialDuration 时间长度，秒为单位
		 * @param	loopMode
		 */
		public function MotionEvent(spatial:Spatial, path:MotionPath, initialDuration:Number = 10, loopMode:int = 0)
		{
			super(initialDuration, loopMode);

			_direction = new Vector3f();
			_directionType = DirectionType.None;
			isControl = true;
			currentValue = 0;
			traveledDistance = 0;

			_spatial = spatial;
			_spatial.addControl(this);
			this.path = path;
		}

		public function update(tpf:Number):void
		{
			if (isControl)
			{
				internalUpdate(tpf);
			}
		}

		override public function internalUpdate(tpf:Number):void
		{
			if (playState == PlayState.Playing)
			{
				time = time + (tpf * speed);

				if (loopMode == LoopMode.Loop && time < 0)
				{
					time = initialDuration;
				}

				if ((time >= initialDuration || time < 0) && loopMode == LoopMode.DontLoop)
				{
					if (time >= initialDuration)
					{
						path.triggerWayPointReach(path.numWayPoints - 1, this);
					}
					stop();
				}
				else
				{
					onUpdate(tpf);
				}
			}
		}

		override public function init(app:Application, cinematic:Cinematic):void
		{
			super.init(app, cinematic);
			isControl = false;
		}

		override public function setTime(time:Number):void
		{
			super.setTime(time);

			//computing traveled distance according to new time
			traveledDistance = time * (path.getLength() / initialDuration);

			var vars:TempVars = TempVars.getTempVars();
			var temp:Vector3f = vars.vect1;

			//getting waypoint index and current value from new traveled distance
			var v:Vector2f = path.getWayPointIndexForDistance(traveledDistance);

			//setting values
			_currentWayPoint = int(v.x);
			setCurrentValue(v.y);

			//interpolating new position
			path.getSpline().interpolate(getCurrentValue(), _currentWayPoint, temp);
			//setting new position to the spatial
			_spatial.setTranslation(temp);

			vars.release();
		}

		override public function onUpdate(tpf:Number):void
		{
			traveledDistance = path.interpolatePath(time, this, tpf);

			computeTargetDirection();

			if (currentValue >= 1.0)
			{
				currentValue = 0;
				_currentWayPoint++;
				path.triggerWayPointReach(_currentWayPoint, this);
			}

			if (_currentWayPoint == path.numWayPoints - 1)
			{
				if (loopMode == LoopMode.Loop)
				{
					_currentWayPoint = 0;
				}
				else
				{
					stop();
				}
			}
		}

		/**
		 * this method is meant to be called by the motion path only
		 * @return
		 */
		public function needsDirection():Boolean
		{
			return _directionType == DirectionType.Path || _directionType == DirectionType.PathAndRotation;
		}

		private function computeTargetDirection():void
		{
			switch (_directionType)
			{
				case DirectionType.Path:
					var q:Quaternion = new Quaternion();
					q.lookAt(_direction, Vector3f.Y_AXIS);
					_spatial.setRotation(q);
					break;
				case DirectionType.LookAt:
					if (lookAt != null)
					{
						_spatial.lookAt(lookAt, upVector);
					}
					break;
				case DirectionType.PathAndRotation:
					if (rotation != null)
					{
						var q2:Quaternion = new Quaternion();
						q2.lookAt(_direction, Vector3f.Y_AXIS);
						q2.multiplyLocal(rotation);
						_spatial.setRotation(q2);
					}
					break;
				case DirectionType.Rotation:
					if (rotation != null)
					{
						_spatial.setRotation(rotation);
					}
					break;
				case DirectionType.None:
					//do nothing
					break;
			}
		}

		/**
		 * Clone this control for the given spatial
		 * @param spatial
		 * @return
		 */
		public function cloneForSpatial(spatial:Spatial):Control
		{
			var control:MotionEvent = new MotionEvent(spatial, path);
			control.playState = playState;
			control._currentWayPoint = _currentWayPoint;
			control.currentValue = currentValue;
			control._direction = _direction.clone();
			control.lookAt = lookAt.clone();
			control.upVector = upVector.clone();
			control.rotation = rotation.clone();
			control.duration = duration;
			control.initialDuration = initialDuration;
			control.speed = speed;
			control.duration = duration;
			control.loopMode = loopMode;
			control._directionType = _directionType;

			return control;
		}

		override public function onStop():void
		{
			_currentWayPoint = 0;
		}

		/**
		 * this method is meant to be called by the motion path only
		 * @return
		 */
		public function getCurrentValue():Number
		{
			return currentValue;
		}

		/**
		 * this method is meant to be called by the motion path only
		 *
		 */
		public function setCurrentValue(currentValue:Number):void
		{
			this.currentValue = currentValue;
		}

		/**
		 * this method is meant to be called by the motion path only
		 * @return
		 */
		public function get currentWayPoint():int
		{
			return _currentWayPoint;
		}

		/**
		 * this method is meant to be called by the motion path only
		 *
		 */
		public function set currentWayPoint(currentWayPoint:int):void
		{
			_currentWayPoint = currentWayPoint;
		}

		/**
		 * returns the direction the spatial is moving
		 * @return
		 */
		public function get direction():Vector3f
		{
			return _direction;
		}

		/**
		 * Sets the direction of the spatial
		 * This method is used by the motion path.
		 * @param direction
		 */
		public function set direction(vec:Vector3f):void
		{
			_direction.copyFrom(vec);
		}

		/**
		 * returns the direction type of the target
		 * @return the direction type
		 */
		public function get directionType():int
		{
			return _directionType;
		}

		/**
		 * Sets the direction type of the target
		 * On each update the direction given to the target can have different behavior
		 * See the Direction Enum for explanations
		 * @param directionType the direction type
		 */
		public function set directionType(value:int):void
		{
			_directionType = value;
		}

		/**
		 * Set the lookAt for the target
		 * This can be used only if direction Type is Direction.LookAt
		 * @param lookAt the position to look at
		 * @param upVector the up vector
		 */
		public function setLookAt(lookAt:Vector3f, upVector:Vector3f):void
		{
			this.lookAt = lookAt;
			this.upVector = upVector;
		}

		/**
		 * returns the rotation of the target
		 * @return the rotation quaternion
		 */
		public function getRotation():Quaternion
		{
			return rotation;
		}

		/**
		 * sets the rotation of the target
		 * This can be used only if direction Type is Direction.PathAndRotation or Direction.Rotation
		 * With PathAndRotation the target will face the direction of the path multiplied by the given Quaternion.
		 * With Rotation the rotation of the target will be set with the given Quaternion.
		 * @param rotation the rotation quaternion
		 */
		public function setRotation(rotation:Quaternion):void
		{
			this.rotation = rotation;
		}

		/**
		 * retun the motion path this control follows
		 * @return
		 */
		public function getPath():MotionPath
		{
			return path;
		}

		/**
		 * Sets the motion path to follow
		 * @param path
		 */
		public function setPath(path:MotionPath):void
		{
			this.path = path;
		}

		public function set enabled(enabled:Boolean):void
		{
			if (enabled)
			{
				play();
			}
			else
			{
				pause();
			}
		}

		public function get enabled():Boolean
		{
			return playState != PlayState.Stopped;
		}

		public function render(rm:RenderManager, vp:ViewPort):void
		{
		}

		public function set spatial(spatial:Spatial):void
		{
			this._spatial = spatial;
		}

		public function get spatial():Spatial
		{
			return _spatial;
		}

		/**
		 * return the distance traveled by the spatial on the path
		 * @return
		 */
		public function getTraveledDistance():Number
		{
			return traveledDistance;
		}
	}
}

