package org.angle3d.scene.control;

import org.angle3d.renderer.RenderManager;
import org.angle3d.renderer.ViewPort;
import org.angle3d.scene.Spatial;

/**
 * An interface for scene-graph controls.
 * <p>
 * <code>Control</code>s are used to specify certain update and render logic
 * for a {@link Spatial}.
 *
 * @author Kirill Vainer
 */
interface Control
{

	/**
	 * Creates a clone of the Control, the given Spatial is the cloned
	 * version of the spatial to which this control is attached to.
	 * @param spatial
	 * @return
	 */
	function cloneForSpatial(spatial:Spatial):Control;

	/**
	 * @param spatial the spatial to be controlled. This should not be called
	 * from user code.
	 */
	var spatial(get,set):Spatial;

	/**
	 * @param enabled Enable or disable the control. If disabled, update()
	 * should do nothing.
	 */
	var enabled(get,set):Bool;

	/**
	 * Updates the control. This should not be called from user code.
	 * @param tpf Time per frame.
	 */
	function update(tpf:Float):Void;

	/**
	 * Should be called prior to queuing the spatial by the RenderManager. This
	 * should not be called from user code.
	 *
	 * @param rm
	 * @param vp
	 */
	function render(rm:RenderManager, vp:ViewPort):Void;

	function clone():Control;
}

