package org.angle3d.particles.attribute
{

	/*	This class is an implementation of the DynamicAttribute class in its most simple form. It just returns a value
	that has previously been set.
	@remarks
	Although use of a regular attribute within the class that needs it is preferred, its benefit is that it makes
	use of the generic 'getValue' mechanism of a DynamicAttribute.
	*/
	public class DynamicAttributeFixed extends DynamicAttribute
	{
		protected var mValue:Number;

		public function DynamicAttributeFixed()
		{
			super();

			type = DynamicAttributeType.DAT_FIXED;
		}

		public function setValue(value:Number):void
		{
			mValue = value;
		}

		override public function getValue(x:Number):Number
		{
			return mValue;
		}

		override public function copyAttributesTo(dynamicAttribute:DynamicAttribute):void
		{
			if (!dynamicAttribute || dynamicAttribute.type != DynamicAttributeType.DAT_FIXED)
				return;

			var dynAttr:DynamicAttributeFixed = dynamicAttribute as DynamicAttributeFixed;
			dynAttr.mValue = mValue;
		}

	}
}
