package org.angle3d.app.state
{
	import org.angle3d.app.Application;
	import org.angle3d.renderer.RenderManager;

	/**
	 * <code>AbstractAppState</code> implements some common methods
	 * that make creation of AppStates easier.
	 * @author Kirill Vainer
	 */
	public class AbstractAppState implements AppState
	{
		/**
		 * <code>initialized</code> is set to true when the method
		 * {@link AbstractAppState#initialize(org.angle3d.app.state.AppStateManager, org.angle3d.app.Application) }
		 * is called. When {@link AbstractAppState#cleanup() } is called, <code>initialized</code>
		 * is set back to false.
		 */
		protected var mInitialized:Boolean;
		protected var mEnabled:Boolean;

		public function AbstractAppState()
		{
			mInitialized=false;
			mEnabled=true;
		}

		/**
		 * Called to initialize the AppState.
		 *
		 * @param stateManager The state manager
		 * @param app
		 */
		public function initialize(stateManager:AppStateManager, app:Application):void
		{
			mInitialized=true;
		}

		/**
		 * @return True if <code>initialize()</code> was called on the state,
		 * false otherwise.
		 */
		public function isInitialized():Boolean
		{
			return mInitialized;
		}

		/**
		 * Enable or disable the functionality of the <code>AppState</code>.
		 * The effect of this call depends on implementation. An
		 * <code>AppState</code> starts as being enabled by default.
		 *
		 * @param active activate the AppState or not.
		 */
		public function set enabled(value:Boolean):void
		{
			this.mEnabled=value;
		}

		/**
		 * @return True if the <code>AppState</code> is enabled, false otherwise.
		 *
		 * @see AppState#setEnabled(boolean)
		 */
		public function get enabled():Boolean
		{
			return mEnabled;
		}

		/**
		 * Called when the state was attached.
		 *
		 * @param stateManager State manager to which the state was attached to.
		 */
		public function stateAttached(stateManager:AppStateManager):void
		{

		}

		/**
		 * Called when the state was detached.
		 *
		 * @param stateManager The state manager from which the state was detached from.
		 */
		public function stateDetached(stateManager:AppStateManager):void
		{

		}

		/**
		 * Called to update the state.
		 *
		 * @param tpf Time per frame.
		 */
		public function update(tpf:Number):void
		{

		}

		/**
		 * Render the state.
		 *
		 * @param rm RenderManager
		 */
		public function render(rm:RenderManager):void
		{

		}

		/**
		 * Called after all rendering commands are flushed.
		 */
		public function postRender():void
		{

		}

		/**
		 * Cleanup the game state.
		 */
		public function cleanup():void
		{
			mInitialized=false;
		}

	}
}

