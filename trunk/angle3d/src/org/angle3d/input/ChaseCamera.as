package org.angle3d.input
{
	import org.angle3d.math.Vector3f;

	import org.angle3d.input.controls.ActionListener;
	import org.angle3d.input.controls.AnalogListener;
	import org.angle3d.input.controls.MouseAxisTrigger;
	import org.angle3d.input.controls.MouseButtonTrigger;
	import org.angle3d.input.controls.Trigger;
	import org.angle3d.math.FastMath;
	import org.angle3d.renderer.Camera3D;
	import org.angle3d.renderer.RenderManager;
	import org.angle3d.renderer.ViewPort;
	import org.angle3d.scene.control.Control;
	import org.angle3d.scene.Spatial;

	/**
	 * A camera that follows a spatial and can turn around it by dragging the mouse
	 * @author nehon
	 */
	public class ChaseCamera implements ActionListener, AnalogListener, Control
	{
		private var target:Spatial;
		private var minVerticalRotation:Number;
		private var maxVerticalRotation:Number;
		private var minDistance:Number;
		private var maxDistance:Number;
		private var distance:Number;
		private var zoomSpeed:Number;
		private var rotationSpeed:Number;
		private var rotation:Number;
		private var trailingRotationInertia:Number;
		private var zoomSensitivity:Number;
		private var rotationSensitivity:Number;
		private var chasingSensitivity:Number;
		private var trailingSensitivity:Number;
		private var vRotation:Number;
		private var smoothMotion:Boolean;
		private var trailingEnabled:Boolean;
		private var rotationLerpFactor:Number;
		private var trailingLerpFactor:Number;
		private var rotating:Boolean;
		private var vRotating:Boolean;
		private var targetRotation:Number;
		private var inputManager:InputManager;
		private var initialUpVec:Vector3f;
		private var targetVRotation:Number;
		private var vRotationLerpFactor:Number;
		private var targetDistance:Number;
		private var distanceLerpFactor:Number;
		private var zooming:Boolean;
		private var trailing:Boolean;
		private var chasing:Boolean;
		private var canRotate:Boolean;
		private var offsetDistance:Number;
		private var prevPos:Vector3f;
		private var targetMoves:Boolean;
		private var _enabled:Boolean;
		private var cam:Camera3D;
		private var targetDir:Vector3f;
		private var previousTargetRotation:Number;
		private var pos:Vector3f;
		private var targetLocation:Vector3f;
		private var dragToRotate:Boolean;
		private var lookAtOffset:Vector3f;
		private var leftClickRotate:Boolean;
		private var temp:Vector3f;
		private var invertYaxis:Boolean;
		private var invertXaxis:Boolean;
		private static var ChaseCamDown:String = "ChaseCamDown";
		private static var ChaseCamUp:String = "ChaseCamUp";
		private static var ChaseCamZoomIn:String = "ChaseCamZoomIn";
		private static var ChaseCamZoomOut:String = "ChaseCamZoomOut";
		private static var ChaseCamMoveLeft:String = "ChaseCamMoveLeft";
		private static var ChaseCamMoveRight:String = "ChaseCamMoveRight";
		private static var ChaseCamToggleRotate:String = "ChaseCamToggleRotate";

		/**
		 * Constructs the chase camera, and registers inputs
		 * @param cam the application camera
		 * @param target the spatial to follow
		 * @param inputManager the inputManager of the application to register inputs
		 */
		public function ChaseCamera(cam:Camera3D, target:Spatial, inputManager:InputManager)
		{
			_init();

			this.cam = cam;
			initialUpVec = cam.getUp().clone();

			this.target = target;
			this.target.addControl(this);

			registerWithInput(inputManager);
		}

		private function _init():void
		{
			minVerticalRotation = 0.00;
			maxVerticalRotation = FastMath.PI / 2;

			minDistance = 1.0;
			maxDistance = 40.0;
			distance = 20;

			zoomSpeed = 2;
			rotationSpeed = 1.0;

			rotation = 0;
			trailingRotationInertia = 0.05;

			zoomSensitivity = 5;
			rotationSensitivity = 5;
			chasingSensitivity = 5;
			trailingSensitivity = 0.5;
			vRotation = FastMath.PI / 6;
			smoothMotion = false;
			trailingEnabled = true;

			rotationLerpFactor = 0;
			trailingLerpFactor = 0;

			rotating = false;
			vRotating = false;
			targetRotation = rotation;

			targetVRotation = vRotation;
			vRotationLerpFactor = 0;
			targetDistance = distance;
			distanceLerpFactor = 0;

			zooming = false;
			trailing = false;
			chasing = false;

			offsetDistance = 0.002;

			targetMoves = false;
			_enabled = true;

			cam = null;

			targetDir = new Vector3f();
			pos = new Vector3f();
			targetLocation = new Vector3f(0, 0, 0);
			dragToRotate = false;
			lookAtOffset = new Vector3f(0, 0, 0);
			leftClickRotate = true;
			temp = new Vector3f(0, 0, 0);

			invertYaxis = false;
			invertXaxis = false;
		}

		private var zoomin:Boolean;

		public function onAnalog(name:String, value:Number, tpf:Number):void
		{
			switch (name)
			{
				case ChaseCamMoveLeft:
					rotateCamera(-value);
					break;
				case ChaseCamMoveRight:
					rotateCamera(value);
					break;
				case ChaseCamUp:
					vRotateCamera(value);
					break;
				case ChaseCamDown:
					vRotateCamera(-value);
					break;
				case ChaseCamZoomIn:
					zoomCamera(-value);
					if (zoomin == false)
					{
						distanceLerpFactor = 0;
					}
					zoomin = true;
					break;
				case ChaseCamZoomOut:
					zoomCamera(value);
					if (zoomin)
					{
						distanceLerpFactor = 0;
					}
					zoomin = false;
					break;
			}
		}

		public function onAction(name:String, keyPressed:Boolean, tpf:Number):void
		{
			if (dragToRotate)
			{
				if (name == ChaseCamToggleRotate && _enabled)
				{
					if (keyPressed)
					{
						canRotate = true;
							//inputManager.setCursorVisible(false);
					}
					else
					{
						canRotate = false;
							//inputManager.setCursorVisible(true);
					}
				}
			}
		}

		/**
		 * Registers the FlyByCamera to receive input events from the provided
		 * Dispatcher.
		 * @param dispacher
		 */
		public function registerWithInput(inputManager:InputManager):void
		{
			this.inputManager = inputManager;

			var inputs:Array = [ChaseCamToggleRotate,
				ChaseCamDown,
				ChaseCamUp,
				ChaseCamMoveLeft,
				ChaseCamMoveRight,
				ChaseCamZoomIn,
				ChaseCamZoomOut];

			inputManager.addSingleMapping(ChaseCamDown, new MouseAxisTrigger(MouseInput.AXIS_Y, !invertYaxis));
			inputManager.addSingleMapping(ChaseCamUp, new MouseAxisTrigger(MouseInput.AXIS_Y, invertYaxis));

			inputManager.addSingleMapping(ChaseCamZoomIn, new MouseAxisTrigger(MouseInput.AXIS_WHEEL, false));
			inputManager.addSingleMapping(ChaseCamZoomOut, new MouseAxisTrigger(MouseInput.AXIS_WHEEL, true));

			inputManager.addSingleMapping(ChaseCamMoveLeft, new MouseAxisTrigger(MouseInput.AXIS_X, !invertXaxis));
			inputManager.addSingleMapping(ChaseCamMoveRight, new MouseAxisTrigger(MouseInput.AXIS_X, invertXaxis));

			inputManager.addSingleMapping(ChaseCamToggleRotate, new MouseButtonTrigger(MouseInput.BUTTON_LEFT));

			inputManager.addListener(this, inputs);
		}

		/**
		 * Sets custom triggers for toggleing the rotation of the cam
		 * deafult are
		 * new MouseButtonTrigger(MouseInput.BUTTON_LEFT)  left mouse button
		 * new MouseButtonTrigger(MouseInput.BUTTON_RIGHT)  right mouse button
		 * @param triggers
		 */
		public function setToggleRotationTrigger(triggers:Vector.<Trigger>):void
		{
			inputManager.deleteMapping(ChaseCamToggleRotate);
			inputManager.addMapping(ChaseCamToggleRotate, triggers);
			var inputs:Array = [];
			inputs.push(ChaseCamToggleRotate);
			inputManager.addListener(this, inputs);
		}

		/**
		 * Sets custom triggers for zomming in the cam
		 * default is
		 * new MouseAxisTrigger(MouseInput.AXIS_WHEEL, true)  mouse wheel up
		 * @param triggers
		 */
		public function setZoomInTrigger(triggers:Vector.<Trigger>):void
		{
			inputManager.deleteMapping(ChaseCamZoomIn);
			inputManager.addMapping(ChaseCamZoomIn, triggers);
			var inputs:Array = [];
			inputs.push(ChaseCamZoomIn);
			inputManager.addListener(this, inputs);
		}

		/**
		 * Sets custom triggers for zomming out the cam
		 * default is
		 * new MouseAxisTrigger(MouseInput.AXIS_WHEEL, false)  mouse wheel down
		 * @param triggers
		 */
		public function setZoomOutTrigger(triggers:Vector.<Trigger>):void
		{
			inputManager.deleteMapping(ChaseCamZoomOut);
			inputManager.addMapping(ChaseCamZoomOut, triggers);

			var inputs:Array = [];
			inputs.push(ChaseCamZoomOut);
			inputManager.addListener(this, inputs);
		}

		private function computePosition():void
		{
			var hDistance:Number = (distance) * Math.sin((FastMath.PI / 2) - vRotation);
			pos.setTo(hDistance * Math.cos(rotation),
				(distance) * Math.sin(vRotation),
				hDistance * Math.sin(rotation));
			pos.addLocal(target.getWorldTranslation());
		}

		//rotate the camera around the target on the horizontal plane
		private function rotateCamera(value:Number):void
		{
			if (!canRotate || !_enabled)
			{
				return;
			}

			rotating = true;
			targetRotation += value * rotationSpeed;
		}

		//move the camera toward or away the target
		private function zoomCamera(value:Number):void
		{
			if (!_enabled)
			{
				return;
			}

			zooming = true;
			targetDistance += value * zoomSpeed;
			targetDistance = FastMath.fclamp(targetDistance, minDistance, maxDistance);

			if ((targetVRotation < minVerticalRotation) && (targetDistance > (minDistance + 1.0)))
			{
				targetVRotation = minVerticalRotation;
			}
		}

		//rotate the camera around the target on the vertical plane
		private function vRotateCamera(value:Number):void
		{
			if (!canRotate || !_enabled)
			{
				return;
			}

			vRotating = true;
			targetVRotation += value * rotationSpeed;
			if (targetVRotation > maxVerticalRotation)
			{
				targetVRotation = maxVerticalRotation;
			}

			if ((targetVRotation < minVerticalRotation) && (targetDistance > (minDistance + 1.0)))
			{
				targetVRotation = minVerticalRotation;
			}
		}

		/**
		 * Updates the camera, should only be called internally
		 */
		private function updateCamera(tpf:Number):void
		{
			if (_enabled)
			{
				targetLocation.copyFrom(target.getWorldTranslation());
				targetLocation.addLocal(lookAtOffset);
				if (smoothMotion)
				{
					//computation of target direction
					targetDir.copyFrom(targetLocation);
					targetDir.subtractLocal(prevPos);

					var dist:Number = targetDir.length;

					//Low pass filtering on the target postition to avoid shaking when physics are enabled.
					if (offsetDistance < dist)
					{
						//target moves, start chasing.
						chasing = true;
						//target moves, start trailing if it has to.
						if (trailingEnabled)
						{
							trailing = true;
						}
						//target moves...
						targetMoves = true;
					}
					else
					{
						//if target was moving, we compute a slight offset in rotation to avoid a rought stop of the cam
						//We do not if the player is rotationg the cam
						if (targetMoves && !canRotate)
						{
							targetRotation = rotation + FastMath.fclamp(targetRotation - rotation,
								-trailingRotationInertia,
								trailingRotationInertia);
						}
						//Target stops
						targetMoves = false;
					}

					//the user is rotating the cam by dragging the mouse
					if (canRotate)
					{
						//reseting the trailing lerp factor
						trailingLerpFactor = 0;
						//stop trailing user has the control                  
						trailing = false;
					}


					if (trailingEnabled && trailing)
					{
						if (targetMoves)
						{
							//computation if the inverted direction of the target
							var a:Vector3f = targetDir.clone();
							a.negate();
							a.normalizeLocal();
							//the x unit vector
							var b:Vector3f = Vector3f.X_AXIS;
							//2d is good enough
							a.y = 0;
							//computation of the rotation angle between the x axis and the trail
							if (targetDir.z > 0)
							{
								targetRotation = FastMath.TWO_PI - Math.acos(a.dot(b));
							}
							else
							{
								targetRotation = Math.acos(a.dot(b));
							}
							if (targetRotation - rotation > FastMath.PI || targetRotation - rotation < -FastMath.PI)
							{
								targetRotation -= FastMath.TWO_PI;
							}

							//if there is an important change in the direction while trailing reset of the lerp factor to avoid jumpy movements
							if (targetRotation != previousTargetRotation && FastMath.fabs(targetRotation - previousTargetRotation) > FastMath.PI / 8)
							{
								trailingLerpFactor = 0;
							}
							previousTargetRotation = targetRotation;
						}
						//computing lerp factor
						trailingLerpFactor = Math.min(trailingLerpFactor + tpf * tpf * trailingSensitivity, 1);
						//computing rotation by linear interpolation
						rotation = FastMath.lerp(rotation, targetRotation, trailingLerpFactor);

						//if the rotation is near the target rotation we're good, that's over
						if (FastMath.nearEqual(targetRotation, rotation, 0.01))
						{
							trailing = false;
							trailingLerpFactor = 0;
						}
					}

					//linear interpolation of the distance while chasing
					if (chasing)
					{
						temp.copyFrom(targetLocation);
						temp.subtractLocal(cam.location);
						distance = temp.length;
						distanceLerpFactor = Math.min(distanceLerpFactor + (tpf * tpf * chasingSensitivity * 0.05), 1);
						distance = FastMath.lerp(distance, targetDistance, distanceLerpFactor);
						if (FastMath.nearEqual(targetDistance, distance, 0.01))
						{
							distanceLerpFactor = 0;
							chasing = false;
						}
					}

					//linear interpolation of the distance while zooming
					if (zooming)
					{
						distanceLerpFactor = Math.min(distanceLerpFactor + (tpf * tpf * zoomSensitivity), 1);
						distance = FastMath.lerp(distance, targetDistance, distanceLerpFactor);
						if (FastMath.nearEqual(targetDistance, distance, 0.1))
						{
							zooming = false;
							distanceLerpFactor = 0;
						}
					}

					//linear interpolation of the rotation while rotating horizontally
					if (rotating)
					{
						rotationLerpFactor = Math.min(rotationLerpFactor + tpf * tpf * rotationSensitivity, 1);
						rotation = FastMath.lerp(rotation, targetRotation, rotationLerpFactor);
						if (FastMath.nearEqual(targetRotation, rotation, 0.01))
						{
							rotating = false;
							rotationLerpFactor = 0;
						}
					}

					//linear interpolation of the rotation while rotating vertically
					if (vRotating)
					{
						vRotationLerpFactor = Math.min(vRotationLerpFactor + tpf * tpf * rotationSensitivity, 1);
						vRotation = FastMath.lerp(vRotation, targetVRotation, vRotationLerpFactor);
						if (FastMath.nearEqual(targetVRotation, vRotation, 0.01))
						{
							vRotating = false;
							vRotationLerpFactor = 0;
						}
					}
					//computing the position
					computePosition();
					//setting the position at last
					pos.addLocal(lookAtOffset);
					cam.location = pos;
				}
				else
				{
					//easy no smooth motion
					vRotation = targetVRotation;
					rotation = targetRotation;
					distance = targetDistance;
					computePosition();
					pos.addLocal(lookAtOffset);
					cam.location = pos;
				}
				//keeping track on the previous position of the target
				prevPos.copyFrom(targetLocation);

				//the cam looks at the target            
				cam.lookAt(targetLocation, initialUpVec);
			}
		}

		/**
		 * Return the enabled/disabled state of the camera
		 * @return true if the camera is enabled
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}

		/**
		 * Enable or disable the camera
		 * @param enabled true to enable
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if (!_enabled)
			{
				canRotate = false; // reset this flag in-case it was on before
			}
		}

		/**
		 * Returns the max zoom distance of the camera (default is 40)
		 * @return maxDistance
		 */
		public function getMaxDistance():Number
		{
			return maxDistance;
		}

		/**
		 * Sets the max zoom distance of the camera (default is 40)
		 * @param maxDistance
		 */
		public function setMaxDistance(maxDistance:Number):void
		{
			this.maxDistance = maxDistance;
			if (maxDistance < distance)
			{
				zoomCamera(maxDistance - distance);
			}
		}

		/**
		 * Returns the min zoom distance of the camera (default is 1)
		 * @return minDistance
		 */
		public function getMinDistance():Number
		{
			return minDistance;
		}

		/**
		 * Sets the min zoom distance of the camera (default is 1)
		 * @return minDistance
		 */
		public function setMinDistance(minDistance:Number):void
		{
			this.minDistance = minDistance;
			if (minDistance > distance)
			{
				zoomCamera(distance - minDistance);
			}
		}

		/**
		 * clone this camera for a spatial
		 * @param spatial
		 * @return
		 */
		public function cloneForSpatial(spatial:Spatial):Control
		{
			var cc:ChaseCamera = new ChaseCamera(cam, spatial, inputManager);
			cc.setMaxDistance(getMaxDistance());
			cc.setMinDistance(getMinDistance());
			return cc;
		}

		/**
		 * Sets the spacial for the camera control, should only be used internally
		 * @param spatial
		 */
		public function set spatial(value:Spatial):void
		{
			this.target = value;
			if (spatial == null)
			{
				return;
			}

			computePosition();
			prevPos = target.getWorldTranslation().clone();
			cam.location = pos;
		}

		public function get spatial():Spatial
		{
			return this.target;
		}

		/**
		 * update the camera control, should only be used internally
		 * @param tpf
		 */
		public function update(tpf:Number):void
		{
			updateCamera(tpf);
		}

		/**
		 * renders the camera control, should only be used internally
		 * @param rm
		 * @param vp
		 */
		public function render(rm:RenderManager, vp:ViewPort):void
		{
			//nothing to render
		}

		/**
		 * returns the maximal vertical rotation angle of the camera around the target
		 * @return
		 */
		public function getMaxVerticalRotation():Number
		{
			return maxVerticalRotation;
		}

		/**
		 * sets the maximal vertical rotation angle of the camera around the target default is Pi/2;
		 * @param maxVerticalRotation
		 */
		public function setMaxVerticalRotation(maxVerticalRotation:Number):void
		{
			this.maxVerticalRotation = maxVerticalRotation;
		}

		/**
		 * returns the minimal vertical rotation angle of the camera around the target
		 * @return
		 */
		public function getMinVerticalRotation():Number
		{
			return minVerticalRotation;
		}

		/**
		 * sets the minimal vertical rotation angle of the camera around the target default is 0;
		 * @param minHeight
		 */
		public function setMinVerticalRotation(minHeight:Number):void
		{
			this.minVerticalRotation = minHeight;
		}

		/**
		 * returns true is smmoth motion is enabled for this chase camera
		 * @return
		 */
		public function isSmoothMotion():Boolean
		{
			return smoothMotion;
		}

		/**
		 * Enables smooth motion for this chase camera
		 * @param smoothMotion
		 */
		public function setSmoothMotion(smoothMotion:Boolean):void
		{
			this.smoothMotion = smoothMotion;
		}

		/**
		 * returns the chasing sensitivity
		 * @return
		 */
		public function getChasingSensitivity():Number
		{
			return chasingSensitivity;
		}

		/**
		 *
		 * Sets the chasing sensitivity, the lower the value the slower the camera will follow the target when it moves
		 * default is 5
		 * Only has an effect if smoothMotion is set to true and trailing is enabled
		 * @param chasingSensitivity
		 */
		public function setChasingSensitivity(chasingSensitivity:Number):void
		{
			this.chasingSensitivity = chasingSensitivity;
		}

		/**
		 * Returns the rotation sensitivity
		 * @return
		 */
		public function getRotationSensitivity():Number
		{
			return rotationSensitivity;
		}

		/**
		 * Sets the rotation sensitivity, the lower the value the slower the camera will rotates around the target when draging with the mouse
		 * default is 5, values over 5 should have no effect.
		 * If you want a significant slow down try values below 1.
		 * Only has an effect if smoothMotion is set to true
		 * @param rotationSensitivity
		 */
		public function setRotationSensitivity(rotationSensitivity:Number):void
		{
			this.rotationSensitivity = rotationSensitivity;
		}

		/**
		 * returns true if the trailing is enabled
		 * @return
		 */
		public function isTrailingEnabled():Boolean
		{
			return trailingEnabled;
		}

		/**
		 * Enable the camera trailing : The camera smoothly go in the targets trail when it moves.
		 * Only has an effect if smoothMotion is set to true
		 * @param trailingEnabled
		 */
		public function setTrailingEnabled(trailingEnabled:Boolean):void
		{
			this.trailingEnabled = trailingEnabled;
		}

		/**
		 *
		 * returns the trailing rotation inertia
		 * @return
		 */
		public function getTrailingRotationInertia():Number
		{
			return trailingRotationInertia;
		}

		/**
		 * Sets the trailing rotation inertia : default is 0.1. This prevent the camera to roughtly stop when the target stops moving
		 * before the camera reached the trail position.
		 * Only has an effect if smoothMotion is set to true and trailing is enabled
		 * @param trailingRotationInertia
		 */
		public function setTrailingRotationInertia(trailingRotationInertia:Number):void
		{
			this.trailingRotationInertia = trailingRotationInertia;
		}

		/**
		 * returns the trailing sensitivity
		 * @return
		 */
		public function getTrailingSensitivity():Number
		{
			return trailingSensitivity;
		}

		/**
		 * Only has an effect if smoothMotion is set to true and trailing is enabled
		 * Sets the trailing sensitivity, the lower the value, the slower the camera will go in the target trail when it moves.
		 * default is 0.5;
		 * @param trailingSensitivity
		 */
		public function setTrailingSensitivity(trailingSensitivity:Number):void
		{
			this.trailingSensitivity = trailingSensitivity;
		}

		/**
		 * returns the zoom sensitivity
		 * @return
		 */
		public function getZoomSensitivity():Number
		{
			return zoomSensitivity;
		}

		/**
		 * Sets the zoom sensitivity, the lower the value, the slower the camera will zoom in and out.
		 * default is 5.
		 * @param zoomSensitivity
		 */
		public function setZoomSensitivity(zoomSensitivity:Number):void
		{
			this.zoomSensitivity = zoomSensitivity;
		}

		/**
		 * Sets the default distance at start of applicaiton
		 * @param defaultDistance
		 */
		public function setDefaultDistance(defaultDistance:Number):void
		{
			distance = defaultDistance;
			targetDistance = distance;
		}

		/**
		 * sets the default horizontal rotation of the camera at start of the application
		 * @param angle
		 */
		public function setDefaultHorizontalRotation(angle:Number):void
		{
			rotation = angle;
			targetRotation = angle;
		}

		/**
		 * sets the default vertical rotation of the camera at start of the application
		 * @param angle
		 */
		public function setDefaultVerticalRotation(angle:Number):void
		{
			vRotation = angle;
			targetVRotation = angle;
		}

		/**
		 * @return If drag to rotate feature is enabled.
		 *
		 * @see FlyByCamera#setDragToRotate(boolean)
		 */
		public function isDragToRotate():Boolean
		{
			return dragToRotate;
		}

		/**
		 * @param dragToRotate When true, the user must hold the mouse button
		 * and drag over the screen to rotate the camera, and the cursor is
		 * visible until dragged. Otherwise, the cursor is invisible at all times
		 * and holding the mouse button is not needed to rotate the camera.
		 * This feature is disabled by default.
		 */
		public function setDragToRotate(dragToRotate:Boolean):void
		{
			this.dragToRotate = dragToRotate;
			this.canRotate = !dragToRotate;
			//inputManager.setCursorVisible(dragToRotate);
		}

		/**
		 * return the current distance from the camera to the target
		 * @return
		 */
		public function getDistanceToTarget():Number
		{
			return distance;
		}

		/**
		 * returns the current horizontal rotation around the target in radians
		 * @return
		 */
		public function getHorizontalRotation():Number
		{
			return rotation;
		}

		/**
		 * returns the current vertical rotation around the target in radians.
		 * @return
		 */
		public function getVerticalRotation():Number
		{
			return vRotation;
		}

		/**
		 * returns the offset from the target's position where the camera looks at
		 * @return
		 */
		public function getLookAtOffset():Vector3f
		{
			return lookAtOffset;
		}

		/**
		 * Sets the offset from the target's position where the camera looks at
		 * @param lookAtOffset
		 */
		public function setLookAtOffset(lookAtOffset:Vector3f):void
		{
			this.lookAtOffset = lookAtOffset;
		}

		/**
		 * Sets the up vector of the camera used for the lookAt on the target
		 * @param up
		 */
		public function setUpVector(up:Vector3f):void
		{
			initialUpVec = up;
		}

		/**
		 * Returns the up vector of the camera used for the lookAt on the target
		 * @return
		 */
		public function getUpVector():Vector3f
		{
			return initialUpVec;
		}

		/**
		 * invert the vertical axis movement of the mouse
		 * @param invertYaxis
		 */
		public function setInvertVerticalAxis(invertYaxis:Boolean):void
		{
			this.invertYaxis = invertYaxis;

			inputManager.deleteMapping(ChaseCamDown);
			inputManager.deleteMapping(ChaseCamUp);

			inputManager.addSingleMapping(ChaseCamDown, new MouseAxisTrigger(MouseInput.AXIS_Y, !invertYaxis));
			inputManager.addSingleMapping(ChaseCamUp, new MouseAxisTrigger(MouseInput.AXIS_Y, invertYaxis));

			var inputs:Array = [];
			inputs.push(ChaseCamDown);
			inputs.push(ChaseCamUp);
			inputManager.addListener(this, inputs);
		}

		/**
		 * invert the Horizontal axis movement of the mouse
		 * @param invertYaxis
		 */
		public function setInvertHorizontalAxis(invertXaxis:Boolean):void
		{
			this.invertXaxis = invertXaxis;
			inputManager.deleteMapping(ChaseCamMoveLeft);
			inputManager.deleteMapping(ChaseCamMoveRight);

			inputManager.addSingleMapping(ChaseCamMoveLeft, new MouseAxisTrigger(MouseInput.AXIS_X, !invertXaxis));
			inputManager.addSingleMapping(ChaseCamMoveRight, new MouseAxisTrigger(MouseInput.AXIS_X, invertXaxis));

			var inputs:Array = [];
			inputs.push(ChaseCamMoveLeft);
			inputs.push(ChaseCamMoveRight);
			inputManager.addListener(this, inputs);
		}
	}
}

