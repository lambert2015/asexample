//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.StageObserver;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	/**
	 * This extension install an automatic Stage Observer
	 */
	public class StageObserverExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		// Really? Yes, there can be only one.
		private static var _stageObserver:StageObserver;

		private static var _installCount:uint;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			_installCount++;
			_injector = context.injector;
			context.lifecycle.whenInitializing(whenInitializing);
			context.lifecycle.whenDestroying(whenDestroying);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function whenInitializing():void
		{
			if (_stageObserver == null)
			{
				const containerRegistry:ContainerRegistry = _injector.getInstance(ContainerRegistry);
				_stageObserver = new StageObserver(containerRegistry);
			}
		}

		private function whenDestroying():void
		{
			_installCount--;
			if (_installCount == 0)
			{
				_stageObserver.destroy();
				_stageObserver = null;
			}
		}
	}
}
