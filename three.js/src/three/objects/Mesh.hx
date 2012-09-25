package three.objects;
import three.core.Geometry;
import three.core.Object3D;
import three.core.BufferGeometry;
import three.materials.Material;
import three.materials.MeshBasicMaterial;
import three.utils.Logger;
/**
 * ...
 * @author andy
 */

class Mesh extends Object3D
{
	//public var geometry:BufferGeometry;
	//public var material:Material;
	
	public var morphTargetBase:Float;
	public var morphTargetForcedOrder:Array<Dynamic>;
	public var morphTargetInfluences:Array<Float>;
	public var morphTargetDictionary:Dynamic;

	public function new(geometry:Geometry, material:Material = null )
	{
		super();
		
		this.geometry = geometry;
		if (material == null)
		{
			material = new MeshBasicMaterial( { color : Math.random() * 0xffffff, wireframe : true } );
		}
		this.material = material;
		
		if (this.geometry != null)
		{
			// calc bound radius
			if (this.geometry.boundingSphere != null)
			{
				this.geometry.computeBoundingSphere();
			}
			this.boundRadius = this.geometry.boundingSphere.radius;
			
			// setup morph targets
			if (this.geometry.morphTargets.length > 0) 
			{
				this.morphTargetBase = -1;
				this.morphTargetForcedOrder = [];
				this.morphTargetInfluences = [];
				this.morphTargetDictionary = {};

				for (m in 0...this.geometry.morphTargets.length) 
				{
					this.morphTargetInfluences.push(0);
					Reflect.setProperty(this.morphTargetDictionary, this.geometry.morphTargets[m].name, m);
				}
			}
		}
	}
	
	public function getMorphTargetIndexByName(name:String):Int
	{
		if (Reflect.getProperty(this.morphTargetDictionary, name) != null)
		{
			return Reflect.getProperty(this.morphTargetDictionary, name);
		}
		
		#if debug
		Logger.log("Mesh.getMorphTargetIndexByName: morph target " + name + " does not exist. Returning 0.");
		#end
		
		return 0;
	}
	
}