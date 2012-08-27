package three.scenes;
import three.core.Object3D;
import three.materials.Material;
import three.lights.Light;
import three.cameras.Camera;
import three.objects.Bone;
/**
 * ...
 * @author andy
 */

class Scene extends Object3D
{
	public var fog:Fog;
	public var overrideMaterial:Material;
	
	public var __objects:Array<Object3D>;
	public var __lights:Array<Light>;
	
	public var __objectsAdded:Array<Object3D>;
	public var __objectsRemoved:Array<Object3D>;

	public function new() 
	{
		super();
		
		this.fog = null;
		this.overrideMaterial = null;

		this.matrixAutoUpdate = false;

		this.__objects = [];
		this.__lights = [];

		this.__objectsAdded = [];
		this.__objectsRemoved = [];
	}
	
	public function __addObject(object:Object3D):Void
	{
		if (Std.is(object,Light))
		{
			var light:Light = cast(object, Light);
			var i:Int = untyped this.__lights.indexOf(light);
			if (i == -1) 
			{
				this.__lights.push(light);
			}

			if (light.target != null && light.target.parent == null) 
			{
				this.add(light.target);
			}

		} 
		else if (!( Std.is(object,Camera) || Std.is(object,Bone) )) 
		{
			var i:Int = untyped this.__objects.indexOf(object);
			if (i == -1) 
			{
				this.__objects.push(object);
				this.__objectsAdded.push(object);

				// check if previously removed
				var i:Int = untyped this.__objectsRemoved.indexOf(object);
				if (i != -1) 
				{
					this.__objectsRemoved.splice(i, 1);
				}
			}
		}

		for (c in 0...object.children.length) 
		{
			this.__addObject(object.children[c]);
		}
	}

	public function __removeObject(object:Object3D):Void
	{
		if ( Std.is(object,Light)) 
		{
			var i:Int = untyped this.__lights.indexOf(object);
			if (i != -1) 
			{
				this.__lights.splice(i, 1);
			}
		}
		else if (!( Std.is(object,Camera) )) 
		{
			var i:Int = untyped this.__objects.indexOf(object);
			if (i != -1) 
			{
				this.__objects.splice(i, 1);
				this.__objectsRemoved.push(object);

				// check if previously added
				var ai:Int = untyped this.__objectsAdded.indexOf(object);
				if (ai != -1) 
				{
					this.__objectsAdded.splice(ai, 1);
				}
			}
		}

		for (c in 0...object.children.length) 
		{
			this.__removeObject(object.children[c]);
		}
	}

}