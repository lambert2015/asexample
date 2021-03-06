package org.angle3d.collision;

import org.angle3d.bounding.BoundingVolume;
import org.angle3d.math.Matrix4f;
import org.angle3d.utils.Cloneable;

/**
 * <code>CollisionData</code> is an interface that can be used to
 * do triangle-accurate collision between bounding volumes and rays.
 *
 * @author Kirill Vainer
 */
interface CollisionData extends Cloneable
{
	function collideWith(other:Collidable, worldMatrix:Matrix4f, worldBound:BoundingVolume, results:CollisionResults):Int;
}


