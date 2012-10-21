package org.angle3d.app.state
{

	import org.angle3d.app.Application;
	import org.angle3d.renderer.RenderManager;

	/**
	 * The <code>AppStateManager</code> holds a list of {@link AppState}s which
	 * it will update and render.<br/>
	 * When an {@link AppState} is attached or detached, the
	 * {@link AppState#stateAttached(com.jme3.app.state.AppStateManager) } and
	 * {@link AppState#stateDetached(com.jme3.app.state.AppStateManager) } methods
	 * will be called respectively.
	 *
	 * <p>The lifecycle for an attached AppState is as follows:</p>
	 * <ul>
	 * <li>stateAttached() : called when the state is attached on the thread on which
	 *                       the state was attached.
	 * <li>initialize() : called ONCE on the render thread at the beginning of the next
	 *                    AppStateManager.update().
	 * <li>stateDetached() : called when the state is attached on the thread on which
	 *                       the state was detached.  This is not necessarily on the
	 *                       render thread and it is not necessarily safe to modify
	 *                       the scene graph, etc..
	 * <li>cleanup() : called ONCE on the render thread at the beginning of the next update
	 *                 after the state has been detached or when the application is
	 *                 terminating.
	 * </ul>
	 *
	 */
	public class AppStateManager
	{
		private var states:Vector.<AppState>;
		private var app:Application;

		public function AppStateManager(app:Application)
		{
			states = new Vector.<AppState>();
			this.app = app;
		}

		/**
		 * Check if a state is attached or not.
		 *
		 * @param state The state to check
		 * @return True if the state is currently attached to this AppStateManager.
		 *
		 * @see AppStateManager#attach(org.angle3d.app.state.AppState)
		 */
		public function hasState(state:AppState):Boolean
		{
			return states.indexOf(state) != -1;
		}

		private function removeState(state:AppState):Boolean
		{
			var i:int = states.indexOf(state);
			if (i != -1)
			{
				states.splice(i, 1);
				return true;
			}
			return false;
		}

		/**
		 * Attach a state to the AppStateManager, the same state cannot be attached
		 * twice.
		 *
		 * @param state The state to attach
		 * @return True if the state was successfully attached, false if the state
		 * was already attached.
		 */
		public function attach(state:AppState):Boolean
		{
			if (!hasState(state))
			{
				state.stateAttached(this);
				states.push(state);
				return true;
			}
			else
			{
				return false;
			}
		}

		/**
		 * Detaches the state from the AppStateManager.
		 *
		 * @param state The state to detach
		 * @return True if the state was detached successfully, false
		 * if the state was not attached in the first place.
		 */
		public function detach(state:AppState):Boolean
		{
			if (hasState(state))
			{
				state.stateDetached(this);
				return removeState(state);
			}
			else
			{
				return false;
			}
		}

		/**
		 * Returns the first state that is an instance of subpublic class of the specified public class.
		 * @param <T>
		 * @param stateClass
		 * @return First attached state that is an instance of stateClass
		 */
		public function getState(c:Class):AppState
		{
			var length:int = states.length;
			for (var i:int = 0; i < length; i++)
			{
				var state:AppState = states[i];
				if (state is c)
				{
					return state;
				}
			}
			return null;
		}

		/**
		 * Calls update for attached states, do not call directly.
		 * @param tpf Time per frame.
		 */
		public function update(tpf:Number):void
		{
			var length:int = states.length;
			for (var i:int = 0; i < length; i++)
			{
				var state:AppState = states[i];

				if (!state.isInitialized())
				{
					state.initialize(this, app);
				}

				if (state.enabled)
				{
					state.update(tpf);
				}
			}
		}

		/**
		 * Calls render for all attached states, do not call directly.
		 * @param rm The RenderManager
		 */
		public function render(rm:RenderManager):void
		{
			var length:int = states.length;
			for (var i:int = 0; i < length; i++)
			{
				var state:AppState = states[i];

				if (!state.isInitialized())
				{
					state.initialize(this, app);
				}

				if (state.enabled)
				{
					state.render(rm);
				}
			}
		}

		/**
		 * Calls render for all attached states, do not call directly.
		 */
		public function postRender():void
		{
			var length:int = states.length;
			for (var i:int = 0; i < length; i++)
			{
				var state:AppState = states[i];

				if (!state.isInitialized())
				{
					state.initialize(this, app);
				}

				if (state.enabled)
				{
					state.postRender();
				}
			}
		}

		/**
		 * Calls cleanup on attached states, do not call directly.
		 */
		public function cleanup():void
		{
			var length:int = states.length;
			for (var i:int = 0; i < length; i++)
			{
				var state:AppState = states[i];
				state.postRender();
			}
		}
	}
}

