package org.angle3d.material.shader
{
	import flash.utils.Timer;

	import org.angle3d.math.Matrix3f;
	import org.angle3d.math.Matrix4f;
	import org.angle3d.math.Vector2f;
	import org.angle3d.math.Vector3f;
	import org.angle3d.math.Vector4f;
	import org.angle3d.renderer.Camera3D;

	/**
	 * <code>UniformBindingManager</code> helps {@link RenderManager} to manage
	 * {@link UniformBinding uniform bindings}.
	 *
	 * The {@link #updateUniformBindings(java.util.List) } will update
	 * a given list of uniforms based on the current state
	 * of the manager.
	 *
	 */
	//TODO 添加更多的指令
	public class UniformBindingManager
	{
		private var timer:Timer;
		private var near:Number, far:Number;
		private var viewX:int, viewY:int, viewWidth:int, viewHeight:int;
		private var camUp:Vector3f=new Vector3f(), camLeft:Vector3f=new Vector3f(), camDir:Vector3f=new Vector3f(), camLoc:Vector3f=new Vector3f();

		private var tmpMatrix:Matrix4f=new Matrix4f();
		private var tmpMatrix3:Matrix3f=new Matrix3f();

		private var viewMatrix:Matrix4f=new Matrix4f();
		private var projMatrix:Matrix4f=new Matrix4f();
		private var viewProjMatrix:Matrix4f=new Matrix4f();
		private var worldMatrix:Matrix4f=new Matrix4f();

		private var worldViewMatrix:Matrix4f=new Matrix4f();
		private var worldViewProjMatrix:Matrix4f=new Matrix4f();
		private var normalMatrix:Matrix3f=new Matrix3f();

		private var worldMatrixInv:Matrix4f=new Matrix4f();
		private var viewMatrixInv:Matrix4f=new Matrix4f();
		private var projMatrixInv:Matrix4f=new Matrix4f();
		private var viewProjMatrixInv:Matrix4f=new Matrix4f();
		private var worldViewMatrixInv:Matrix4f=new Matrix4f();
		private var normalMatrixInv:Matrix3f=new Matrix3f();
		private var worldViewProjMatrixInv:Matrix4f=new Matrix4f();

		private var viewPort:Vector4f=new Vector4f();
		private var resolution:Vector2f=new Vector2f();
		private var resolutionInv:Vector2f=new Vector2f();
		private var nearFar:Vector2f=new Vector2f();

		public function UniformBindingManager()
		{
		}

		/**
		 * Internal use only.
		 * Updates the given list of uniforms with {@link UniformBinding uniform bindings}
		 * based on the current world state.
		 */
		public function updateUniformBindings(params:Vector.<Uniform>):void
		{
			// assums worldMatrix is properly set.
			var pLength:int=params.length;
			for (var i:int=0; i < pLength; i++)
			{
				var u:Uniform=params[i];
				switch (u.binding)
				{
					case UniformBinding.WorldMatrix:
						u.setMatrix4(worldMatrix);
						break;
					case UniformBinding.ViewMatrix:
						u.setMatrix4(viewMatrix);
						break;
					case UniformBinding.ProjectionMatrix:
						u.setMatrix4(projMatrix);
						break;
					case UniformBinding.ViewProjectionMatrix:
						u.setMatrix4(viewProjMatrix);
						break;
					case UniformBinding.WorldViewMatrix:
						//tmpMatrix.copyFrom(viewMatrix);
						//tmpMatrix.multLocal(worldMatrix);
						tmpMatrix.copyAndMultLocal(viewMatrix, worldMatrix);
						u.setMatrix4(tmpMatrix);
						break;
					case UniformBinding.NormalMatrix:
						//tmpMatrix.copyFrom(viewMatrix);
						//tmpMatrix.multLocal(worldMatrix);
						tmpMatrix.copyAndMultLocal(viewMatrix, worldMatrix);
						tmpMatrix3=tmpMatrix.toMatrix3f();
						tmpMatrix3.invertLocal();
						tmpMatrix3.transposeLocal();
						u.setMatrix3(tmpMatrix3);
						break;
					case UniformBinding.WorldViewProjectionMatrix:
						//tmpMatrix.copyFrom(viewProjMatrix);
						//tmpMatrix.multLocal(worldMatrix);
						tmpMatrix.copyAndMultLocal(viewProjMatrix, worldMatrix);
						u.setMatrix4(tmpMatrix);
						break;
					case UniformBinding.WorldMatrixInverse:
						tmpMatrix.copyFrom(worldMatrix);
						tmpMatrix.invertLocal();
						u.setMatrix4(tmpMatrix);
						break;
					case UniformBinding.ViewMatrixInverse:
						tmpMatrix.copyFrom(viewMatrix);
						tmpMatrix.invertLocal();
						u.setMatrix4(tmpMatrix);
						break;
					case UniformBinding.ProjectionMatrixInverse:
						tmpMatrix.copyFrom(projMatrix);
						tmpMatrix.invertLocal();
						u.setMatrix4(tmpMatrix);
						break;
					case UniformBinding.ViewProjectionMatrixInverse:
						tmpMatrix.copyFrom(viewProjMatrix);
						tmpMatrix.invertLocal();
						u.setMatrix4(tmpMatrix);
						break;
					case UniformBinding.WorldViewMatrixInverse:
						//tmpMatrix.copyFrom(viewMatrix);
						//tmpMatrix.multLocal(worldMatrix);
						tmpMatrix.copyAndMultLocal(viewMatrix, worldMatrix);
						tmpMatrix.invertLocal();
						u.setMatrix4(tmpMatrix);
						break;
					case UniformBinding.NormalMatrixInverse:
						//tmpMatrix.copyFrom(viewMatrix);
						//tmpMatrix.multLocal(worldMatrix);
						tmpMatrix.copyAndMultLocal(viewMatrix, worldMatrix);
						tmpMatrix3=tmpMatrix.toMatrix3f();
						tmpMatrix3.invertLocal();
						tmpMatrix3.transposeLocal();
						tmpMatrix3.invertLocal();
						u.setMatrix3(tmpMatrix3);
						break;
					case UniformBinding.WorldViewProjectionMatrixInverse:
						//tmpMatrix.copyFrom(viewProjMatrix);
						//tmpMatrix.multLocal(worldMatrix);
						tmpMatrix.copyAndMultLocal(viewProjMatrix, worldMatrix);
						tmpMatrix.invertLocal();
						u.setMatrix4(tmpMatrix);
						break;
					case UniformBinding.CameraPosition:
						u.setVector3(camLoc);
						break;
					case UniformBinding.CameraDirection:
						u.setVector3(camDir);
						break;
					case UniformBinding.ViewPort:
						viewPort.setTo(viewX, viewY, viewWidth, viewHeight);
						u.setVector4(viewPort);
						break;
				}
			}
		}

		/**
		 * Internal use only. Sets the world matrix to use for future
		 * rendering. This has no effect unless objects are rendered manually
		 * using {@link Material#render(com.jme3.scene.Geometry, com.jme3.renderer.RenderManager) }.
		 * Using {@link #renderGeometry(com.jme3.scene.Geometry) } will
		 * override this value.
		 *
		 * @param mat The world matrix to set
		 */
		public function setWorldMatrix(mat:Matrix4f):void
		{
			worldMatrix.copyFrom(mat);
		}

		/**
		 * Set the timer that should be used to query the time based
		 * {@link UniformBinding}s for material world parameters.
		 *
		 * @param timer The timer to query time world parameters
		 */
		public function setTimer(timer:Timer):void
		{
			this.timer=timer;
		}

		public function setCamera(cam:Camera3D, viewMatrix:Matrix4f, projMatrix:Matrix4f, viewProjMatrix:Matrix4f):void
		{
			this.viewMatrix.copyFrom(viewMatrix);
			this.projMatrix.copyFrom(projMatrix);
			this.viewProjMatrix.copyFrom(viewProjMatrix);

			camLoc.copyFrom(cam.location);
			cam.getLeft(camLeft);
			cam.getUp(camUp);
			cam.getDirection(camDir);

			near=cam.frustumNear;
			far=cam.frustumFar;
		}

		public function setViewPort(viewX:int, viewY:int, viewWidth:int, viewHeight:int):void
		{
			this.viewX=viewX;
			this.viewY=viewY;
			this.viewWidth=viewWidth;
			this.viewHeight=viewHeight;
		}
	}
}
