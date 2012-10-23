package org.angle3d.math
{
	import org.angle3d.math.Vector3f;
	import org.angle3d.utils.Assert;

	public class Spline
	{
		private var controlPoints:Vector.<Vector3f>;
		private var knots:Vector.<Number>; //knots of NURBS spline
		private var weights:Vector.<Number>; //weights of NURBS spline
		private var basisFunctionDegree:int; //degree of NURBS spline basis function (computed automatically)
		private var cycle:Boolean;
		private var segmentsLength:Vector.<Number>;
		private var totalLength:Number;
		private var CRcontrolPoints:Vector.<Vector3f>;
		private var curveTension:Number;
		private var _type:int;

		public function Spline()
		{
			controlPoints = new Vector.<Vector3f>();
			curveTension = 0.5;
			_type = SplineType.CatmullRom;
		}

		/**
		 * Create a spline
		 * @param splineType the type of the spline @see {SplineType}
		 * @param controlPoints a list of vector to use as control points of the spline
		 * If the type of the curve is Bezier curve the control points should be provided
		 * in the appropriate way. Each point 'p' describing control position in the scene
		 * should be surrounded by two handler points. This applies to every point except
		 * for the border points of the curve, who should have only one handle point.
		 * The pattern should be as follows:
		 * P0 - H0  :  H1 - P1 - H1  :  ...  :  Hn - Pn
		 *
		 * n is the amount of 'P' - points.
		 * @param curveTension the tension of the spline
		 * @param cycle true if the spline cycle.
		 */
		public function createNormal(splineType:int, controlPoints:Vector.<Vector3f>, curveTension:Number = 0.5, cycle:Boolean = false):void
		{
			Assert.assert(splineType != SplineType.Nurb, "To create NURBS spline use createNURBS");

			this._type = splineType;
			this.controlPoints.concat(controlPoints);
			this.curveTension = curveTension;
			this.cycle = cycle;

			this.computeTotalLength();
		}

		/**
		 * Create a NURBS spline. A spline type is automatically set to SplineType.Nurb.
		 * The cycle is set to <b>false</b> by default.
		 * @param controlPoints a list of vector to use as control points of the spline
		 * @param nurbKnots the nurb's spline knots
		 */
		public function createNURBS(controlPoints:Vector.<Vector4f>, nurbKnots:Vector.<Number>):void
		{
			//input data control
			var length:int = (nurbKnots.length - 1);
			for (var i:int = 0; i < length; i++)
			{
				Assert.assert(nurbKnots[i] <= nurbKnots[i + 1], "The knots values cannot decrease!");
			}

			//storing the data
			_type = SplineType.Nurb;
			this.weights = new Vector.<Number>(controlPoints.length);
			this.knots = nurbKnots;
			this.basisFunctionDegree = nurbKnots.length - weights.length;
			for (i = 0; i < controlPoints.length; i++)
			{
				var cp:Vector4f = controlPoints[i];
				var v3:Vector3f = new Vector3f();
				v3.x = cp.x;
				v3.y = cp.y;
				v3.z = cp.z;
				this.controlPoints.push(v3);
				this.weights[i] = cp.w;
			}
			CurveAndSurfaceMath.prepareNurbsKnots(knots, basisFunctionDegree);
			this.computeTotalLength();
		}

		private function initCatmullRomWayPoints(list:Vector.<Vector3f>):void
		{
			if (CRcontrolPoints == null)
			{
				CRcontrolPoints = new Vector.<Vector3f>();
			}
			else
			{
				CRcontrolPoints.length = 0;
			}

			var nb:int = list.length - 1;
			if (cycle)
			{
				CRcontrolPoints.push(list[list.length - 2]);
			}
			else
			{
				CRcontrolPoints.push(list[0].subtract(list[1].subtract(list[0])));
			}

			for (var i:int = 0; i < list.length; i++)
			{
				CRcontrolPoints.push(list[i]);
			}

			if (cycle)
			{
				CRcontrolPoints.push(list[1]);
			}
			else
			{
				CRcontrolPoints.push(list[nb].add(list[nb].subtract(list[nb - 1])));
			}
		}

		/**
		 * Adds a controlPoint to the spline
		 * @param controlPoint a position in world space
		 */
		public function addControlPoint(controlPoint:Vector3f):void
		{
			if (controlPoints.length > 2 && this.cycle)
			{
				controlPoints.splice(controlPoints.length - 1, 1);
			}

			controlPoints.push(controlPoint.clone());

			if (controlPoints.length > 2 && this.cycle)
			{
				controlPoints.push(controlPoints[0].clone());
			}

			if (controlPoints.length > 1)
			{
				this.computeTotalLength();
			}
		}

		/**
		 * remove the controlPoint from the spline
		 * @param controlPoint the controlPoint to remove
		 */
		public function removeControlPoint(controlPoint:Vector3f):void
		{
			var index:int = controlPoints.indexOf(controlPoint);
			if (index > -1)
			{
				controlPoints.splice(index, 1);
			}
			if (controlPoints.length > 1)
			{
				this.computeTotalLength();
			}
		}

		public function clearControlPoints():void
		{
			controlPoints.length = 0;
			totalLength = 0;
		}

		/**
		 * This method computes the total length of the curve.
		 */
		private function computeTotalLength():void
		{
			totalLength = 0;

			var l:Number = 0;
			if (segmentsLength == null)
			{
				segmentsLength = new Vector.<Number>();
			}
			else
			{
				segmentsLength.length = 0;
			}

			if (_type == SplineType.Linear)
			{
				var cLength:int = (controlPoints.length - 1);
				for (var i:int = 0; i < cLength; i++)
				{
					l = controlPoints[i + 1].subtract(controlPoints[i]).length;
					segmentsLength.push(l);
					totalLength += l;
				}
			}
			else if (_type == SplineType.Bezier)
			{
				this.computeBezierLength();
			}
			else if (_type == SplineType.Nurb)
			{
				this.computeNurbLength();
			}
			else
			{
				this.initCatmullRomWayPoints(controlPoints);
				this.computeCatmulLength();
			}
		}

		/**
		 * This method computes the Catmull Rom curve length.
		 */
		private function computeCatmulLength():void
		{
			var l:Number = 0;
			if (controlPoints.length > 1)
			{
				var cLength:int = (controlPoints.length - 1);
				for (var i:int = 0; i < cLength; i++)
				{
					l = CurveAndSurfaceMath.getCatmullRomP1toP2Length(CRcontrolPoints[i], CRcontrolPoints[i + 1], CRcontrolPoints[i + 2], CRcontrolPoints[i + 3], 0, 1, curveTension);
					segmentsLength.push(l);
					totalLength += l;
				}
			}
		}

		/**
		 * This method calculates the Bezier curve length.
		 */
		private function computeBezierLength():void
		{
			var l:Number = 0;
			if (controlPoints.length > 1)
			{
				var i:int = 0;
				while (i < controlPoints.length - 1)
				{
					l = CurveAndSurfaceMath.getBezierP1toP2Length(controlPoints[i], controlPoints[i + 1], controlPoints[i + 2], controlPoints[i + 3]);

					segmentsLength.push(l);

					totalLength += l;

					i += 3;
				}
			}
		}

		/**
		 * This method calculates the NURB curve length.
		 */
		private function computeNurbLength():void
		{
			//TODO: implement
		}

		/**
		 * Iterpolate a position on the spline
		 * @param value a value from 0 to 1 that represent the postion between the curent control point and the next one
		 * @param currentControlPoint the current control point
		 * @param store a vector to store the result (use null to create a new one that will be returned by the method)
		 * @return the position
		 */
		public function interpolate(value:Number, currentControlPoint:int, store:Vector3f = null):Vector3f
		{
			if (store == null)
			{
				store = new Vector3f();
			}

			switch (_type)
			{
				case SplineType.CatmullRom:
					CurveAndSurfaceMath.interpolateCatmullRomVector(value, curveTension, CRcontrolPoints[currentControlPoint], CRcontrolPoints[currentControlPoint + 1], CRcontrolPoints[currentControlPoint + 2], CRcontrolPoints[currentControlPoint + 3], store);
					break;
				case SplineType.Linear:
					FastMath.lerpVector3(controlPoints[currentControlPoint], controlPoints[currentControlPoint + 1], value, store);
					break;
				case SplineType.Bezier:
					CurveAndSurfaceMath.interpolateBezierVector(value, controlPoints[currentControlPoint], controlPoints[currentControlPoint + 1], controlPoints[currentControlPoint + 2], controlPoints[currentControlPoint + 3], store);
					break;
				case SplineType.Nurb:
					CurveAndSurfaceMath.interpolateNurbs(value, this, store);
					break;
				default:
			}
			return store;
		}

		/**
		 * returns the curve tension
		 */
		public function getCurveTension():Number
		{
			return curveTension;
		}

		/**
		 * sets the curve tension
		 *
		 * @param curveTension the tension
		 */
		public function setCurveTension(curveTension:Number):void
		{
			this.curveTension = curveTension;
			if (_type == SplineType.CatmullRom)
			{
				this.computeTotalLength();
			}
		}

		/**
		 * returns true if the spline cycle
		 */
		public function isCycle():Boolean
		{
			return cycle;
		}

		/**
		 * set to true to make the spline cycle
		 * @param cycle
		 */
		public function setCycle(cycle:Boolean):void
		{
			if (_type != SplineType.Nurb)
			{
				if (controlPoints.length >= 2)
				{
					if (this.cycle && !cycle)
					{
						controlPoints.length = (controlPoints.length - 1);
					}

					if (!this.cycle && cycle)
					{
						controlPoints.push(controlPoints[0]);
					}
					this.cycle = cycle;
					this.computeTotalLength();
				}
				else
				{
					this.cycle = cycle;
				}
			}
		}

		/**
		 * return the total lenght of the spline
		 */
		public function getTotalLength():Number
		{
			return totalLength;
		}

		/**
		 * return the type of the spline
		 */
		public function get type():int
		{
			return _type;
		}

		/**
		 * Sets the type of the spline
		 * @param type
		 */
		public function set type(type:int):void
		{
			_type = type;
			computeTotalLength();
		}

		/**
		 * returns this spline control points
		 */
		public function getControlPoints():Vector.<Vector3f>
		{
			return controlPoints;
		}

		public function getControlPointAt(index:int):Vector3f
		{
			return controlPoints[index];
		}

		/**
		 * returns a list of float representing the segments lenght
		 */
		public function getSegmentsLength():Vector.<Number>
		{
			return segmentsLength;
		}

		public function getSegmentLengthAt(i:int):Number
		{
			return segmentsLength[i];
		}

		//////////// NURBS getters /////////////////////

		/**
		 * This method returns the minimum nurb curve knot value. Check the nurb type before calling this method. It the curve is not of a Nurb
		 * type - NPE will be thrown.
		 * @return the minimum nurb curve knot value
		 */
		public function getMinNurbKnot():Number
		{
			return knots[basisFunctionDegree - 1];
		}

		/**
		 * This method returns the maximum nurb curve knot value. Check the nurb type before calling this method. It the curve is not of a Nurb
		 * type - NPE will be thrown.
		 * @return the maximum nurb curve knot value
		 */
		public function getMaxNurbKnot():Number
		{
			return knots[weights.length];
		}

		/**
		 * This method returns NURBS' spline knots.
		 * @return NURBS' spline knots
		 */
		public function getKnots():Vector.<Number>
		{
			return knots;
		}

		/**
		 * This method returns NURBS' spline weights.
		 * @return NURBS' spline weights
		 */
		public function getWeights():Vector.<Number>
		{
			return weights;
		}

		/**
		 * This method returns NURBS' spline basis function degree.
		 * @return NURBS' spline basis function degree
		 */
		public function getBasisFunctionDegree():int
		{
			return basisFunctionDegree;
		}
	}
}


