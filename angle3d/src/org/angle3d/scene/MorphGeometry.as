package org.angle3d.scene
{
	import org.angle3d.scene.control.MorphControl;
	import org.angle3d.scene.mesh.Mesh;
	import org.angle3d.scene.mesh.MorphMesh;

	public class MorphGeometry extends Geometry
	{
		private var _morphMesh : MorphMesh;

		private var _control : MorphControl;

		public function MorphGeometry(name : String, mesh : MorphMesh = null)
		{
			super(name, mesh);

			_control = new MorphControl();
			addControl(_control);
		}

		public function setAnimationSpeed(speed : Number) : void
		{
			_control.setAnimationSpeed(speed);
		}

		public function playAnimation(animationName : String, loop : Boolean = true) : void
		{
			_control.playAnimation(animationName, loop);
		}

		public function stop() : void
		{
			_control.stop();
		}

		override public function setMesh(mesh : Mesh) : void
		{
			_morphMesh = mesh as MorphMesh;
			super.setMesh(mesh);
		}

		public function get morphMesh() : MorphMesh
		{
			return _morphMesh;
		}
	}
}
