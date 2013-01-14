//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{
	import org.hamcrest.Matcher;
	import org.swiftsuspenders.Injector;

	/**
	 * The Robotlegs context contract
	 */
	public interface IContext
	{
		/**
		 * The context dependency injector
		 */
		function get injector():Injector;

		/**
		 * The context lifecycle
		 */
		function get lifecycle():ILifecycle;

		/**
		 * The current log level
		 */
		function get logLevel():uint;

		/**
		 * Sets the current log level
		 * @param value The log level. Use a constant from LogLevel
		 */
		function set logLevel(value:uint):void;

		/**
		 * Installs custom extensions or bundles into the context
		 * @param extensions Objects or classes implementing IExtension or IBundle
		 * @return this
		 */
		function install(... extensions):IContext;

		/**
		 * Configures the context with custom configurations
		 * @param configs Configuration objects or classes of any type
		 * @return this
		 */
		function configure(... configs):IContext;

		/**
		 * Adds a custom configuration handler
		 * @param matcher Pattern to match configurations
		 * @param handler Handler to process matching configurations
		 * @return this
		 */
		function addConfigHandler(matcher:Matcher, handler:Function):IContext;

		/**
		 * Retrieves a logger for a given source
		 * @param source Logging source
		 * @return Logger
		 */
		function getLogger(source:Object):ILogger;

		/**
		 * Adds a custom log target
		 * @param target Log target
		 * @return this
		 */
		function addLogTarget(target:ILogTarget):IContext;

		/**
		 * Pins instances in memory
		 * @param instances Instances to pin
		 * @return this
		 */
		function detain(... instances):IContext;

		/**
		 * Unpins instances from memory
		 * @param instances Instances to unpin
		 * @return this
		 */
		function release(... instances):IContext;
	}
}
