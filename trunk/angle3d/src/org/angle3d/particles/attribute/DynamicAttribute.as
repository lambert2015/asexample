package org.angle3d.particles.attribute
{
	/**	
	 *The DynamicAttribute class or its child classes encapsulate an attribute with specific (dynamic) behaviour.
	 *This class provides a uniform interface for retrieving the value of an attribute, while the calculation of
	 *this value may vary. Each subclass provides its own implementation of the getValue() function and the calling
	 *application doesn't need to know about the underlying logic. A subclass could just return a value that has 
	 *previously been set, but it can also return a value that is randomly generated by a pre-defined min/max interval.
	 *The DynamicAttribute class is used in situations where different behaviour of a certain attribute is needed,
	 *but where implementation of this behaviour may not be scattered or duplicated within the application that needs 
	 *it.
	 */
	public class DynamicAttribute
	{
		public var type:int;
		
		public function DynamicAttribute()
		{
		}
		
		public function getValue(x:Number):Number
		{
			return 0;
		}
		
		public function copyAttributesTo(attribute:DynamicAttribute):void
		{
			
		}
	}
}