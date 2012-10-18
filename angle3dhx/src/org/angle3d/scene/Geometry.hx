package org.angle3d.scene;
import flash.errors.Error;
import flash.Lib;
import org.angle3d.bounding.BoundingVolume;
import org.angle3d.collision.Collidable;
import org.angle3d.collision.CollisionResults;
import org.angle3d.material.Material;
import org.angle3d.math.Matrix4f;
import org.angle3d.scene.mesh.Mesh;
import org.angle3d.utils.Assert;

/**
 * Geometry defines a leaf node of the scene graph. The leaf node
 * contains the geometric data for rendering objects. It manages all rendering
 * information such as a Material object to define how the surface
 * should be shaded and the Mesh data to contain the actual geometry.
 * 
 */
class Geometry extends Spatial
{
	private var mesh:Mesh;
	
	private var lodLevel:Int;
	
	private var material:Material;
	
	 /**
     * When true, the geometry's transform will not be applied.
     */
	private var ignoreTransform:Bool;
	
	private var cachedWorldMat:Matrix4f;

	public function new(name:String, mesh:Mesh = null) 
	{
		super(name);
		
		ignoreTransform = false;
		cachedWorldMat = new Matrix4f();
		lodLevel = 0;
		
		material = new Material();
		
		if (mesh != null)
		{
			this.mesh = mesh;
		}
	}
	
	/**
     * @return If ignoreTransform mode is set.
	 * 
     * @see Geometry#setIgnoreTransform(boolean) 
     */
	public function isIgnoreTransform():Bool
	{
		return ignoreTransform;
	}
	
	/**
     * @param ignoreTransform If true, the geometry's transform will not be applied.
     */
	public function setIgnoreTransform(value:Bool):Void
	{
		ignoreTransform = value;
	}
	
	/**
     * Sets the LOD level to use when rendering the mesh of this geometry.
     * Level 0 indicates that the default index buffer should be used,
     * levels [1, LodLevels + 1] represent the levels set on the mesh
     * with {@link Mesh#setLodLevels(org.angle3d.scene.VertexBuffer[]) }.
     * 
     * @param lod The lod level to set
     */
    override public function setLodLevel(lod:Int):Void
	{
        lodLevel = lod;
    }
	
	/**
     * Returns the LOD level set with {@link #setLodLevel(int) }.
     * 
     * @return the LOD level set
     */
	public function getLodLevel():Int
	{
		return lodLevel;
	}
	
	/**
     * Returns this geometry's mesh vertex count.
     * 
     * @return this geometry's mesh vertex count.
     * 
     * @see Mesh#getVertexCount() 
     */
	override public function getVertexCount():Int
	{
		return mesh.getVertexCount();
	}
	
	/**
     * Returns this geometry's mesh triangle count.
     * 
     * @return this geometry's mesh triangle count.
     * 
     * @see Mesh#getTriangleCount() 
     */
	override public function getTriangleCount():Int
	{
		return mesh.getTriangleCount();
	}
	
	
	/**
     * Sets the mesh to use for this geometry when rendering.
     * 
     * @param mesh the mesh to use for this geometry
     * 
     */
	public function setMesh(mesh:Mesh):Void
	{
		if (mesh == null)
		{
			return;
		}
		
		this.mesh = mesh;
		setBoundRefresh();
	}
	
	/**
     * Returns the mseh to use for this geometry
     * 
     * @return the mseh to use for this geometry
     * 
     * @see #setMesh(org.angle3d.scene.Mesh) 
     */
	public function getMesh():Mesh
	{
		return mesh;
	}
	
	/**
     * Sets the material to use for this geometry.
     * 
     * @param material the material to use for this geometry
     */
	override public function setMaterial(material:Material):Void
	{
		this.material = material;
	}
	
	/**
     * Returns the material that is used for this geometry.
     * 
     * @return the material that is used for this geometry
     * 
     * @see #setMaterial(org.angle3d.material.Material) 
     */
	public function getMaterial():Material
	{
		return material;
	}
	
	/**
     * @return The bounding volume of the mesh, in model space.
     */
	public function getModelBound():BoundingVolume
	{
		return mesh.getBound();
	}
	
	/**
     * Updates the bounding volume of the mesh. Should be called when the
     * mesh has been modified.
     */
	override public function updateModelBound():Void
	{
		mesh.updateBound();
        setBoundRefresh();
	}
	
	/**
     * <code>updateWorldBound</code> updates the bounding volume that contains
     * this geometry. The location of the geometry is based on the location of
     * all this node's parents.
     *
     * @see com.jme.scene.Spatial#updateWorldBound()
     */
	override public function updateWorldBound():Void
	{
		super.updateWorldBound();
		
		if (mesh == null)
		{
			throw new Error("Geometry: " + getName() + " has null mesh");
		}
		
		if (mesh.getBound() != null)
		{
			if (ignoreTransform)
			{
				// we do not transform the model bound by the world transform,
                // just use the model bound as-is
				_worldBound = mesh.getBound().clone(_worldBound);
			}
			else
			{
				_worldBound = mesh.getBound().transform(worldTransform, _worldBound);
			}
		}
	}
	
	override private function updateWorldTransforms():Void
	{
		super.updateWorldTransforms();
		
		computeWorldMatrix();
		
		// geometry requires lights to be sorted
		worldLights.sort(true);
	}
	
	/**
     * Recomputes the matrix returned by {@link Geometry#getWorldMatrix() }.
     * This will require a localized transform update for this geometry.
     */
	public function computeWorldMatrix():Void
	{
		// Force a local update of the geometry's transform
        checkDoTransformUpdate();
		
		// Compute the cached world matrix
		cachedWorldMat.loadIdentity();
		cachedWorldMat.setRotationQuaternion(worldTransform.rotation);
		cachedWorldMat.setTranslation(worldTransform.translation);
		
		var scaleMat:Matrix4f = new Matrix4f();
		scaleMat.scaleByVec(worldTransform.scale);
		cachedWorldMat.multLocal(scaleMat);
	}
	
	/**
     * @return A {@link Matrix4f matrix} that transforms the {@link Geometry#getMesh() mesh}
     * from model space to world space. This matrix is computed based on the
     * {@link Geometry#getWorldTransform() world transform} of this geometry.
     * In order to receive updated values, you must call {@link Geometry#computeWorldMatrix() }
     * before using this method.
     */
	public function getWorldMatrix():Matrix4f
	{
		return cachedWorldMat;
	}
	
	/**
     * Sets the model bound to use for this geometry.
     * This alters the bound used on the mesh as well via
     * {@link Mesh#setBound(org.angle3d.bounding.BoundingVolume) } and
     * forces the world bounding volume to be recomputed.
     * 
     * @param modelBound The model bound to set
     */
	override public function setModelBound(bound:BoundingVolume):Void
	{
		this._worldBound = null;
        mesh.setBound(bound);
		setBoundRefresh();
		
		// NOTE: Calling updateModelBound() would cause the mesh
        // to recompute the bound based on the geometry thus making
        // this call useless!
        //updateModelBound();
	}
	
	override public function collideWith(other:Collidable, results:CollisionResults):Int
	{
		// Force bound to update
        checkDoBoundUpdate();
        // Update transform, and compute cached world matrix
        computeWorldMatrix();
		
		Assert.assert((refreshFlags & (Spatial.RF_BOUND | Spatial.RF_TRANSFORM)) == 0, "");
		
		if (mesh != null)
		{
			// NOTE: BIHTree in mesh already checks collision with the
            // mesh's bound
			var prevSize:Int = results.size();
			var added:Int = mesh.collideWith(other, cachedWorldMat, _worldBound, results);
			var newSize:Int = results.size();
			for (i in prevSize...newSize)
			{
				results.getCollisionDirect(i).setGeometry(this);
			}
			return added;
		}
		return 0;
	}
	
	override public function depthFirstTraversal(visitor:SceneGraphVisitor):Void
	{
		visitor.visit(this);
	}
	
	//override private function breadthFirstTraversalQueue(visitor:SceneGraphVisitor,queue:Queue<Spatial>):Void
	//{
		//
	//}
	
	override public function clone(cloneMaterial:Bool = true, ?result:Spatial = null):Spatial
	{
		var geom:Geometry;
		if (result == null)
		{
			geom = new Geometry(this.name + "_clone");
		}
		else
		{
			geom = Lib.as(result,Geometry);
		}
		
		geom = Lib.as(super.clone(cloneMaterial, geom),Geometry);
		
		geom.cachedWorldMat.copyFrom(cachedWorldMat);
		if (material != null)
		{
			if (cloneMaterial)
			{
				geom.material = material.clone();
			}
			else
			{
				geom.material = material;
			}
		}

		return geom;
	}
	
}