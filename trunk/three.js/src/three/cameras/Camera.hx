package three.cameras;
import three.core.Object3D;
import three.math.Matrix4;
import three.math.Vector3;

/**
 * ...
 * @author andy
 */

class Camera extends Object3D
{
	public var matrixWorldInverse:Matrix4;
	
	public var projectionMatrix:Matrix4;
	
	public var projectionMatrixInverse:Matrix4;

	public function new() 
	{
		super();
		
		this.matrixWorldInverse = new Matrix4();

		this.projectionMatrix = new Matrix4();
		this.projectionMatrixInverse = new Matrix4();
	}
	
	override public function lookAt(target:Vector3):Void
	{
		// TODO: Add hierarchy support.
		
		this.matrix.lookAt(this.position, target, this.up);
		
		if (this.rotationAutoUpdate)
		{
			this.rotation.setEulerFromRotationMatrix(this.matrix, this.eulerOrder);
		}
	}
	
}