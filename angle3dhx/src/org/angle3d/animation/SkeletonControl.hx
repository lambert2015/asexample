package org.angle3d.animation;
import flash.Vector;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.scene.control.AbstractControl;

/**
 * The Skeleton control deforms a model according to a skeleton, 
 * It handles the computation of the deformation matrices and performs 
 * the transformations on the mesh
 * 
 * @author Rémy Bouquet Based on AnimControl by Kirill Vainer
 */
class SkeletonControl extends AbstractControl
{
	/**
     * The skeleton of the model
     */
    private var skeleton:Skeleton;
	
	/**
     * List of targets which this controller effects.
     */
	private var targets:Vector<Mesh>;
	
	/**
     * Used to track when a mesh was updated. Meshes are only updated
     * if they are visible in at least one camera.
     */
	private var wasMeshUpdated:Bool;

	/**
     * Creates a skeleton control.
     * The list of targets will be acquired automatically when
     * the control is attached to a node.
     * 
     * @param skeleton the skeleton
     */
	public function new(skeleton:Skeleton) 
	{
		super();
		
		wasMeshUpdated = false;
		
		this.skeleton = skeleton;
	}
	
}