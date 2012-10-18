package org.angle3d.particles.attribute
{

	public class DynamicAttributeHelper
	{
		public function DynamicAttributeHelper()
		{
		}

		public function calculate(dyn:DynamicAttribute, x:Number, defaultValue:Number):Number
		{
			if (dyn)
			{
				return dyn.getValue(x);
			}

			return defaultValue;
		}
	}
}
