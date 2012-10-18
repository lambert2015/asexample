package org.angle3d.particles.attribute
{
	import org.angle3d.math.FastMath;

	public class DynamicAttributeOscillate extends DynamicAttribute
	{
		private var mOscillationType:int;
		private var mFrequency:Number;
		private var mPhase:Number;
		private var mBase:Number;
		private var mAmplitude:Number;

		public function DynamicAttributeOscillate()
		{
			super();

			type = DynamicAttributeType.DAT_OSCILLATE;

			mOscillationType = OscillationType.OSCT_SINE;
			mFrequency = 1.0;
			mPhase = 0.0;
			mBase = 0.0;
			mAmplitude = 1.0;
		}

		public function getOscillationType():int
		{
			return mOscillationType;
		}

		public function setOscillationType(value:int):void
		{
			mOscillationType = value;
		}

		public function getFrequency():Number
		{
			return mFrequency;
		}

		public function setFrequency(value:Number):void
		{
			mFrequency = value;
		}

		public function getPhase():Number
		{
			return mPhase;
		}

		public function setPhase(value:Number):void
		{
			mPhase = value;
		}

		public function getBase():Number
		{
			return mBase;
		}

		public function setBase(value:Number):void
		{
			mBase = value;
		}

		public function getAmplitude():Number
		{
			return mAmplitude;
		}

		public function setAmplitude(value:Number):void
		{
			mAmplitude = value;
		}

		override public function getValue(x:Number):Number
		{
			switch (mOscillationType)
			{
				case OscillationType.OSCT_SINE:
					return mBase + mAmplitude * Math.sin(mPhase + mFrequency * x * Math.PI * 2);
					break;
				case OscillationType.OSCT_SQUARE:
					return mBase + mAmplitude * FastMath.signum(Math.sin(mPhase + mFrequency * x * Math.PI * 2));
					break;
			}

			return 0;
		}

		override public function copyAttributesTo(dynamicAttribute:DynamicAttribute):void
		{
			if (!dynamicAttribute || dynamicAttribute.type != DynamicAttributeType.DAT_OSCILLATE)
				return;

			var dynAttr:DynamicAttributeOscillate = dynamicAttribute as DynamicAttributeOscillate;
			dynAttr.mOscillationType = mOscillationType;
			dynAttr.mFrequency = mFrequency;
			dynAttr.mPhase = mPhase;
			dynAttr.mBase = mBase;
			dynAttr.mAmplitude = mAmplitude;
		}
	}
}
