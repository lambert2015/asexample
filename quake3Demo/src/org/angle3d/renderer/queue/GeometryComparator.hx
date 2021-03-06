package org.angle3d.renderer.queue;

import org.angle3d.renderer.Camera3D;
import org.angle3d.scene.Geometry;


/**
 * <code>GeometryComparator</code> is a special version of {@link Comparator}
 * that is used to sort geometries for rendering in the {@link RenderQueue}.
 * 
 * @author Kirill Vainer
 */
interface GeometryComparator 
{
    /**
     * Set the camera to use for sorting.
     * 
     * @param cam The camera to use for sorting
     */
	function setCamera(cam:Camera3D):Void;
	
	function compare(o1:Geometry, o2:Geometry):Int;
	
}