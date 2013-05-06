package quake3.core;
import nme.geom.Matrix3D;
import nme.geom.Vector3D;
import quake3.math.Matrix3DUtil;

class Camera3D 
{
	private var _position:Vector3D;
	private var _viewMatrix:Matrix3D;
	private var _projectionMatrix:Matrix3D;
	private var _viewProjectionMatrix:Matrix3D;

	public function new() 
	{
		_position = new Vector3D();
		_viewMatrix = new Matrix3D();
		_projectionMatrix = new Matrix3D();
		_viewProjectionMatrix = new Matrix3D();
	}
	
	public function makePerspective(fovy:Float, aspect:Float, near:Float, far:Float):Void
	{
		_projectionMatrix = Matrix3DUtil.makePerspective(fovy, aspect, near, far);
	}
	
	public function update():Void
	{
		_viewProjectionMatrix.copyFrom(_viewMatrix);
		_viewProjectionMatrix.append(_projectionMatrix);
	}
	
	public function getViewMatrix():Matrix3D
	{
		return _viewMatrix;
	}
	
	public function getProjectionMatrix():Matrix3D
	{
		return _projectionMatrix;
	}
	
	public function getViewProjectionMatrix():Matrix3D
	{
		return _viewProjectionMatrix;
	}
	
}