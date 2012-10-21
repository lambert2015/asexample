package org.angle3d.particles.attribute
{

	/* This class generates random values within a given minimum and maximum interval.
	*/
	public class DynamicAttributeRandom extends DynamicAttribute
	{
		protected var mMin:Number;
		protected var mMax:Number;

		public function DynamicAttributeRandom()
		{
			super();

			type=DynamicAttributeType.DAT_RANDOM;
		}

		public function setMin(min:Number):void
		{
			mMin=min;
		}

		public function getMin():Number
		{
			return mMin;
		}

		public function setMax(max:Number):void
		{
			mMax=max;
		}

		public function getMax():Number
		{
			return mMax;
		}

		public function setMinMax(min:Number, max:Number):void
		{
			mMin=min;
			mMax=max;
		}

		override public function getValue(x:Number):Number
		{
			return mMin + (mMax - mMin) * Math.random();
		}

		override public function copyAttributesTo(dynamicAttribute:DynamicAttribute):void
		{
			if (!dynamicAttribute || dynamicAttribute.type != DynamicAttributeType.DAT_RANDOM)
				return;

			var dynAttr:DynamicAttributeRandom=dynamicAttribute as DynamicAttributeRandom;
			dynAttr.mMin=mMin;
			dynAttr.mMax=mMax;
		}
	}
}
