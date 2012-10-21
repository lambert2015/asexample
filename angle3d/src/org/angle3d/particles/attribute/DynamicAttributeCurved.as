package org.angle3d.particles.attribute
{
	import org.angle3d.math.Spline;
	import org.angle3d.math.Vector2f;

	/**
	 * This is a more complex usage of the DynamicAttribute principle. This class returns a value on an curve.
	 * After setting a number of control points, this class is able to interpolate a point on the curve that is based
	 * on these control points. Interpolation is done in different flavours. 碙inear?provides linear interpolation
	 * of a value on the curve, while 碨pline?generates a smooth curve and the returns a value that lies on that curve.
	 */
	public class DynamicAttributeCurved extends DynamicAttribute
	{
		private var mRange:Number;

		/** Todo
		 */
		private var mSpline:Spline;

		/** Todo
		 */
		private var mInterpolationType:int;

		/** Todo
		 */
		private var mControlPoints:Vector.<Vector2f>;

		public function DynamicAttributeCurved(interpolationType:int = 0)
		{
			super();

			type = DynamicAttributeType.DAT_CURVED;
		}

		public function setInterpolationType(interpolationType:int):void
		{
			if (interpolationType != mInterpolationType)
			{
				// If switched to another InterpolationType, the already existing ControlPoints will be removed.
				removeAllControlPoints();
				mInterpolationType = interpolationType;
			}
		}

		//-----------------------------------------------------------------------
		public function getInterpolationType():int
		{
			return mInterpolationType;
		}

		//-----------------------------------------------------------------------
		override public function getValue(x:Number):Number
		{
			switch (mInterpolationType)
			{
				case InterpolationType.IT_LINEAR:
				{
					// Search the interval in which 'x' resides and apply linear interpolation
					if (mControlPoints.length == 0)
						return 0;

					var cp1:Vector2f = _findNearestControlPoint(x);
					var index:int = mControlPoints.indexOf(cp1) + 1;
					var cp2:Vector2f = mControlPoints[index];
					if (index != mControlPoints.length - 1)
					{
						// Calculate fraction: y = y1 + ((y2 - y1) * (x - x1)/(x2 - x1))
						return cp1.y + (cp2.y - cp1.y) * (x - cp1.x) / (cp2.x - cp1.x);
					}
					else
					{
						return cp1.y;
					}
				}
					break;
//				case InterpolationType.IT_SPLINE:
//				{
//					// Fit using spline
//					if (mSpline.getNumPoints() < 1)
//						return 0;
//					
//					var fraction:Number = x / mRange;
//					return (mSpline.interpolate(fraction < 1.0 ? fraction : 1.0)).y;
//				}
//				break;
			}

			return 0;
		}

		//-----------------------------------------------------------------------
		public function addControlPoint(x:Number, y:Number):void
		{
			mControlPoints.push(new Vector2f(x, y));
		}

		//-----------------------------------------------------------------------
		public function getControlPoints():Vector.<Vector2f>
		{
			return mControlPoints;
		}

		public function processControlPoints():void
		{
			if (mControlPoints.length == 0)
				return;

			//sort
			//std::sort(mControlPoints.begin(), mControlPoints.end(), ControlPointSorter());

			mRange = mControlPoints[mControlPoints.length - 1].x - mControlPoints[0].x;

//				if (mInterpolationType == InterpolationType.IT_SPLINE)
//				{
//					// Add all sorted control points to the spline
//					DynamicAttributeCurved::ControlPointList::iterator it;
//					mSpline.clear();
//					for (it = mControlPoints.begin(); it != mControlPoints.end(); ++it)
//						mSpline.addPoint(Vector3((*it).x, (*it).y, 0));
//				}
		}

		//-----------------------------------------------------------------------
		public function getNumControlPoints():int
		{
			return mControlPoints.length;
		}

		//-----------------------------------------------------------------------
		public function removeAllControlPoints():void
		{
			mControlPoints.length = 0;
		}

		private function _findNearestControlPoint(x:Number):Vector2f
		{
			// Assume that the ControlPointList is not empty
			var count:int = mControlPoints.length;
			for (var i:int = 0; i < count; i++)
			{
				var cp:Vector2f = mControlPoints[i];
				if (x < cp.x)
				{
					if (i == 0)
						return cp;
					else
						return mControlPoints[i--];
				}
			}

			// If not found return the last valid iterator
			return mControlPoints[--i];
		}

		override public function copyAttributesTo(dynamicAttribute:DynamicAttribute):void
		{
			if (!dynamicAttribute || dynamicAttribute.type != DynamicAttributeType.DAT_CURVED)
				return;

			var dynAttr:DynamicAttributeCurved = dynamicAttribute as DynamicAttributeCurved;

			dynAttr.mInterpolationType = mInterpolationType;
			dynAttr.mSpline = mSpline;
			dynAttr.mRange = mRange;

			dynAttr.mControlPoints = mControlPoints.concat();
			dynAttr.processControlPoints();
		}
	}
}
