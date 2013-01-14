//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{

	/**
	 * Type Matcher Factory
	 */
	public interface ITypeMatcherFactory extends ITypeMatcher
	{
		/**
		 * Creates a clone of this matcher
		 * @return The clone
		 */
		function clone():TypeMatcher;
	}
}

