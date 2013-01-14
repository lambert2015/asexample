//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;

	/**
	 * @private
	 */
	public class MediatorMapping implements IMediatorMapping, IMediatorMappingConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _matcher:ITypeFilter;

		/**
		 * @inheritDoc
		 */
		public function get matcher():ITypeFilter
		{
			return _matcher;
		}

		private var _mediatorClass:Class;

		/**
		 * @inheritDoc
		 */
		public function get mediatorClass():Class
		{
			return _mediatorClass;
		}

		private var _guards:Array = [];

		/**
		 * @inheritDoc
		 */
		public function get guards():Array
		{
			return _guards;
		}

		private var _hooks:Array = [];

		/**
		 * @inheritDoc
		 */
		public function get hooks():Array
		{
			return _hooks;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function MediatorMapping(matcher:ITypeFilter, mediatorClass:Class)
		{
			_matcher = matcher;
			_mediatorClass = mediatorClass;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function withGuards(... guards):IMediatorMappingConfig
		{
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withHooks(... hooks):IMediatorMappingConfig
		{
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}
	}
}
