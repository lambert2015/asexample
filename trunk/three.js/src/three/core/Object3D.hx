package three.core;
import three.math.EulerOrder;
import three.math.Matrix4;
import three.math.Quaternion;
import three.math.Vector3;
import three.utils.Logger;
import three.scenes.Scene;
/**
 * ...
 * @author andy
 */

class Object3D 
{
	public static var Object3DCount:Int = 0;

	public var id:Int;
	public var name:String;
	public var properties:Dynamic;
	public var parent:Object3D;
	public var children:Array<Object3D>;
	
	public var up:Vector3;
	public var position:Vector3;
	public var rotation:Vector3;
	public var eulerOrder:EulerOrder;
	public var scale:Vector3;
	
	public var renderDepth:Int;
	
	public var rotationAutoUpdate:Bool;
	
	public var matrix:Matrix4;
	public var matrixWorld:Matrix4;
	public var matrixRotationWorld:Matrix4;
	
	public var matrixAutoUpdate:Bool;
	public var matrixWorldNeedsUpdate:Bool;
	
	public var quaternion:Quaternion;
	public var useQuaternion:Bool;
	
	public var boundRadius:Float;
	public var boundRadiusScale:Float;
	
	public var visible:Bool;
	public var castShadow:Bool;
	public var receiveShadow:Bool;
	
	public var frustumCulled:Bool;
	
	public var _modelViewMatrix:Matrix4;
	public var _normalMatrix:Matrix4;
	
	private var _vector:Vector3;
	public function new() 
	{
		id = Object3DCount++;
		
		name = "";
		properties = { };
		
		parent = null;
		children = new Array<Object3D>();
		
		up = new Vector3(0, 1, 0);
		position = new Vector3();
		rotation = new Vector3();
		eulerOrder = EulerOrder.XYZ;
		scale = new Vector3(1, 1, 1);
		
		renderDepth = null;
		
		rotationAutoUpdate = true;
		
		matrix = new Matrix4();
		matrixWorld = new Matrix4();
		matrixRotationWorld = new Matrix4();
		
		matrixAutoUpdate = true;
		matrixWorldNeedsUpdate = true;
		
		quaternion = new Quaternion();
		useQuaternion = false;
		
		boundRadius = 0.0;
		boundRadiusScale = 1.0;
		
		visible = true;
		castShadow = false;
		receiveShadow = false;
		
		frustumCulled = true;
		
		_vector = new Vector3();
		
	}
	
	public function applyMatrix(matrix:Matrix4):Void
	{
		this.matrix.multiply(matrix, this.matrix);

		this.scale.getScaleFromMatrix(this.matrix);

		var mat = new Matrix4().extractRotation(this.matrix);
		this.rotation.setEulerFromRotationMatrix(mat, this.eulerOrder);

		this.position.getPositionFromMatrix(this.matrix);
	}
	
	public function translate(distance:Float, axis:Vector3):Void
	{
		this.matrix.rotateAxis(axis);
		this.position.addSelf(axis.multiplyScalar(distance));
	}
	
	public function translateX(distance:Float):Void
	{
		this.translate(distance, Vector3.X_AXIS);
	}
	
	public function translateY(distance:Float):Void
	{
		this.translate(distance, Vector3.Y_AXIS);
	}
	
	public function translateZ(distance:Float):Void
	{
		this.translate(distance, Vector3.Z_AXIS);
	}
	
	public function lookAt(vector:Vector3):Void
	{
		// TODO: Add hierarchy support.
		this.matrix.lookAt(vector, this.position, this.up);

		if (this.rotationAutoUpdate) 
		{
			this.rotation.setEulerFromRotationMatrix(this.matrix, this.eulerOrder);
		}
	}
	
	public function add(object:Object3D):Void
	{
		if (object == this) 
		{
			Logger.warn('Object3D.add: An object can\'t be added as a child of itself.');
			return;
		}

		if ( Std.is(object, Object3D)) 
		{
			if (object.parent != null) 
			{
				object.parent.remove(object);
			}

			object.parent = this;
			this.children.push(object);

			// add to scene
			var scene:Scene = cast(this,Scene);
			while (scene.parent != null)
			{
				scene = cast(scene.parent,Scene);
			}

			if (scene != null && Std.is(scene,Scene)) 
			{
				scene.__addObject(object);
			}
		}
	}
	
	public function remove(object:Object3D):Void
	{
		var index:Int = untyped this.children.indexOf(object);

		if (index != -1)
		{
			object.parent = null;
			this.children.splice(index, 1);

			// remove from scene
			var scene:Scene = cast(this,Scene);
			while (scene.parent != null) 
			{
				scene = cast(scene.parent,Scene);
			}

			if (scene != null && Std.is(scene,Scene))
			{
				scene.__removeObject(object);
			}
		}
	}
	
	public function getChildByName(name:String, recursive:Bool):Object3D
	{
		var child:Object3D;
		for ( c in 0...this.children.length) 
		{
			child = this.children[c];
			if (child.name == name) 
			{
				return child;
			}

			if (recursive) 
			{
				child = child.getChildByName(name, recursive);
				if (child != null) 
				{
					return child;
				}
			}
		}
		return null;
	}
	
	public function updateMatrix():Void
	{
		this.matrix.setPosition(this.position);

		if (this.useQuaternion) 
		{
			this.matrix.setRotationFromQuaternion(this.quaternion);
		} 
		else 
		{
			this.matrix.setRotationFromEuler(this.rotation, this.eulerOrder);
		}

		if (this.scale.x != 1 || this.scale.y != 1 || this.scale.z != 1) 
		{
			this.matrix.scale(this.scale);
			this.boundRadiusScale = Math.max(this.scale.x, Math.max(this.scale.y, this.scale.z));
		}

		this.matrixWorldNeedsUpdate = true;
	}
	
	public function updateMatrixWorld(force:Bool = false):Void
	{
		if (this.matrixAutoUpdate)
			this.updateMatrix();

		if (this.matrixWorldNeedsUpdate || force) 
		{
			if (this.parent != null) 
			{
				this.matrixWorld.multiply(this.parent.matrixWorld, this.matrix);
			}
			else 
			{
				this.matrixWorld.copy(this.matrix);
			}
			this.matrixWorldNeedsUpdate = false;
			force = true;
		}

		// update children
		for (i in 0...this.children.length) 
		{
			this.children[i].updateMatrixWorld(force);
		}
	}
	
	private static var _m1:Matrix4 = new Matrix4();
	public function worldToLocal(vector:Vector3):Vector3
	{
		return _m1.getInverse(this.matrixWorld).multiplyVector3(vector);
	}
	
	public function localToWorld(vector:Vector3):Vector3
	{
		return this.matrixWorld.multiplyVector3(vector);
	}
	
	public function clone():Object3D
	{
		return null;
	}
	
}