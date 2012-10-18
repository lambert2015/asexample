package org.angle3d.math;
import org.angle3d.math.Vector3f;

/**
 * Represents a translation, rotation and scale in one object.
 * 
 */
class Transform 
{
	public var rotation:Quaternion;
	public var translation:Vector3f;
	public var scale:Vector3f;

	public function new(trans:Vector3f = null, rot:Quaternion = null, scale:Vector3f = null)
	{
		this.rotation = new Quaternion();
		this.translation = new Vector3f();
		this.scale = new Vector3f(1, 1, 1);
		
		if (trans != null)
		{
			this.translation.copyFrom(trans);
		}
		
		if (rot != null)
		{
			this.rotation.copyFrom(rot);
		}
		
		if (scale != null)
		{
			this.scale.copyFrom(scale);
		}
	}
	
	/**
     * Sets this rotation to the given Quaternion value.
     * @param rot The new rotation for this matrix.
     * @return this
     */
	public inline function setRotation(rot:Quaternion):Void
	{
		this.rotation.copyFrom(rot);
	}
	
	public inline function setRotationTo(x:Float,y:Float,z:Float,w:Float):Void
	{
		this.rotation.setTo(x, y, z, w);
	}
	
	/**
     * Return the rotation quaternion in this matrix.
     * @return rotation quaternion.
     */
	//public function getRotation():Quaternion
	//{
		//return rotation;
	//}
	
	/**
     * Sets this translation to the given value.
     * @param trans The new translation for this matrix.
     * @return this
     */
	public inline function setTranslation(trans:Vector3f):Void
	{
		this.translation.copyFrom(trans);
	}
	
	public function setTranslationTo(x:Float,y:Float,z:Float):Void
	{
		this.translation.setTo(x,y,z);
	}
	
	/**
     * Return the translation vector in this matrix.
     * @return translation vector.
     */
	//public function getTranslation():Vector3f
	//{
		//return translation;
	//}
	
	/**
     * Sets this scale to the given value.
     * @param scale The new scale for this matrix.
     * @return this
     */
	public inline function setScale(scale:Vector3f):Void
	{
		this.scale.copyFrom(scale);
	}
	
	public inline function setScaleTo(x:Float,y:Float,z:Float):Void
	{
		this.scale.setTo(x, y, z);
	}
	
	/**
     * Return the scale vector in this matrix.
     * @return scale vector.
     */
	//public function getScale():Vector3f
	//{
		//return scale;
	//}
	
	/**
     * Stores this translation value into the given vector3f.  If trans is null, a new vector3f is created to
     * hold the value.  The value, once stored, is returned.
     * @param trans The store location for this matrix's translation.
     * @return The value of this matrix's translation.
     */
	public function copyTranslationTo(trans:Vector3f = null):Vector3f
	{
		if (trans == null)
		{
			trans = new Vector3f();
		}
		trans.copyFrom(this.translation);
		return trans;
	}
	
	/**
     * Stores this rotation value into the given Quaternion.  If quat is null, a new Quaternion is created to
     * hold the value.  The value, once stored, is returned.
     * @param quat The store location for this matrix's rotation.
     * @return The value of this matrix's rotation.
     */
	public function copyRotationTo(quat:Quaternion = null):Quaternion
	{
		if (quat == null)
		{
			quat = new Quaternion();
		}
		quat.copyFrom(this.rotation);
		return quat;
	}
	
	public function copyScaleTo(scale:Vector3f = null):Vector3f
	{
		if (scale == null)
		{
			scale = new Vector3f();
		}
		scale.copyFrom(this.scale);
		return scale;
	}
	
	/**
     * Sets this matrix to the interpolation between the first matrix and the second by delta amount.
     * @param t1 The begining transform.
     * @param t2 The ending transform.
     * @param delta An amount between 0 and 1 representing how far to interpolate from t1 to t2.
     */
	public function interpolateTransforms(t1:Transform, t2:Transform, delta:Float):Void
	{
		this.rotation.slerp2(t1.rotation, t2.rotation, delta);
		t1.translation.interpolate(t2.translation, delta, this.translation);
		t1.scale.interpolate(t2.scale, delta, this.scale);
	}
	
	/**
     * Changes the values of this matrix acording to it's parent.  Very similar to the concept of Node/Spatial transforms.
     * @param parent The parent matrix.
     * @return This matrix, after combining.
     */
	public function combineWithParent(parent:Transform):Void
	{
		this.scale.multiplyLocal(parent.scale);
		parent.rotation.multiply(this.rotation, this.rotation);
		this.translation.multiplyLocal(parent.scale);
		
		parent.rotation.multVecLocal(translation);
		translation.addLocal(parent.translation);
	}
	
	public function transformVector(inVec:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
            result = new Vector3f();
			
			
		// multiply with scale first, then rotate, finally translate
		result.copyFrom(inVec);
		result.multiplyLocal(scale);
		rotation.multVecLocal(result);
		result.addLocal(translation);
		return result;
	}
	
	public function transformInverseVector(inVec:Vector3f, result:Vector3f = null):Vector3f
	{
		if (result == null)
            result = new Vector3f();
			
		// The author of this code should look above and take the inverse of that
        // But for some reason, they didnt ..
//        in.subtract(translation, store).divideLocal(scale);
//        rot.inverse().mult(store, store);
			
		result.x = inVec.x - translation.x;
		result.y = inVec.y - translation.y;
		result.z = inVec.z - translation.z;
		
		var inverseRot:Quaternion = rotation.inverse();
		inverseRot.multVecLocal(result);
		
		result.x /= scale.x;
		result.y /= scale.y;
		result.z /= scale.z;
		
		return result;
	}
	
	/**
     * Loads the identity.  Equal to translation=1,1,1 scale=0,0,0 rot=0,0,0,1.
     */
	public function loadIdentity():Void
	{
		translation.setTo(0, 0, 0);
		scale.setTo(1, 1, 1);
		rotation.setTo(0, 0, 0, 1);
	}
	
	public function copyFrom(trans:Transform):Void
	{
		translation.copyFrom(trans.translation);
		rotation.copyFrom(trans.rotation);
		scale.copyFrom(trans.scale);
	}
	
	public function clone():Transform
	{
		var result:Transform = new Transform();
		result.copyFrom(this);
		return result;
	}
}