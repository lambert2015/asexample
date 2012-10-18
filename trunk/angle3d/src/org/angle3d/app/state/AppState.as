package org.angle3d.app.state
{
	import org.angle3d.app.Application;
	import org.angle3d.renderer.RenderManager;

	/**
	 * AppState represents a continously executing code inside the main loop.
	 * An <code>AppState</code> can track when it is attached to the
	 * {@link AppStateManager} or when it is detached. <br/><code>AppState</code>s
	 * are initialized in the render thread, upon a call to {@link AppState#initialize(org.angle3d.app.state.AppStateManager, org.angle3d.app.Application) }
	 * and are de-initialized upon a call to {@link AppState#cleanup()}.
	 * Implementations should return the correct value with a call to
	 * {@link AppState#isInitialized() } as specified above.<br/>
	 *
	 *
	 */
	public interface AppState
	{
		/**
		 * Called to initialize the AppState.
		 *
		 * @param stateManager The state manager
		 * @param app
		 */
		function initialize(stateManager:AppStateManager, app:Application):void;

		/**
		 * @return True if <code>initialize()</code> was called on the state,
		 * false otherwise.
		 */
		function isInitialized():Boolean;

		/**
		 * Enable or disable the functionality of the <code>AppState</code>.
		 * The effect of this call depends on implementation. An
		 * <code>AppState</code> starts as being enabled by default.
		 *
		 * @param value active the AppState or not.
		 */
		function set enabled(value:Boolean):void;

		/**
		 * @return True if the <code>AppState</code> is enabled, false otherwise.
		 *
		 * @see AppState#setEnabled(boolean)
		 */
		function get enabled():Boolean;
		/**
		 * Called when the state was attached.
		 *
		 * @param stateManager State manager to which the state was attached to.
		 */
		function stateAttached(stateManager:AppStateManager):void;

		/**
		 * Called when the state was detached.
		 *
		 * @param stateManager The state manager from which the state was detached from.
		 */
		function stateDetached(stateManager:AppStateManager):void;

		/**
		 * Called to update the state.
		 *
		 * @param tpf Time per frame.
		 */
		function update(tpf:Number):void;

		/**
		 * Render the state.
		 *
		 * @param rm RenderManager
		 */
		function render(rm:RenderManager):void;

		/**
		 * Called after all rendering commands are flushed.
		 */
		function postRender():void;

		/**
		 * Cleanup the game state.
		 */
		function cleanup():void;
	}
}

