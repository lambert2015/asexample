package org.angle3d.cinematic
{
	import org.angle3d.cinematic.event.MotionEvent;
	import org.angle3d.math.Spline;
	import org.angle3d.math.SplineType;
	import org.angle3d.math.Vector2f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.scene.Geometry;
	import org.angle3d.scene.Node;
	import org.angle3d.scene.WireframeGeometry;
	import org.angle3d.scene.shape.WireframeCube;
	import org.angle3d.scene.shape.WireframeCurve;
	import org.angle3d.signals.MotionPathSignal;
	import org.angle3d.utils.TempVars;

	/**
	 * Motion path is used to create a path between way points.
	 * @author Nehon
	 */
	//TODO 需要调整debug部分
	public class MotionPath
	{
		private var _spline:Spline;

		private var _debugNode:Node;

		private var prevWayPoint:int;

		/**
		 *
		 */
		private var _wayPointReach:MotionPathSignal;

		/**
		 * Create a motion Path
		 */
		public function MotionPath()
		{
			super();

			_spline = new Spline();

			_wayPointReach = new MotionPathSignal();
		}

		public function get onWayPointReach():MotionPathSignal
		{
			return _wayPointReach;
		}

		/**
		 * interpolate the path giving the time since the beginnin and the motionControl
		 * this methods sets the new localTranslation to the spatial of the motionTrack control.
		 * @param time the time since the animation started
		 * @param control the ocntrol over the moving spatial
		 */
		public function interpolatePath(time:Number, control:MotionEvent, tpf:Number):Number
		{
			var traveledDistance:Number = 0;

			var vars:TempVars = TempVars.getTempVars();
			var temp:Vector3f = vars.vect1;
			var tmpVector:Vector3f = vars.vect2;

			//computing traveled distance according to new time
			traveledDistance = time * (getLength() / control.getInitialDuration());

			//getting waypoint index and current value from new traveled distance
			var v:Vector2f = getWayPointIndexForDistance(traveledDistance);

			//setting values
			control.currentWayPoint = int(v.x);
			control.setCurrentValue(v.y);

			//interpolating new position
			_spline.interpolate(control.getCurrentValue(), control.currentWayPoint, temp);

			if (control.needsDirection())
			{
				tmpVector.copyFrom(temp);
				tmpVector.subtractLocal(control.spatial.translation);
				control.direction = tmpVector;
				control.direction.normalizeLocal();
			}

			checkWayPoint(control, tpf);

			control.spatial.translation = temp;

			vars.release();

			return traveledDistance;
		}

		public function checkWayPoint(control:MotionEvent, tpf:Number):void
		{
			//Epsilon varies with the tpf to avoid missing a waypoint on low framerate.
			var epsilon:Number = tpf * 4;
			if (control.currentWayPoint != prevWayPoint)
			{
				if (control.getCurrentValue() >= 0 && control.getCurrentValue() < epsilon)
				{
					triggerWayPointReach(control.currentWayPoint, control);
					prevWayPoint = control.currentWayPoint;
				}
			}
		}

		private function attachDebugNode(root:Node):void
		{
			if (_debugNode == null)
			{
				_debugNode = new Node("MotionPath_debug");

				var points:Vector.<Vector3f> = _spline.getControlPoints();
				var pLength:int = points.length;
				for (var i:int = 0; i < pLength; i++)
				{
					var geo:WireframeGeometry = new WireframeGeometry("sphere" + i, new WireframeCube(0.5, 0.5, 0.5));
					geo.translation = points[i];
					_debugNode.attachChild(geo);
				}

				switch (_spline.type)
				{
					case SplineType.CatmullRom:
						_debugNode.attachChild(_createCatmullRomPath());
						break;
					case SplineType.Linear:
						_debugNode.attachChild(_createLinearPath());
						break;
					default:
						_debugNode.attachChild(_createLinearPath());
						break;
				}

				root.attachChild(_debugNode);
			}
		}

		private function _createLinearPath():Geometry
		{
			var geometry:WireframeGeometry = new WireframeGeometry("LinearPath", new WireframeCurve(_spline, 0));
			geometry.materialWireframe.color = 0x0000ff;
			return geometry;
		}

		private function _createCatmullRomPath():Geometry
		{
			var geometry:WireframeGeometry = new WireframeGeometry("CatmullRomPath", new WireframeCurve(_spline, 10));
			geometry.materialWireframe.color = 0x0000ff;
			return geometry;
		}

		/**
		 * compute the index of the waypoint and the interpolation value according to a distance
		 * returns a vector 2 containing the index in the x field and the interpolation value in the y field
		 * @param distance the distance traveled on this path
		 * @return the waypoint index and the interpolation value in a vector2
		 */
		public function getWayPointIndexForDistance(distance:Number):Vector2f
		{
			var sum:Number = 0;
			distance = distance % _spline.getTotalLength();
			var list:Vector.<Number> = _spline.getSegmentsLength();
			var length:int = list.length;
			for (var i:int = 0; i < length; i++)
			{
				var len:Number = list[i];
				if (sum + len >= distance)
				{
					return new Vector2f(i, (distance - sum) / len);
				}
				sum += len;
			}
			return new Vector2f(_spline.getControlPoints().length - 1, 1.0);
		}

		/**
		 * Addsa waypoint to the path
		 * @param wayPoint a position in world space
		 */
		public function addWayPoint(wayPoint:Vector3f):void
		{
			_spline.addControlPoint(wayPoint);
		}

		/**
		 * retruns the length of the path in world units
		 * @return the length
		 */
		public function getLength():Number
		{
			return _spline.getTotalLength();
		}

		/**
		 * returns the waypoint at the given index
		 * @param i the index
		 * @return returns the waypoint position
		 */
		public function getWayPoint(i:int):Vector3f
		{
			return _spline.getControlPointAt(i);
		}

		/**
		 * remove the waypoint from the path
		 * @param wayPoint the waypoint to remove
		 */
		public function removeWayPoint(wayPoint:Vector3f):void
		{
			_spline.removeControlPoint(wayPoint);
		}

		/**
		 * remove the waypoint at the given index from the path
		 * @param i the index of the waypoint to remove
		 */
		public function removeWayPointAt(i:int):void
		{
			_spline.removeControlPoint(getWayPoint(i));
		}

		public function clearWayPoints():void
		{
			_spline.clearControlPoints();
		}

		/**
		 * return the type of spline used for the path interpolation for this path
		 * @return the path interpolation spline type
		 */
		public function get splineType():int
		{
			return _spline.type;
		}

		/**
		 * sets the type of spline used for the path interpolation for this path
		 * @param pathSplineType
		 */
		public function set splineType(type:int):void
		{
			_spline.type = type;
		}

		/**
		 * 重新生成debugNode
		 */
//		private function refreshDebugNode():void
//		{
//			if (_debugNode != null)
//			{
//				var parent:Node = _debugNode.parent;
//				_debugNode.removeFromParent();
//				_debugNode.detachAllChildren();
//				_debugNode = null;
//				attachDebugNode(parent);
//			}
//		}

		public function enableDebugShape(node:Node):void
		{
			attachDebugNode(node);
		}

		public function disableDebugShape():void
		{
			if (_debugNode != null)
			{
				var parent:Node = _debugNode.parent;
				_debugNode.removeFromParent();
				_debugNode.detachAllChildren();
				_debugNode = null;
			}
		}

		/**
		 * return the number of waypoints of this path
		 * @return
		 */
		public function get numWayPoints():int
		{
			return _spline.getControlPoints().length;
		}

		public function triggerWayPointReach(wayPointIndex:int, control:MotionEvent):void
		{
			_wayPointReach.dispatch(control, wayPointIndex);
		}

		/**
		 * Returns the curve tension
		 * @return
		 */
		public function getCurveTension():Number
		{
			return _spline.getCurveTension();
		}

		/**
		 * sets the tension of the curve (only for catmull rom) 0.0 will give a linear curve, 1.0 a round curve
		 * @param curveTension
		 */
		public function setCurveTension(curveTension:Number):void
		{
			_spline.setCurveTension(curveTension);
		}

		/**
		 * Sets the path to be a cycle
		 * @param cycle
		 */
		public function setCycle(cycle:Boolean):void
		{
			_spline.setCycle(cycle);
		}

		/**
		 * returns true if the path is a cycle
		 * @return
		 */
		public function isCycle():Boolean
		{
			return _spline.isCycle();
		}

		public function getSpline():Spline
		{
			return _spline;
		}
	}
}

